package nl.dpdk.commands.tasks {
	import nl.dpdk.commands.tasks.Task;

	/**
	 * Always generates an error.
	 * Useful for testing a Sequence.
	 * It can be used for generating an error. Depending on if it's in a sequence that aborts on error or not, it generates different behaviour in that sequence.
	 * 
	 * @author rolf
	 */
	public class ErrorTask extends Task {
		public function ErrorTask() {
		}

		override protected function executeTaskHook() : void {
			fail("ErrorTask generated an error");
		}

		override public function toString() : String {
			return "ErrorTask";
		}
	}
}
