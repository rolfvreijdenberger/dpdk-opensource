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
	import nl.dpdk.utils.timeline.TimelineEvent;

	import flash.events.TimerEvent;

	import nl.dpdk.utils.timeline.TimelineListener;

	import flash.display.MovieClip;
	import flash.utils.Timer;

	/**
	 * TimeLineTask is used for flow management of movieclips.
	 * It ends when a label inside a movieclip is reached. In a sequence, action can be taken accordingly.
	 * 
	 * usage: 
	<code>
	//do some timeline stuff and execute a method when done
	var sequence: Sequence = new Sequence(); 
	sequence.add(new TimeLineTask(myMC, "onIntroDone", true));
	sequence.add(new CallBackTask(doThisMethodWhenIntroIsDone));
	//start the sequence.
	sequence.execute();
	</code>
	 * @author rolf vreijdenber
	 */
	public class TimelineTask extends Task {
		private var mc : MovieClip;
		private var label : String;
		private var timeOut : uint;
		private var timer : Timer;
		private var listener : TimelineListener;
		private var playMovieClipOnExecute : Boolean;
		private var stopMovieCliponLabelReached : Boolean;

		/**
		 * @param mc the movieclip that needs to reach a certain label for the Task to finish.
		 * @param label the label of the movieclip that we are interested in.
		 * @param playMovieClipOnExecute should this class order the movieclip to begin playing when the Task is executed?
		 * @param stopMovieCliponLabelReached should this class order the movievelip to stop playing when the framelabel is reached?
		 * @param timeOut in case the movieclip never reaches a certain frame label, we generate a timeout with an error. default is 0, no timeout
		 */
		public function TimelineTask(mc : MovieClip, label : String, playMovieClipOnExecute : Boolean = false, stopMovieCliponLabelReached : Boolean = false,  timeOut : uint = 0) {
			this.mc = mc;
			this.label = label;
			this.playMovieClipOnExecute = playMovieClipOnExecute;
			this.stopMovieCliponLabelReached = stopMovieCliponLabelReached;
			this.timeOut = timeOut;
		}

		override protected function executeTaskHook() : void {
			if(timeOut != 0) {
				timer = new Timer(timeOut, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				timer.start();
			}
			
			listener = new TimelineListener(mc);
			listener.addEventListener(TimelineEvent.NEW_LABEL, onLabel);
			
			if(playMovieClipOnExecute) {
				mc.play();
			}
		}

		private function onTimerComplete(event : TimerEvent) : void {
			if(listener) {
				listener.removeEventListener(TimelineEvent.NEW_LABEL, onLabel);
			}
			fail("TimelineTask, label: '" + label + "' not reached after timer timeout of " + timeOut + " milliseconds");
		}

		private function onLabel(event : TimelineEvent) : void {
			if(event.getLabel() == label) {
				if(stopMovieCliponLabelReached) {
					mc.stop();
				}
				if(timer != null) {
					timer.stop();
				}
				done();
			}
		}

		override protected function destroyTaskHook() : void {
			if(timer != null) {
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				timer = null;
			}
			if(listener != null) {
				listener.removeEventListener(TimelineEvent.NEW_LABEL, onLabel);
				listener.destroy();
				listener = null;
			}
			mc = null;
		}
	}
}
