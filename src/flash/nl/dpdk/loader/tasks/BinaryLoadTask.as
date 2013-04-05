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
package nl.dpdk.loader.tasks 
{
	import nl.dpdk.loader.DataTypes;
	import nl.dpdk.loader.events.LoaderItemProgressEvent;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	/**
	 * Loads the given url via a URLLoader in URLLoaderDataFormat.BINARY and inserts 
	 * a ByteArray into loadedContent.
	 * 
     * @author Thomas Brekelmans
     */
    public class BinaryLoadTask extends LoadTask 
    {
        private var loader:URLLoader;
		
        public function BinaryLoadTask(url:String, data:*)
        {
        	super(url, data, DataTypes.BINARY_TYPE);
		}
        
        override protected function createLoader():void
        {
        	loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
		}
        
        override protected function addLoaderListeners():void
        {
        	loader.addEventListener(Event.COMPLETE, dataReadyHandler);
        	loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        	loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        	loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }
        
        private function removeLoaderListeners():void
        {
        	loader.removeEventListener(Event.COMPLETE, dataReadyHandler);
        	loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        	loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        	loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }

        private function dataReadyHandler(event:Event):void
        {
            try
        	{
        		// is a ByteArray
        		loadedContent = loader.data;
        	}
        	catch (e : Error)
        	{
				fail(e.message);
				return;	
        	}
        	
			done();
        }

        private function ioErrorHandler(event:IOErrorEvent):void
        {
        	fail(event.text);
        }
        
        private function progressHandler(event:ProgressEvent):void
        {
        	bytesAdded = event.bytesLoaded - bytesAdded;
        	
        	dispatchEvent(new LoaderItemProgressEvent(LoaderItemProgressEvent.PROGRESS, event.bytesLoaded / event.bytesTotal, bytesAdded, event.bytesTotal, url, data, loaderType));
        }
        
        private function securityErrorHandler(event:SecurityErrorEvent):void
        {
        	fail(event.text);
        }

		override protected function executeTaskHook():void
		{
            try
            {
                loader.load(new URLRequest(url));
            }
            catch (error:Error)
            {
                genericErrorHandler(error);
            }  
        }
        
        private function genericErrorHandler(error:Error):void
        {
        	fail(error.message);
        }

		override protected function destroyTaskHook():void
		{
       		removeLoaderListeners(); 
       		loadedContent = null;
       		loader = null;
        }
        
        override public function toString():String
        {
            return "BinaryLoadTask";
        }
    }
}