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
package nl.dpdk.services.fms.responder 
{
	import flash.net.Responder;	

	/**
	 * FMSResponder is used as a class that can process or delegate the data that comes back from the flash media server (fms) after a call to fms is made via the NetConnection.
	 * It is a subclass of Responder for use in the FMSService.
	 * <p>
	 * 
	 * This class is provided for clarity of the use of the fms package and to provide a hook for plugging in behaviour when needed.
	 * Alternatively, we can just as easily subclass the Responder class itself, or just use the Responder class directly.
	 * <p>
	 * Use: netconnection.call('someRemoteMethod', new FMSResponder(onResultofSomeMethod, onStatusOfSomeMethod), someArgument);
	 * Implement the result and status handling methods on the FMSService.
	 * <p>
	 * When it is necessary for a Responder to hold state or context (eg: from the FMSService at that moment), just subclass the FMSResponder and pass the state via the constructor.
	 * The response handlers should then be defined on the FMSResponder subclass itself, else the context cannot be passed to the handler methods.
	 * This can be done by calling super(myInternalHandler, myInternalStatusHandler); in the constructor.
	 * <p>
	 * From flash help:The Responder class provides an object that is used in NetConnection.call() to handle return values from the server related to the success or failure of specific operations. When working with NetConnection.call(), you may encounter a network operation fault specific to the current operation or a fault related to the current connection status. Operation errors target the Responder object instead of the NetConnection object for easier error handling. 
	 *  
	 * @see FMSService
	 * 
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class FMSResponder extends Responder {
		public function FMSResponder(result : Function, status : Function = null) {
			super(result, status);
		}
		
		public function toString() : String {
			return "FMSResponder";
		}

	}
}
