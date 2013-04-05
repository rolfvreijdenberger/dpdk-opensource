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
package nl.dpdk.services.fms 
{
	import flash.events.Event;		

	/**
	 * An FMSSEvent is dispatched by FMS related services.
	 * subclass this event for specific implementations of FMSService and possibly add new event types.
	 */
	final public class FMSEvent extends Event
	{
		//event dispatched when the server disconnects
		public static const ERROR_DISCONNECTED : String = 'fms server has been disconnected';
		//when the server succesfully connects.
		public static const CONNECTED : String = 'fms server connected succesfully';
		//when a call fails
		public static const ERROR_CALL_FAILED: String = 'fms a call to the server failed';
		//generic error message that cannot be handled specifically
		public static const ERROR_GENERIC: String = 'fms an error message that cannot be handled specifically';
		//when rejected by the server.
		public static const ERROR_REJECTED : String = 'fms server rejected the connection';
		
		//a message containing info
		private var message : String;

		
		/**
		 * Creates a new FMSServiceEvent.
		 * @param type	The type of event.
		 */
		public function FMSEvent(type:String, message:String = null)
		{
			super(type, false, false);
			setMessage(message);
		}


		override public function clone():Event
		{
			return new FMSEvent(type,  message);
		}

		
		/**
		 * gets a message containing status information
		 */
		public function getMessage() : String
		{
			return message == null ? '' : message;
		}
		
		
		private function setMessage(message : String) : void
		{
			this.message = message;
		}
	}
}