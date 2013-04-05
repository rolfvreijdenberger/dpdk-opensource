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
package nl.dpdk.loader.tasks {
	import nl.dpdk.commands.tasks.Task;

	/**
	 * TODO: Add section explaining subclassing a LoadTask.
	 * 
	 * @author Thomas Brekelmans
	 */
	public class LoadTask extends Task 
	{
		protected var url:String;
		protected var data:*;
		protected var loaderType:uint;
		
		protected var loadedContent:*;
		
		protected var bytesAdded:uint;
		protected var bytesLoaded : Number;

		public function LoadTask(url:String, data:*, loaderType:uint) 
		{
			this.url = url;
			this.data = data;
			this.loaderType = loaderType;
			
			bytesAdded = 0;
			bytesLoaded = 0;
			
			createLoader();
			addLoaderListeners();
		}
		
		/**
		 * Abstract method that needs to be implemented for each subclass.
		 */
		protected function createLoader():void
        {
        }
        
        /**
		 * Abstract method that needs to be implemented for each subclass.
		 */
		protected function addLoaderListeners():void
        {
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
		
		public function getLoadedContent():*
		{
			return loadedContent;
		}
		
		protected function updateLoadStats(allBytesLoaded : uint) : void {
			
			//TODO: should we offload the calculation to Loader itself, in the event handler for LoaderItemProgressEvent
			//see comments there.. there are some drawbacks in doing that
        	bytesAdded = allBytesLoaded - bytesLoaded;
           
            if( bytesLoaded != allBytesLoaded )
            {    
                  bytesLoaded = allBytesLoaded;
            }
		}
		
		override public function toString():String
		{
		    return "LoadTask";
		}
	}
}
