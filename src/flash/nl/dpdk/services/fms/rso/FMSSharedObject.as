/*
Copyright (c) 2008 De Pannekoek en De Kale B.V.,  www.dpdk.nl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
package nl.dpdk.services.fms.rso {
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;

	import nl.dpdk.log.Log;
	import nl.dpdk.services.fms.rso.FMSSharedObjectData;
	import nl.dpdk.services.fms.rso.FMSSharedObjectDataEvent;
	import nl.dpdk.services.fms.rso.FMSSharedObjectEvent;	
	/**
	 * FMSSharedObject is a wrapper class for a Remote SharedObject (RSO).
	 * It encapsulates behaviour and provides an api for consistent communication.
	 * This class dispatches only events of type FMSSharedObjectEvent.
	 * For updates on the RSO, multiple events can be fired in quick succession, but that depends on the number of changes on the RSO.
	 * <p><p>
	 * A typical client of this class will be a subclass of FMSService.
	 * It will handle the different FMSSharedObject event types by either creating domain objects of the data or sending out specific events for them, or by translating it into FMSEvents with a GENERIC type to send generic messages
	 * <p><p>
	 * This class can be subclassed for extra behaviour if needed. 
	 * Diverse hooks are provided for specific stuff that you might want to do on the RSO.
	 * 
	 * 
	 * 
	 * @see FMSSharedObjectEvent
	 * @see FMSSharedObjectData
	 * @see FMSSharedObjectDataEvent
	 * @see FMSService
	 * 
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class FMSSharedObject extends EventDispatcher {
		private var remoteSharedObject : SharedObject;
		private var connection : NetConnection;
		private var readyAfterSynchronization : Boolean;
		private var name : String;

		/**
		 * The constructor is slightly different than the static method SharedObject.getRemote() as it takes a netconnection instead of it's uri.
		 * In most of our applications, data is not directly written to a RSO, but instead handled via calls to the FMS, which then updates the RSO.
		 * This is done for better control of what happens to a RSO. More stuff can be checked by FMS and the user is only allowed to interact in a sandbox.
		 * <p>
		 * After construction, add the listeners to the instance and call connect() to connect to the RSO.
		 * @param name the name of the remote shared object we want to connect to. 
		 * @param connection the NetConnection object. CAUTION: this is not the same as the uri that is normally passed in when using SharedObject.getRemote()
		 * @param persistence is the RSO persistent or not
		 * @param secure is the RSO secure or not
		 */
		public function FMSSharedObject(name : String, connection : NetConnection, persistence : Object = false, secure : Boolean = false) {
			setConnection(connection);
			this.name = name;
			remoteSharedObject = SharedObject.getRemote(name, getConnection().uri, persistence, secure);
			addListeners();
		}

		
		/**
		 * dispatches an FMSSharedObjectEvent.ERROR_CONNECT if connect fails
		 * @param params string containing name/value pairs (name=sh&action=execute)
		 * 
		 */	
		public final function connect(params : String = null) : void {
			try {
				getRemoteSharedObject().connect(getConnection(), params);
			}catch(e : Error) {
				dispatchEvent(new FMSSharedObjectEvent(FMSSharedObjectEvent.ERROR_CONNECT, e.message));
			}
		}
		
		public function getRawSharedObjectDataFor(id: *):*{
			return getRemoteSharedObject().data[id];
		}

		
		/**
		 * destroy cleans up the object.
		 * always call this method when the client is done using this object.
		 */
		public final function destroy() : void {
			try {
				removeListeners();
				close();
			}catch(e : Error) {
				Log.status(e.message, toString());
			}
		}

		
		/**
		 * writes data to the RSO.
		 * We discourage this way of updating a RSO exept for very simple cases where there is no scripting done on the FMS.
		 * Updating of a RSO by the server is more powerful because the server is in charge instead of an unsafe flash client.
		 * The client needs to have write permission to the RSO (set by the FMS, but defaults to write all).
		 * @param name the name of the property value to write to, this might be an int (preferred) or string. for connected users we use a RemoteId.
		 * @param data an object to store in the specified property of the RSO.
		 */
		public function write(name : *, data : *) : void {
			getRemoteSharedObject().setProperty(name, data);
		}

		
		/**
		 * hook for subclassing, be sure to call super.removeListeners();
		 */
		protected function removeListeners() : void {
			remoteSharedObject.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			remoteSharedObject.removeEventListener(SyncEvent.SYNC, onSynchronize);
			remoteSharedObject.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onASyncError);
		}

		
		/**
		 * hook for subclassing, be sure to call super.addListeners();
		 */
		protected function addListeners() : void {
			remoteSharedObject.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			remoteSharedObject.addEventListener(SyncEvent.SYNC, onSynchronize);
			remoteSharedObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onASyncError);
		}

		
		private function onASyncError(event : AsyncErrorEvent) : void {
			dispatchEvent(new FMSSharedObjectEvent(FMSSharedObjectEvent.ERROR_ASYNC, event.error.message));
		}

		
		/**
		 * this is where the magic happens!
		 * the different cases of changes on the RSO's data are caught here and delegated to a specific method.
		 * These methods handle the data and some of them can be subclassed for enhanced functionality.
		 */
		private function onSynchronize(event : SyncEvent) : void {
			/*
			 
			When you initially connect to a remote shared object that is persistent locally and/or on the server, 
			all the properties of this object are set to empty strings.
			Otherwise, Flash sets code to "clear", "success", "reject", "change", or "delete". 
			
			- A value of "clear" means either that you have successfully connected to a remote shared object that is not persistent on the server,
			or the client, or that all the properties of the object have been deleted.
			for example, when the client and server copies of the object are so far out of sync that Flash Player resynchronizes the client object with the server object. 
			In the latter case, SyncEvent.SYNC is dispatched and the "code" value is set to "change". 
			- A value of "success" means the client changed the shared object. 
			- A value of "reject" means the client tried unsuccessfully to change the object; instead, another client changed the object. 
			- A value of "change" means another client changed the object or the server resynchronized the object. 
			- A value of "delete" means the attribute was deleted. 
			 
			 */
			//all changed properties
			var list : Array = event.changeList;
			var listLength : int = list.length;
			//the status code for each item in the list
			var code : String;
			//the name of the property that changed
			var name : String;
			//an oldValue, in case of an existing item that changed, else null
			var oldValue : *;
			for(var i : int = 0;i < listLength;++i) {
				code = list[i].code;
				name = list[i].name;
				switch(code) {
					//changed value
					case "change":
						//performance optimizer, get value where needed, not before the switch
						oldValue = list[i].oldValue;
						if(oldValue == null) {
							//check if change is fired after delete... (check: no)
							//the data is new, cause there is no old value
							onDataNew(name);
						} else {
							//the data already existed, so it is changed. the references to the oldvalue is not interesting, as we have already store the values locally in a domain object.
							//we can lookup the old values there if we need them.
							onDataChanged(name);
						}
						break;
					case "delete":
						//we only have the 'name' property						
						onDataDeleted(name);
						break;	
					case "clear":
						onDataCleared();
						break;
					//updates that are done by the flash client directly
					case "success":
						onDataWriteSuccess(name);
						break;
						//updates that are directly done by the flash client that are rejected.
					case "reject":
						onDataWriteRejected(name);
						break;
					default:
						//nothing
						break;
				}
			}
			
			//only use the shared object after it has been synched for the first time
			//maybe we should just get rid of this for performance, it is almost never used anyway, mostly when clients directly manipulate a shared object.
			if(!getReadyAfterSynchronization()) {
				setReadyAfterSynchronization(true);	
				dispatchEvent(new FMSSharedObjectDataEvent(FMSSharedObjectDataEvent.SYNCHED));
			}
		}

		
		/**
		 * 
		 */
		protected function onDataCleared() : void {
			dispatchEvent(new FMSSharedObjectDataEvent(FMSSharedObjectDataEvent.CLEARED));
		}

		
		/**
		 * when the direct data change is rejected on the RSO, this method is called.
		 * This might fail if there is no write permission on the RSO (set by the FMS).
		 */
		private function onDataWriteRejected(name : String) : void {
			dispatchEvent(new FMSSharedObjectDataEvent(FMSSharedObjectDataEvent.WRITE_REJECTED, getSharedObjectDataFor(name)));
		}

		
		/**
		 * when the direct data change is accepted on the RSO, this method is called.
		 * Write permission on the RSO needs to be set by the FMS for this to work.
		 */
		private function onDataWriteSuccess(name : String) : void {
			dispatchEvent(new FMSSharedObjectDataEvent(FMSSharedObjectDataEvent.WRITE_SUCCESS, getSharedObjectDataFor(name)));
		}

		
		private function onDataDeleted(name : String) : void {
			dispatchEvent(new FMSSharedObjectDataEvent(FMSSharedObjectDataEvent.DELETED, getSharedObjectDataFor(name)));
		}

		
		private function onDataChanged(name : String) : void {
			dispatchEvent(new FMSSharedObjectDataEvent(FMSSharedObjectDataEvent.CHANGED, getSharedObjectDataFor(name)));
		}

		
		private function onDataNew(name : String) : void {
			dispatchEvent(new FMSSharedObjectDataEvent(FMSSharedObjectDataEvent.NEW, getSharedObjectDataFor(name)));
		}

		
		private function getSharedObjectDataFor(id : *) : FMSSharedObjectData {
			return new FMSSharedObjectData(id, getRemoteSharedObject().data[id]);
		}

		
		/**
		 * The different NetStatus events for this RSO
		 */		 
		private function onNetStatus(event : NetStatusEvent) : void {
			var code : String = event.info.code;	
			switch (code) {
				case "SharedObject.Flush.Success":
					onFlushSucces(code);
					break;
				case "SharedObject.Flush.Failed":
				
					onFlushFailed(code);
				case "SharedObject.BadPersistence":
					onBadPersistence(code);
				
				case "SharedObject.UriMismatch":
					onUriMismatch(code);
					break;
				default:
					onUnknowNetStatus(code);
					break;
			}
		}

		
		/**
		 * possible hook for subclassing
		 */
		protected function onUnknowNetStatus(code : String) : void {
			Log.status("FMSSharedObject.onUnknowNetStatus(code): " + code, toString());
		}

		
		/**
		 * possible hook for subclassing
		 */
		protected function onFlushSucces(code : String) : void {
		}

		
		private function onBadPersistence(code : String) : void {
			doNetStatusError(code);
		}

		
		private function onFlushFailed(code : String) : void {
			doNetStatusError(code);
		}

		
		private function onUriMismatch(code : String) : void {
			doNetStatusError(code);
		}

		
		protected function doNetStatusError(code : String) : void {
			dispatchEvent(new FMSSharedObjectEvent(FMSSharedObjectEvent.ERROR_NETSTATUS, code));
		}

		
		/**
		 * closes the connection with the shared object
		 */
		public final function close() : void {
			try {
				getRemoteSharedObject().close();
			}catch(e : Error) {
				Log.status(e.message, toString());	
			}			
		}

		
		private function getConnection() : NetConnection {
			return connection;
		}

		
		private function setConnection(connection : NetConnection) : void {
			this.connection = connection;
		}

		
		/**
		 * get a reference to the remote shared object
		 */
		protected final function getRemoteSharedObject() : SharedObject {
			return remoteSharedObject;
		}

		
		override public function toString() : String {
			return "FMSSharedObject[" + name + "]";
		}

		
		public final function getReadyAfterSynchronization() : Boolean {
			return readyAfterSynchronization;
		}

		
		public final function setReadyAfterSynchronization(readyAfterSynchronization : Boolean) : void {
			this.readyAfterSynchronization = readyAfterSynchronization;
		}
	}
}
