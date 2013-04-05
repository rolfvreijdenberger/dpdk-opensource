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
package nl.dpdk.log.statistics 
{
	import nl.dpdk.log.Log;		

	/**
	 * The Tracker class is used for statistical/analytical purposes throughout an application.
	 * It serves as a means to log messages to whereever you want.
	 * It differs from a Log class as it is not used to generate messages throughout an application, as we would do with the Log class,
	 * but to specifically send certain events to store those events. In this way, we can analyse the way users use the application.
	 * <p><p>
	 * It can be configured with an implementation of ITracker.
	 * In this way, the Tracker is accessible throughout all code in our application by using the static Tracker.track() method, which delegates to a specific instance of an ITracker.
	 * <p><p>
	 * We assume that all we are only interested in the name of the event. Implementations can use other system info such as .swf width and height, resolution, timestamp etc.
	 * <p><p>
	 * use as follows:
	 * <code>
	 * Tracker.setTracker(new ComplexTrackerThatCallsGoogleAndAlsoOurCustomImplementation());
	 * Tracker.track('button 1 pressed');
	 * Tracker.track('login succeeded');
	 * </code>
	 * @see ITracker
	 * @author Rolf Vreijdenberger
	 */
	public class Tracker 
	{
		/**
		 * the concrete ITracker that we delegate our calls to.
		 */
		private static var tracker : ITracker;

		/**
		 * sets an implementation of ITracker on the Tracker so we can route calls to that specific implementation
		 * @param tracker an implementation of ITracker that suits the application's purpose.
		 */
		public static function setTracker(tracker : ITracker) : void 
		{
			Tracker.tracker = tracker;
		}

		
		/**
		 * This method is called throughout an application to track whatever needs to be tracked.
		 * The Tracker will delegate the message to an implementation of ITracker that is configured on the Tracker.
		 * @param what the message we want to send/track/log.
		 */
		public static function track(what : String) : void 
		{
			if(Tracker.tracker) 
			{
				try 
				{
					Tracker.tracker.track(what);
				}catch(e : Error) 
				{
					//make sure someone knows about whatever happened if something happened.
					Log.debug(e.message, toString());
				}
			}else 
			{
				Log.debug("No tracker instance set on the Tracker class.", toString());
			}
		}

		
		public static function toString() : String 
		{
			return "Tracker: " + (tracker != null ? tracker.toString() : 'no tracker set.');
		}
	}
}
