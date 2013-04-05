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
package nl.dpdk.services.fms {
	import nl.dpdk.log.Log;
	import nl.dpdk.services.fms.user.RemoteId;
	import nl.dpdk.services.fms.user.RemoteIdEvent;

	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;

	/**
	 * FMSService provides a basic/abstract service implementation for connecting to the flash media server (fms).
	 * This class should/can be subclassed with some overriden methods, for which hooks are provided, and with context specific methods to call services on the fms.
	 * Call the constructor when subclassing.
	 * <p><p>
	 * Subclassing is done in order to:
	 * <li>provide the right methods to call via the flash media server (for an entrance of the fms into the flash client)
	 * <li>provide the right (proxy/adapter) interface to make the calls to the fms server that are defined there.
	 * <li>provide specific handling of Remote Shared Objects by defining the RSO's and their event handlers. See FMSSharedObject for implementing RSO's.
	 * This is especially convenient as RSO's cannot be subclassed (they are created by a static factory method)
	 * <li>provide specific Stream handling.
	 * <p><p>
	 * This class or its subclasses provides the api for both the client/context and for the flash media server.
	 * both outgoing data to, and incoming data from the mediaserver is handled by this class and it's methods.
	 * <p><p>
	 * The client of this class should register to all FMSEvent event types and to RemoteIdEvent event types.
	 * <p>
	 * A client of a subclass of FMSService should also register to domain specific events, probably related to RSO updates and specific calls from fms into the flash client.
	 * @see FMSEvent
	 * @see RemoteIdEvent
	 * @see FMSSharedObject
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class FMSService extends EventDispatcher {
		//the rtmp gateway of the flash media server
		private var gateway : String;
		/*
		 * the netconnection object. 
		 * the netconnection's object client is the FMSService itself
		 */ 
		private var connection : NetConnection;
		/*
		 * the default id is for non connected users
		 */
		private var remoteId : RemoteId = new RemoteId(RemoteId.NOT_REMOTE);

		
		/**
		 * constructor, always call the constructor when subclassing this class.
		 * @param gateway the rtmp address for the media server application
		 */
		public function FMSService(gateway : String) {
			setGateway(gateway);
			initialize();
		}

		
		/**
		 * template method, this method is called by the constructor
		 */
		private function initialize() : void {
			setConnection();
			setEncoding();	
			setup();
		}

		
		/**
		 * hook for extra initialization
		 * called after all basic initialization is done, but before the listeners are added.
		 * This might be used to setup other variables etc.
		 * When this method is called, there is not connection yet!!!
		 */
		protected function setup() : void {
		}

		
		/**
		 * this connects the NetConnection object to the flash media server and should explicitely be called by the client of this class to connect.
		 * override setConnection to get the right type of netconnection object to connect to the mediaserver.
		 * @see setConnection()
		 */
		public final function connect() : void {
			getConnection().addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			try {
				getConnection().connect(getGateway());
			}catch(e : Error) {
				//ArgumentError — The URI passed to the command parameter is improperly formatted.  
				//IOError — The connection failed. This might happen if you call connect() from within a netStatus event handler, which is not allowed.  
				//SecurityError — Local untrusted SWF files cannot communicate with the Internet. You can avoid this problem by reclassifying this SWF file as local-with-networking or trusted.  
				dispatchEvent(new FMSEvent(FMSEvent.ERROR_GENERIC, "connection failure: " + e.message));
			}	
		}

		
		/**
		 * Adds a context header to the AMF packet structure. This header is sent with every future AMF packet
		 */
		public final function addHeader(operation : String, mustUnderstand : Boolean = false, param : Object = null) : void {
			getConnection().addHeader(operation, mustUnderstand, param);
		}

		
		/**
		 * sets the gateway (rtmp address) for the flash media server application
		 */
		protected function setGateway(gateway : String) : void {
			this.gateway = gateway;
		}

		
		/**
		 * synchronous method that gets the RemoteId for this client (the connected client).
		 * the remoteId is set via the dpdk opensource fms framework automatically directly when connecting,
		 * in which case it will fire a RemoteIdEvent.
		 * 
		 * You will not be forced to use the framework though. In that case the remoteId will contain a value RemoteId.NOT_REMOTE
		 * 
		 * @see RemoteIdEvent
		 * @see RemoteId
		 */
		public final function getRemoteId() : RemoteId {
			return remoteId;
		}

		

		
		/**
		 * handles the remoteId by dispatching a RemoteIdEvent
		 * This can be via the NetConnection itself (when the fms pushes the id) or via the explicit call getRemoteId().
		 */
		private function handleRemoteId(remoteId : RemoteId, succes : Boolean = true) : void {
			if(succes) {
				this.remoteId = remoteId;
				dispatchEvent(new RemoteIdEvent(RemoteIdEvent.REMOTE_ID, remoteId));
			} else {
				//the remoteId call failed, so we set it explicitely to a non remoteId id and use a seperate event type to make it clear.
				dispatchEvent(new RemoteIdEvent(RemoteIdEvent.REMOTE_ID_FAILURE, remoteId));
			}
		}

		
		/**
		 * sets the encoding for the netconnection.
		 * fms works with amf0 as the encoding.
		 * therefore, this method should only be used when an upgrade of fms supports amf3
		 */
		protected final function setEncodingAmf3() : void {
			getConnection().objectEncoding = ObjectEncoding.AMF3;
		}

		
		/**
		 * only override when amf3 for fms is released or when other updates on the amf protocol are issued.
		 */
		protected function setEncoding() : void {
			setEncodingAmf0();
		}

		
		/**
		 * sets the encoding for the netconnection, this is also the default encoding used by this class.
		 * fms works with amf0 as the encoding.
		 */
		protected final function setEncodingAmf0() : void {
			getConnection().objectEncoding = ObjectEncoding.AMF0;
		}

		
		/**
		 * returns the gateway addres, the rtmp address for the fms application
		 */
		public final function getGateway() : String {
			return gateway;
		}

		
		/**
		 * factory method.

		 * @return NetConnection  We may need the connection to setup connections to a remote shared object or a netstream. 
		 * We are always directly able to call methods on the NetConnection to the fms, but this (and setting up RSO's or a netstream) is preferably done via a subclass of FMSService and a clearly defined api.
		 * @see setConnection();
		 */
		public function getConnection() : NetConnection {
			return connection;
		}

		
		/**
		 * when the connection is lost this method should be called.
		 * connect() cannot be called again as the netconnection should be reset.
		 * all further state in this class should probably have to be rebuilt.
		 */
		public function reconnect() : void {
			destroy();
			initialize();
			connect();	
		}

		
		
		private function setConnection() : void {
			this.connection = new NetConnection();
			//route all methods that come in via the fms server to the specific implementation/subclass of FMSService
			this.connection.client = this;
		}

		
		/**
		 * destructor method, called by the client to clean up this class.
		 */
		public final function destroy() : void {
			die();
		}


		
		/**
		 * the method that cleans up this class, can be overriden for specific behaviour.
		 * use super.die() when overriding.
		 */
		protected function die() : void {
			try {
				removeListeners();	
				getConnection().close();
			}catch(e : Error) {
				Log.status(e.message, toString());
			}
		}

		
		/**
		 * Adds the listeners on the concrete NetConnection implementation.
		 * this method is called as part of a template method and is automatically called after instatiation of this service.
		 * can be overriden to add specific listeners, but be sure to call super.addListeners() too!
		 */
		protected function addListeners() : void {
			getConnection().addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}

		
		/**
		 * removes the listeners 
		 * This method is automatically called when a client destroys the service.
		 * when overriding, be sure to call super.removeListeners()
		 * @see destroy();
		 */
		protected function removeListeners() : void {
			getConnection().removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}

		
		/**
		 * receives the events from the NetConnection for the connection itself.
		 * TODO, implement all NetStatus codes (see flash help) except for RSO codes, which are handled by FMSSharedObject
		 * @param e	NetStatusEvent
		 */
		protected function onNetStatus(e : NetStatusEvent) : void {
			var info : Object = e.info;
			var message : String = info.code;
			switch(info.code) {
				case 'NetConnection.Connect.Success':
					handleConnected();
					break;
				case 'NetConnection.Connect.Rejected':
					if(info.application != null && info.application.message != null) {
						handleRejected(info.application.message);
					} else {
						handleRejected(message);
					}
					break;
				case 'NetConnection.Connect.Failed':
				case 'NetConnection.Connect.appShutdown':
				case 'NetConnection.Connect.invalidApp':
				case 'NetConnection.Connect.Closed':
					handleDisconnected(message);
					break;
				case 'NetConnection.Call.Failed':
				case 'NetConnection.Call.Prohibited':
				case 'NetConnection.Call.BadVersion':
					handleBadCall(message);
					break;
				default:
					handleGenericStatus(message);
					break;
			}
		}

		
		protected function handleGenericStatus(message : String) : void {
			dispatchEvent(new FMSEvent(FMSEvent.ERROR_GENERIC, message));
		}

		
		protected function handleBadCall(message : String) : void {
			dispatchEvent(new FMSEvent(FMSEvent.ERROR_CALL_FAILED, message));
		}

		
		protected function handleDisconnected(message : String) : void {
			trace("FMSService.handleDisconnected(message)");
			//set the client back to itself, apparently, close is called by the fms and it is not implemented on the FMSService (which it complained about)
			//this.connection.client = connection;
			dispatchEvent(new FMSEvent(FMSEvent.ERROR_DISCONNECTED, message));
		}
		
		protected function handleRejected(message : String) : void {
			trace("FMSService.handleRejected(message)");
			//set the client back to itself, apparently, close is called by the fms when rejected and it is not implemented on the FMSService (which it complained about)
			this.connection.client = connection;
			dispatchEvent(new FMSEvent(FMSEvent.ERROR_REJECTED, message));
		}

		/**
		 * override this method to add functionality when succesfully connecting to the flash media server.
		 * This might be used to connect to remote shared objects.
		 * addListeners() is called automatically for you.
		 * call super.handleConnected() when overriding.
		 */
		protected function handleConnected() : void {
			addListeners();
			dispatchEvent(new FMSEvent(FMSEvent.CONNECTED));
		}

		
		/**
		 * @return whether or not the FMSService is connected to the media server via it's NetConnection.
		 */
		public final function getConnected() : Boolean {
			return getConnection().connected;	
		}

		
		override public function toString() : String {
			return "FMSService";
		}

		
		
		
		
		
		/**
		 * 
		 * ##########
		 * incoming methods on the netconnection 
		 * #########
		 * 
		 */



		/**
		 * when a remote id is explicitely passed from the fms, this method can be called from the fms.
		 * A RemoteIdEvent is dispatched containing the remoteId
		 */
		public function receiveRemoteId(id : int) : void {
			handleRemoteId(new RemoteId(id));
		}

		/**
		 * used for a keep-alive ping from fms
		 */
		public function receivePing() : Boolean {
			return true;
		}

		
		/**
		 * incoming call from fms service, do not call, it is not part of the public api
		 */
		public function receiveDebug(message : String) : void {
			Log.debug(message, toString());	
		}

		/**
		 * incoming call from fms service, do not call, it is not part of the public api
		 */
		public function receiveInfo(message : String) : void {
			Log.info(message, toString());	
		}

		/**
		 * incoming call from fms service, do not call, it is not part of the public api
		 */
		public function receiveStatus(message : String) : void {
			Log.status(message, toString());	
		}

		/**
		 * incoming call from fms service, do not call, it is not part of the public api
		 */
		public function receiveWarn(message : String) : void {
			Log.warn(message, toString());
		}

		/**
		 * incoming call from fms service, do not call, it is not part of the public api
		 */
		public function receiveError(message : String) : void {
			Log.error(message, toString());	
		}

		/**
		 * incoming call from fms service, do not call, it is not part of the public api
		 */
		public function receiveFatal(message : String) : void {
			Log.fatal(message, toString());	
		}
	}
}
