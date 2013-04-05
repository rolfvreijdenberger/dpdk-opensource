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
     * LoaderItemProgressEvent contains the progress of loading the item 
     * which broadcasted this event (routed via Loader).
     * 
     * @see Loader
     * 
     * @author Thomas Brekelmans
     */
    final public class LoaderItemProgressEvent extends Event
    {
        public static const PROGRESS:String = "LoaderItemProgressEvent_PROGRESS";
        
        private var progress:Number;
        private var bytesAdded:uint;
		private var totalSize:uint;
		private var url:String;
		private var data:*;
		private var loaderType:uint;

		public function LoaderItemProgressEvent(type:String, progress:Number, bytesAdded:uint, totalSize:uint, url:String, data:*, loaderType:uint, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			//TODO optimize method signature if bubbles etc is not used, also in clone
			super(type, bubbles, cancelable);
			this.progress = progress;
			this.bytesAdded = bytesAdded;
			this.totalSize = totalSize;
			this.url = url;
			this.data = data;
			this.loaderType = loaderType;
			
        }
		
        override public function clone():Event
        {
            return new LoaderItemProgressEvent(type, progress, bytesAdded, totalSize, url, data, loaderType, bubbles, cancelable);
        }
		
		/**
		 * Returns the progress of the load in a percentage (between 0 and 1).
		 */
		public function getProgress():Number
		{
			return progress;
		}
		
		/**
		 * Returns the number of bytes that were added between the last progress event and the current one.
		 */
		public function getBytesAdded():Number
		{
			return bytesAdded;
		}

		public function getTotalSize():uint
		{
			return totalSize;
		}
		
		public function getUrl():String
		{
			return url;
		}
		
		public function getData():*
		{
			return data;
		}
		
		public function getLoaderType():uint
		{
			return loaderType;
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