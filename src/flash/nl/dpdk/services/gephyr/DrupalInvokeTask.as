package nl.dpdk.services.gephyr {
	import nl.dpdk.commands.tasks.Task;

	/**
	 * A generic drupal task that you can use to call all service methods on a Drupal backend in a sequence.
	 * It hooks into the normal DrupalProxy execution flow and is able to function as a Task in a Sequence of other tasks (including other DrupalInvokeTasks).
	 * The handlers for the calls made via DrupalProxy are set by the client on the DrupalProxy instance and will be handled by the client in the normal way as you would do when not using a DrupalInvokeTask. 
	 * The task takes care of handling it's place in the sequence of tasks.
	 * 
	 * Even though we could make calls on a drupal proxy by using the CallBackTask (new CallBackTask(drupalProxy.invoke, "node", "get", 1)),
	 * this would mean that we would not wait on the result (a callback executes and goes to the next task in the sequence).
	 * The advantage of the DrupalInvokeTask is that it waits for the asynchronous results from the drupal backend.
	 * 
	 * @see nl.dpdk.commands.tasks.Sequence
	 * @author rolf vreijdenberger
	 */
	public class DrupalInvokeTask extends Task {
		private var drupalProxy : DrupalProxy;
		private var service : String;
		private var method : String;
		private var args : Array;

		/**
		 * @param drupalProxy a valid instance of a DrupalProxy
		 * @param service the service you wish to call
		 * @param method the method you whish to call on the specified service
		 * @param args a variable number of arguments of any type expected by the remote method. If you would need these arguments at runtime, create the task on the fly, get the right arguments and add the task to the right place in the Sequence.
		 */
		public function DrupalInvokeTask(drupalProxy : DrupalProxy, service : String, method : String, ...args) {
			this.args = args;
			this.method = method;
			this.service = service;
			this.drupalProxy = drupalProxy;
		}

		override protected function executeTaskHook() : void {
			drupalProxy.setGenericHandler(onResult, onStatus, onError, onTimeOut);
			this.args.unshift(method);
			this.args.unshift(service);
			drupalProxy.invoke.apply(null, this.args);
		}

		override protected function destroyTaskHook() : void {
			drupalProxy.setGenericHandler(null, null, null, null);
			this.drupalProxy = null;
			this.args = null;
			this.service = '';
			this.method = '';
		}

		override public function toString() : String {
			return "DrupalInvokeTask: " + service + "." + method;
		}

		private function onTimeOut(data : DrupalData) : void {
			fail(data.getMessage());
		}

		private function onError(data : DrupalData) : void {
			fail(data.getMessage());
		}

		private function onStatus(data : DrupalData) : void {
			fail(data.getMessage());
		}

		private function onResult(data : DrupalData) : void {
			done();
		}
	}
}
