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
package nl.dpdk.commands.tasks 
{
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.ArrayList;

	/**
	 * A CompositeTask is a Task that executes all the tasks that have been added to its list at once.
	 * This is useful for executing several separate tasks at once without have to write a special
	 * task for that purpose. 
	 * This task therefor promotes the creation of simple, small tasks that can be grouped together
	 * to form a batch if needed. As opposed to writing bigger monolithic tasks that are harder to
	 * reuse because they do more than one separate thing at once. 
	 * 
	 * usage:
	 * <code>
	 var task: CompositeTask = new CompositeTask();
	 task.add(new CallBackTask(myMethod);
	 task.add(new CallBackTask(myOtherMethod);
	 //add batch task to sequence of tasks
	 sequence.add(task);
	 * </code>
	 * 
	 * @author Thomas Brekelmans
	 */
	public class CompositeTask extends Task
	{
		//holds the tasks in a list
		private var tasks : ArrayList = new ArrayList();
		private var tasksDone : uint = 0;

		public function CompositeTask() {
			
		}
		
		/**
		 * @param task the Task to add to the sequence of tasks to execute
		 */
		public final function add(task : Task) : void {
			if(tasks){
				tasks.add(task);
			}
		}

		/**
		 * @param task the Task to remove from the sequence of tasks to execute
		 */
		public final function remove(task : Task) : Boolean {
			return tasks ? tasks.remove(task) : false;
		}
		
		override protected function executeTaskHook() : void {
			var iterator:IIterator = tasks.iterator();
			var task:Task;
			while (iterator.hasNext()) {
				task = iterator.next();
				task.addEventListener(TaskEvent.DONE, onDone);
				task.addEventListener(TaskEvent.ERROR, onError);
				task.execute();
			}
		}
		
		/**
		 * TaskEvent handler for when a task is done.
		 * These events come from listeners that have been added to the each task in the batch.
		 */
		private function onDone(event : TaskEvent) : void {	
			tasksDone++;
			if (tasksDone == size())
			{
				done();
			}
		}
		
		/**
		 * TaskEvent handler for errors.
		 * 
		 * Invokes error with the error message from the failing task.
		 */
		private function onError(event : TaskEvent) : void {			
			fail(event.getMessage());
		}
		
		/**
		 * what is the size of the batch.
		 * The tasks in the batch.
		 */
		public final function size() : uint {
			return tasks ? tasks.size() : 0;
		}
		
		/**
		 * check if this batch contains a specific task.
		 */
		public final function contains(task : Task) : Boolean {
			return tasks ? tasks.contains(task) : false;
		}

		override protected function destroyTaskHook():void
		{
			tasksDone = 0;
			
			try {
				var task : Task;
				var iterator : IIterator = tasks.iterator();
				while (iterator.hasNext()) {
					task = iterator.next() as Task;
					try {
						task.removeEventListener(TaskEvent.DONE, onDone);
						task.removeEventListener(TaskEvent.ERROR, onError);
						task.destroy();
						iterator.remove();
					}catch(e : Error) {
						trace("Error in CompositeTask.destroyTaskHook() when doing cleanup: " + e.message);
					}
				}
				tasks.clear();
				tasks = null;
			}catch(e : Error) {
				trace("Error in CompositeTask.destroyTaskHook(): " + e.message);
			}
		}

		override public function toString():String
		{
		    return "CompositeTask";
		}
	}
}
