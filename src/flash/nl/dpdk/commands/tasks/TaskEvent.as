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
	import flash.events.Event;

	/**
	 * TaskEvent is an event that will be dispatched by a Task.
	 * It is used to inform a Sequence.
	 * It is a non-bubbling event.
	 * 
	 * 
	 * 
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	public class TaskEvent extends Event {
		
		public static const DONE: String = "task done";
		public static const START: String = "task started";
		public static const ERROR: String = "task error";
		//a reference to the task that generated the event
		private var task : Task;
		//a message that might be passed in case of error
		private var message : String;

		/**
		 * @param type the type of the event
		 * @param task the task that <i>originally</i> generated the event (explicitly, instead of using event.target)
		 * @param message an optional message, mainly used with error event types.
		 */
		public function TaskEvent(type: String, task: Task, message: String = "") {
			super(type, false);	
			this.task = task;
			this.message = message;
		}
		
		/**
		 * the task that originally generated the event
		 */
		public function getTask() : Task {
			return task;
		}
		
		/**
		 * the message from the task, in case of an error
		 */
		public function getMessage() : String {
			return message;
		}
		
		public override function toString():String{
			return "TaskEvent of type: " + type;
		
		}
	}
}
