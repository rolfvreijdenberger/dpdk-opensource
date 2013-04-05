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
 package nl.dpdk.commands.tasks {
	import nl.dpdk.commands.tasks.Task;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * FrameDelayTask finishes succesfully after the specified frames have been played by the flash playhead.
	 * It's use is to introduce a delay in a sequence of tasks. It's similar to TimeDelayTask, but differs in the way a delay is timed.
	 * This uses framerate, TimeDelayTask uses time.
	 * 
	 * Combined with other tasks, this can be used to create complex frame based sequences.
	 * usage:
	 * <code>
	 var sequence: Sequence = new Sequence();
	 //wait 5 frames to finish
	 var task: Task = new FrameDelayTask(5);
	  sequence.add(task);
	 //add callback task to sequence of tasks
	 sequence.add(new CallBackTask(trace, "we have just waited 5 frames");
	 //new delay
	 sequence.add(new FrameDelayTask(3));
	 sequence.add(new CallBackTask(trace, "this message will be traced after 3 more frames!");
	 //add listener for the ending of the sequence
	 sequence.addEventListener(SequenceEvent.DONE, onSequenceDone);
	 //start the sequence.
	 sequence.execute();
	 * </code>
	 * 
	 * @author rolf vreijdenberger
	 */
	public class FrameDelayTask extends Task implements ICancellableTask {
		private var mc: MovieClip;
		private var framesToDelay: uint;
		private var count: uint = 0;
		
		/**
		 * @param framesToDelay the frames after wich the task will end (minimum of 1)
		 */
		public function FrameDelayTask(framesToDelay: uint = 1) {
			this.framesToDelay = framesToDelay <= 1 ? 1 : framesToDelay;
		}
		
		private function oEF(event : Event) : void {
			//trace("FrameDelayTask.oEF(event) framesToDelay: " + framesToDelay + ", count: " + count);
			if(++count == framesToDelay){
				//no need to override the hook for destruction, this setup always works
				mc.removeEventListener(Event.ENTER_FRAME, oEF);
				mc = null;
				//make sure we give a signal we're done.
				done();
			}
		}

		override protected function destroyTaskHook() : void {
			//trace("FrameDelayTask.destroyTaskHook()");
			//nothing needs to be done, cleanup is performed elsewhere
		}

		/**
		 * this starts the stuff this class has to do
		 */
		override protected function executeTaskHook() : void {
			mc = new MovieClip();
			mc.addEventListener(Event.ENTER_FRAME, oEF);
		}
		
		override public function toString() : String {
			return "FrameDelayTask";
		}
		
		/**
		 * @see CancelTask
		 */
		public function cancel() : void {
			if(mc) {
					mc.removeEventListener(Event.ENTER_FRAME, oEF);
			}
			mc = null;
		}
	}
}
