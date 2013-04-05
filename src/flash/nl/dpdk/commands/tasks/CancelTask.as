package nl.dpdk.commands.tasks {
	import nl.dpdk.commands.tasks.Task;

	/**
	 * Cancels another task that implements ICancellableTask
	 * Used in combination with ConditionalTask it can provide complex branching logic.
	 * 
	 * a CancelTask can call cancel() on it's containing ICancellableTask.
	 * This is useful for sequences that hold ConditionalTask tasks.
	 * one task T in a sequence A might finish, triggers a conditional somewhere in another sequence B, 
	 * but the whole routine of conditional tasks in that sequence B must finish within a certain time.
	 * A CancelTask right after those conditionals  in B will cancel the flow of the TimeDelayTask in A after task T
	 * where the normal flow would continue as an error branch.
	 * 
	 * 
	 * @see nl.dpdk.commands.tasks.FrameDelayTask
	 * @see nl.dpdk.commands.tasks.TimeDelayTask
	 * @author rolf Vreijdenberger
	 */
	public class CancelTask extends Task {
		private var task : ICancellableTask;
		
		public function CancelTask(task: ICancellableTask) {
			this.task = task;
		}

		override protected function executeTaskHook() : void {
			task.cancel();
			done();
		}

		override protected function destroyTaskHook() : void {
			task = null;
		}
	}
}
