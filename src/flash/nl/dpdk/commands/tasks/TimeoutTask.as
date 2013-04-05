package nl.dpdk.commands.tasks {
	import flash.events.TimerEvent;
	import nl.dpdk.commands.tasks.Task;

	import flash.utils.Timer;

	/**
	 * This task decorates another task with behaviour that stops waiting for a task after a specific time.
	 * The decorated task in not cancelled, but we just don't listen to its TaskEvents.
	 * When this task times out it continues normally or fails depending on what you put in the constructor
	 * @author rolf	
	 */
	public class TimeoutTask extends Task {
		private var task : Task;
		private var timer: Timer;
		private var timeoutDuration : uint;
		private var failOnError : Boolean;

		
		/**
		 * @param task the Task we decorate with timeout functionality
		 * @param timeoutDuration the duration after which the task times out in milliseconds
		 * @param failOnError Should this task put out a TaskEvent.ERROR or TaskEvent.DONE when it times out.
		 */
		public function TimeoutTask(task: Task, timeoutDuration: uint, failOnError: Boolean = false) {
			
			this.failOnError = failOnError;
			this.timeoutDuration = timeoutDuration;
			this.task = task;
		}

		override protected function executeTaskHook() : void {
			timer = new Timer(timeoutDuration, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			task.addEventListener(TaskEvent.DONE, onTaskDoneInTime);
			task.addEventListener(TaskEvent.ERROR, onTaskErrorInTime);
			timer.start();
			task.execute();
		}
		
		private function onTaskErrorInTime(event : TaskEvent) : void {
			timer.stop();
			fail(event.getMessage());
		}

		private function onTaskDoneInTime(event : TaskEvent) : void {
			timer.stop();
			done();
		}

		private function onTimeout(event : TimerEvent) : void {
			timer.stop();
			task.removeEventListener(TaskEvent.DONE, onTaskDoneInTime);
			task.removeEventListener(TaskEvent.ERROR, onTaskErrorInTime);
			if( failOnError ){
				fail("Task: '" + task.toString() + "' timed out in " + timeoutDuration + " ms");
			}else{
				done();
			}
		}

		override protected function destroyTaskHook() : void {
			task.removeEventListener(TaskEvent.DONE, onTaskDoneInTime);
			task.removeEventListener(TaskEvent.ERROR, onTaskErrorInTime);
			try{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			}catch(e: Error) {
				//just in case execute was never called, expected error without consequence.
			}
			timer = null;
			task = null;
		}
		
		override public function toString() : String {
			return "TimeoutTask, " + timeoutDuration +", for " +task.toString();
		}
	}
}
