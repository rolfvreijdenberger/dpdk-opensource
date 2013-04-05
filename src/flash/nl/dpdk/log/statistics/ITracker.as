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

	/**
	 * An interface for tracking/logging purposes, used for statistical purposes.
	 * A concrete implementation of ITracker will be set on Tracker.
	 * @see Tracker
	 * @author Rolf Vreijdenberger
	 */
	public interface ITracker {
		/**
		 * send out a string representing a human readable event we want to track for statistical purposes.
		 * implement the track method to use another implementation, 
		 * for example: 
		 * javascript tracking with google analytics (urchin) or sitestat
		 * PHP or .NET tracking via flash remoting
		 * or both/more :)
		 * @param what the thing we are interested in, for example: 'login', 'register', 'button 1 clicked', 'preloader done' etc.
		 */
		function track(what : String) : void;

		/**
		 * for informational/debugging purposes
		 */
		function toString() : String;
	}
}
