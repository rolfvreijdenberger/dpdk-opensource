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
package nl.dpdk.services.remoting 
{
	import flash.events.Event;		

	/**
	 * Whenever errors happen in the RemotingProxy class that are not the result of a proxied remote method call, they are dispatched as type RemotingEvent.
	 * 
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	public class RemotingEvent extends Event 
	{
		//netstatus errors, such as bad encodings, failed calls etc. Dispatched when a NetConnection object is reporting its status or error condition
		public static const ERROR_NETSTATUS:String = 'netstatus remoting error';
		//Dispatched when an input or output error occurs that causes a network operation to fail. 
		public static const ERROR_IO:String = 'io remoting error';
		//Dispatched when an exception is thrown asynchronously — that is, from native asynchronous code. 
		public static const ERROR_ASYNC:String = 'asynchronous remoting error';
		//Dispatched if a call to NetConnection.call() attempts to connect to a server outside the caller's security sandbox. 
		public static const ERROR_SECURITY:String = 'security remoting error';
		//dispatched when a call to a method timed out.
		public static const ERROR_TIMEOUT : String = 'timeout remoting error';
		//the message of the error
		private var message: String;

		/**
		 * Creates a new RemotingEvent with a given type and message.
		 * 
		 * @param message A (prefarably human readable) message describing the error that occured.
		 */
		public function RemotingEvent(type:String, message:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
			this.message = message;
		}

		/**
		 * Gets the error message.
		 * 
		 * @return A (prefarably human readable) message describing the error that occured.
		 */
		public function getMessage():String 
		{
			return message;
		}
		
		/**
		 * This function is needed for event-bubbling, it clones itself.
		*/
		override public function clone():Event
		{
			return new RemotingEvent(type, getMessage(), bubbles, cancelable);
		}

		/**
		 * Returns a string representation of this class.
		 */
		override public function toString():String
		{
			return formatToString("RemotingEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}
