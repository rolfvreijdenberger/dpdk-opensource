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

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * Loads the given url via a NetConnection/NetStream and inserts a NetStream into loadedContent.
	 * 
     * @author Thomas Brekelmans
     */
    public class VideoLoadTask extends LoadTask 
    {
		private var netConnection:NetConnection;
		private var stream:NetStream;
		private var dummyEventTrigger:Sprite;

		public function VideoLoadTask(url:String, data:*)
        {
        	super(url, data, DataTypes.VIDEO_TYPE);
		}
        
        override protected function createLoader():void
        {
        	netConnection = new NetConnection();
            netConnection.connect(null);
            stream = new NetStream(netConnection);
            stream.client = {onMetaData: trace, onPlayStatus: trace, onCuePoint: trace};
            dummyEventTrigger = new Sprite();
        }
        
        override protected function addLoaderListeners():void
        {
            stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
        
        private function removeLoaderListeners():void
        {
            stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, progressHandler);
        }

        private function ioErrorHandler(event:IOErrorEvent):void
        {
        	fail(event.text);
        }
        
        private function securityErrorHandler(error:SecurityError):void
        {
        	fail(error.message);
		}
		
        private function progressHandler(event:Event):void
        {
        	updateLoadStats(stream.bytesLoaded);
        	dispatchEvent(new LoaderItemProgressEvent(LoaderItemProgressEvent.PROGRESS, stream.bytesLoaded / stream.bytesTotal, bytesAdded, stream.bytesTotal, url, data, loaderType));
        	
        	if(stream.bytesLoaded >= stream.bytesTotal)
        	{
        		initHandler();
        	}
        }
        
        private function initHandler():void
        {
        	dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, progressHandler);
        	try
        	{
        		loadedContent = stream;
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
            dummyEventTrigger.addEventListener(Event.ENTER_FRAME, progressHandler);
        	try
            {
            	stream.play(url);
			}
            catch (error:SecurityError)
            {
                securityErrorHandler(error);    
            }	
            
            loadedContent = stream;
        }

		override protected function destroyTaskHook():void
		{
            removeLoaderListeners();
            loadedContent = null;
           	netConnection = null;
            stream = null;
            dummyEventTrigger = null;
        }
        
        override public function toString():String
        {
            return "VideoLoadTask";
        }
    }
}