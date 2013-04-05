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
package nl.dpdk.log.statistics {
	import nl.dpdk.log.statistics.ITracker;	import nl.dpdk.services.remoting.RemotingProxy;		import flash.net.ObjectEncoding;	
	/**
	 * track something by using a call to a flashremoting service.
	 * <p>
	 * use as follows:
	 * <code>
	 * Tracker.setTracker(new RemotingTracker("http://www.example.com/gateway.php","com.example.Log", "doTrack"));
	 * Tracker.track('something');
	 * </code>
	 *
	 * @author Rolf Vreijdenberger
	 * @see RemotingProxy
	 */
	public class RemotingTracker implements ITracker 
	{
		private var proxy : RemotingProxy;
		private var method : String;

		public function RemotingTracker(gateway : String, service : String, remoteMethod : String, objectEncoding : uint = 0) 
		{
			proxy = new RemotingProxy(gateway, service, objectEncoding);
			method = remoteMethod;
		}

		/**
		 * @inheritDoc
		 */
		public function track(what : String) : void 
		{
			proxy.invoke(method, what);
		}

		
		public function toString() : String 
		{
			return "RemotingTracker";
		}
	}
}
