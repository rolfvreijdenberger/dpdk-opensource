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

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * Loads the given url via a Loader and inserts a DisplayObject into loadedContent.
	 * 
     * @author Thomas Brekelmans
     */
    public class MovieClipLoadTask extends LoadTask 
    {
        private var loader:Loader;
        
        public function MovieClipLoadTask(url:String, data:*)
        {
        	super(url, data, DataTypes.MOVIE_CLIP_TYPE);
		}
        
        override protected function createLoader():void
        {
            loader = new Loader();
        }
        
        override protected function addLoaderListeners():void
        {
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
        }
        
        private function removeLoaderListeners():void
        {
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            loader.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
        }

        private function ioErrorHandler(event:IOErrorEvent):void
        {
        	fail(event.text);
        }
        
        private function securityErrorHandler(error:SecurityError):void
        {
        	fail(error.message);
		}

        private function progressHandler(event:ProgressEvent):void
        {
        	updateLoadStats(event.bytesLoaded);
        	dispatchEvent(new LoaderItemProgressEvent(LoaderItemProgressEvent.PROGRESS, event.bytesLoaded / event.bytesTotal, bytesAdded, event.bytesTotal, url, data, loaderType));
        }

        private function initHandler(event:Event):void
        {
        	try
        	{
        		loadedContent = loader.content;
        	}
        	catch (e : Error)
        	{
				fail(e.message);
				return;	
        	}
            
			done();
        }
        
		override protected function executeTaskHook():void
		{
            try
            {
                loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));
			}
            catch (error:SecurityError)
            {
                securityErrorHandler(error);    
            }   
        }

		override protected function destroyTaskHook():void
		{
            removeLoaderListeners();
            loadedContent = null;
            loader = null; 
        }
        
        override public function toString():String
        {
            return "MovieClipLoadTask";
        }
    }
}