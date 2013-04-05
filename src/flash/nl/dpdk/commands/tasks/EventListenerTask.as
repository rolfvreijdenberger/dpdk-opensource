package nl.dpdk.commands.tasks {
	import nl.dpdk.commands.tasks.Task;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * 
	 * @author rolf
	 */
	public class EventListenerTask extends Task {
		private var dispatcher : IEventDispatcher;
		private var type : String;

		/**
		 * @param dispatcher the IEventDispatcher that dispatches the event with the event type we want to respond to in this task
		 * @param type the event type we want to respond to. Event types are just strings under the hood (encapsulated in Event classes)
		 */
		public function EventListenerTask(dispatcher: IEventDispatcher, type: String) {
			this.type = type;
			this.dispatcher = dispatcher;
		}

		override protected function executeTaskHook() : void {
			dispatcher.addEventListener(type, onEventDispatched);
		}
		
		private function onEventDispatched(event : Event) : void {
			done();
		}

		
		
		override protected function destroyTaskHook() : void {
			dispatcher.removeEventListener(type, onEventDispatched);
			dispatcher = null;
		}

		override public function toString() : String {
			return "EventListenerTask: " + type;
		}
	}
}