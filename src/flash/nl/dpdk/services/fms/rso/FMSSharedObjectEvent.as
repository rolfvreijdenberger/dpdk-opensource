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
	import flash.events.Event;	

	/**
	 * holds specific types of errors that might come back from an FMSSharedObject instance.
	 * @author Rolf Vreijdenberger
	 */
	public class FMSSharedObjectEvent extends Event {
		//an async error on the shared object
		public static const ERROR_ASYNC : String = "rso async error";
		//a netstatus error
		public static const ERROR_NETSTATUS : String = "rso netstatus error";
		//a connection error
		public static const ERROR_CONNECT : String = "rso connect error";
		//the message that goes with the error
		private var message : String;

		public function FMSSharedObjectEvent(type : String, message : String = null) {
			super(type, false, false);
			setMessage(message);
		}

		
		override public function clone() : Event {
			return new FMSSharedObjectEvent(type, getMessage());
		}

		
		/**
		 * contains a friendly error message.
		 */
		public function getMessage() : String {
			return message;
		}

		
		private function setMessage(message : String) : void {
			this.message = message;
		}

		
		override public function toString() : String {
			return "FMSSharedObjectErrorEvent";
		}
	}
}
