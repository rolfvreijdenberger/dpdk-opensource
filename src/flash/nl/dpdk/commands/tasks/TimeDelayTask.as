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
	import flash.events.TimerEvent;

	import nl.dpdk.commands.tasks.Task;

	import flash.utils.Timer;

	/**
	 * TimeDelayTask finishes succesfully after the specified delay time.
	 * It's use is to introduce a delay in a sequence of tasks.
	 * 
	 * Combined with other tasks, this can be used to create complex time based sequences.
	 * usage:
	 <code>
	 var sequence: Sequence = new Sequence();
	 //wait 5 seconds to finish
	 sequence.add(new TimeDelayTask(5000)); 
	 //add callback task to sequence of tasks
	 sequence.add(new CallBackTask(myMethod);
	 //new delay
	 sequence.add(new TimeDelayTask(2500));
	 sequence.add(new CallBackTask(anotherMethod);
	 //add listener
	 sequence.addEventListener(SequenceEvent.DONE, onSequenceDone);
	 //start the sequence.
	 sequence.execute();
	 </code>
	 * 
	 * 
	 * @see FrameDelayTask
	 * @author rolf vreijdenberger
	 */
	public class TimeDelayTask extends Task implements ICancellableTask {

		private var timer : Timer;

		/**
		 * @param delay the delay in milliseconds (minimum of 1)
		 */
		public function TimeDelayTask(delay : uint = 1000) {
			delay = delay <= 1 ? 1 : delay;
			timer = new Timer(delay, 1);
		}

		override protected function executeTaskHook() : void {
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			timer.start();
		}

		private function onComplete(event : TimerEvent) : void {
			done();
		}

		override protected function destroyTaskHook() : void {
			try{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
				timer = null;
			}catch(e: Error){
				trace("Error in " + toString() + ".destroyTaskHook(): " + e.message);
			}
		}
		

		public function cancel():void{
			if(timer) timer.stop();
		}
		
		override public function toString() : String {
			return "TimeDelayTask";
		}
	}
}
