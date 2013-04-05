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
	import nl.dpdk.services.fms.rso.FMSSharedObjectData;
	import flash.events.Event;	
	/**
	 * Holds the data that belongs to specific updates of the FMSSharedObject instance.
	 * The data is wrapped in an FMSSharedObjectData instance.
	 * In most cases, only FMSSharedObjectDataEvent.DATA_NEW, FMSSharedObjectDataEvent.DATA_CHANGED and FMSSharedObjectDataEvent.DATA_DELETED are interesting for the client.
	 * @see FMSSharedObjectData
	 * @author Rolf Vreijdenberger
	 */
	public class FMSSharedObjectDataEvent extends Event {
		//the event contains new data. check the FMSSharedObjectData's id/name value to know what is new and the data to get to the data
		public static const NEW : String = "rso new data";
		//data has changed on the SharedObject, check the FMSSharedObjectData's id/name value to know what has changed and the data to get to the data
		public static const CHANGED : String = "rso data changed";
		//data has been deleted on the shared object.  check the FMSSharedObjectData's id/name value to know what has been deleted
		public static const DELETED : String = "rso data deleted";
		//when the first synch takes place, no data available, do not write directly on a rso before sync has taken place.
		public static const SYNCHED : String = "rso synchronized first time";
		//when a client side data change is rejected. this will happen if we do not have write access to a RSO (set by the FMS)
		public static const WRITE_REJECTED : String = "rso client data write rejected";
		//notification when the client changed/writes to the RSO succesfully.
		public static const WRITE_SUCCESS : String = "rso client data write succesful";
		//notificiation when the RSO is cleared
		public static const CLEARED : String = 'rso client data cleared';
				private var data : FMSSharedObjectData;
		public function FMSSharedObjectDataEvent(type : String, data : FMSSharedObjectData = null) {
			super(type, false, false);
			setData(data);
		}
				override public function clone() : Event {
			return new FMSSharedObjectDataEvent(type, getData());
		}
								/**
		 * contains data
		 * @return FMSSharedObjectData contains the data and the id of the property that was affected.
		 */
		public function getData() : FMSSharedObjectData {
			return data;
		}
		
		/**
		 * do we have FMSSharedObject data, or is this an event that does not contain any data? (FMSSharedObjectDataEvent.CLEARED,  FMSSharedObjectDataEvent.SYNCHED, FMSSharedObjectDataEvent.DELETED, FMSSharedObjectDataEvent.WRITE_SUCCESS, FMSSharedObjectDataEvent.WRITE_REJECTED
		 */
		public function hasData():Boolean{
			return data == null ? false : true;	
		}
				private function setData(data : FMSSharedObjectData) : void {
			this.data = data;
		}
				override public function toString() : String {
			return "FMSSharedObjectEvent";
		}
	}
}
