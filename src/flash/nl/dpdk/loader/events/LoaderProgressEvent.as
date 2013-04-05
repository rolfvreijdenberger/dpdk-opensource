/*
Copyright (c) 2009 De Pannekoek en De Kale B.V.,  www.dpdk.nl

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
package nl.dpdk.loader.events {
	import flash.events.Event;

	/**
     * LoaderProgressEvent contains the total progress in loading all the items 
     * in the Loader which broadcasted this event.
     * 
     * @see Loader
     * 
     * @author Thomas Brekelmans
     */
    final public class LoaderProgressEvent extends Event
    {
        public static const PROGRESS:String = "LoaderProgressEvent_PROGRESS";
        
        private var progress:Number;

		public function LoaderProgressEvent(type:String, progress:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.progress = progress;
			
			super(type, bubbles, cancelable);
        }
		
        override public function clone():Event
        {
            return new LoaderProgressEvent(type, progress, bubbles, cancelable);
        }
		
		/**
		 * Returns the progress of the load in a percentage (between 0 and 1).
		 */
		public function getProgress():Number
		{
			return progress;
		}
		
        /**
         * Returns a special event String representation of this class.
         */
        override public function toString():String
        {
            return formatToString("LoaderItemEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}