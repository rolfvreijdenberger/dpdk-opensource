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

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * 
	 * @author rolf
	 */
	public class DetermineContentSizeTask extends Task {
		private var url : String;
		private var loader: URLLoader;
		private var totalBytes : uint = 0;

		public function DetermineContentSizeTask(url: String) {
			this.url = url;
			create();
		}
		
		private function create() : void {
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
        	loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        	loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
        	loader.addEventListener(Event.COMPLETE, onComplete);
        	loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        	loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		override protected function executeTaskHook() : void {
			try{
				loader.load(new URLRequest(url));
			}catch(e: Error){
				fail(e.message);
			}
		}
		
		private function onHTTPStatus(event : HTTPStatusEvent) : void {
		}

		private function onComplete(event : Event) : void {
			done();
		}


		private function securityErrorHandler(event : SecurityErrorEvent) : void {
			end(event.text);
		}

		private function progressHandler(event : ProgressEvent) : void {
			totalBytes = event.bytesTotal;
			sizeDetermined();
		}
		
		private function sizeDetermined() : void {
			try{
				loader.close();
			}catch(e: Error){
				trace("DetermineFileSizeTask.sizeDetermined(error) " + e.message);
			}
			done();
		}

		private function ioErrorHandler(event : IOErrorEvent) : void {
			end(event.text);
		}
		
		
		/**
		 * wrapper around fail() so we can do some extra stuff here when something fails
		 */
		private function end(error : String) : void {
			try{
				loader.close();
			}catch(e: Error){
				trace("DetermineFileSizeTask.end(error) " + e.message);
			}
			fail(error);
		}

		override protected function destroyTaskHook() : void {
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        	loader.removeEventListener(Event.COMPLETE, onComplete);
        	loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        	loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        	loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
        	loader = null;
		}
		
		public function getContentSize() : uint {
			return totalBytes;
		}

		override public function toString() : String {
			return "DetermineFileSizeTask";
		}
	}
}
