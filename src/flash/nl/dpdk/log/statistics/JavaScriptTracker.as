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
	import flash.external.ExternalInterface;

	import nl.dpdk.log.statistics.ITracker;	

	/**
	 * Tracks stuff to a javascript method that is contained in the html page the .swf file is embedded in.
	 * @author Rolf Vreijdenberger
	 */
	public class JavaScriptTracker implements ITracker 
	{
		private var method : String;

		public function JavaScriptTracker(method : String) 
		{
			this.method = method;
		}

		
		/**
		 * this version of 'track' uses the external interface to communicate with a javascript in the html container in which the flash file is embedded
		 * it calls a javascript method wich takes one parameter as it's input.
		 * Make sure to have the right tags embedded in your html code to allow flash to communicate with javascript. 
		 * @inheritDoc
		 */
		public function track(what : String) : void 
		{
			var value : * = null;
			try 
			{
				value = ExternalInterface.call(method, what);
			}
			catch (error : Error) 
			{
				throw(error);
			}
		}

		
		public function toString() : String 
		{
			return "JavascriptTracker on <" + method + ">";
		}
	}
}
