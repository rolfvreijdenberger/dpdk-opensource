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
	import nl.dpdk.commands.tasks.TaskEvent;
	import nl.dpdk.loader.Loader;

	/**
	 * This task is to be used in a Sequence and will fill a loader as you would normally do with loader.add() but
	 * it will also determine the total size of the content to be loaded first, so we can use that in a preloader.
	 * 
	 * Other ways of setting the size of the content to be loaded would be setting it by getting file values from some sort of config parameter,
	 * for example via xml of flashvars.
	 * 
	 * This task is included for ease of use, but there is an added side effect:
	 * loading will take longer since we have to start a load on the file to get the filesize.
	 * We then stop the loading immediately since we are only interested in butes, 
	 * the loader will really load the file
	 * 
	 * 
	 * usage:
	 * <code>
	 * var loader: Loader = new Loader();
	 * //add event listeners to the loader
	 * //...adding
	 * //create a sequence that
	 * var s: Sequence = new Sequence();
	 * //the next code will take place in some kind of loop and makes sure the loader is populated
	 * //it will also determine the filesize of all files by loading the first few bytes
	 * s.add(new AddToLoaderWithContentSizeTask(loader, url, data));
	 * //end loop
	 * //instead of listening to the SequenceEvent.DONE where we can start the loader, we have a seperate task for this :)
	 * s.add(new ExecuteLoaderTask(loader));
	 * s.execute();
	 * </code>
	 * @author rolf
	 */
	public class AddToLoaderWithContentSizeTask extends Task {
		private var loader : Loader;
		private var url : String;
		private var data: *;
		private var contentType : uint;
		private var task: DetermineContentSizeTask;

		public function AddToLoaderWithContentSizeTask(loader: Loader, url: String, data: * = null, contentType: uint = 0) {
			this.contentType = contentType;
			this.data = data;
			this.url = url;
			this.loader = loader;
		}

		
		override protected function executeTaskHook() : void {
			task = new DetermineContentSizeTask(url);
			task.addEventListener(TaskEvent.DONE, onTaskDone);
			task.addEventListener(TaskEvent.ERROR, onTaskError);
			task.execute();
		}
		
		private function onTaskError(event : TaskEvent) : void {
			//do nothing, keep current loader size
			fail(event.getMessage());
		}

		private function onTaskDone(event : TaskEvent) : void {
			loader.setContentSize(loader.getContentSize() + task.getContentSize());
			loader.add(url, data, contentType);
			done();
		}

		override protected function destroyTaskHook() : void {
			task.removeEventListener(TaskEvent.DONE, onTaskDone);
			task.removeEventListener(TaskEvent.ERROR, onTaskError);
			task.destroy();
			loader = null;
			data = null;
		}

		override public function toString() : String {
			return "AddToLoaderWithFileSizeTask";
		}
	}
}
