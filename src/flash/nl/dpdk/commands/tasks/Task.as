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
	import nl.dpdk.commands.ICommand;

	import flash.events.EventDispatcher;

	/**
	 * A superclass for tasks.
	 * Every subclass of Task is one piece of a possible sequence of Tasks to be executed only once during their lifetimes.
	 * They hold logic to fullfil a specific kind of task.
	 * A Task will be used in a Sequence, to create a logical flow of sequential tasks to be executed.
	 * It should be used within a Sequence but can be used standalone.
	 * 
	 * Specialized subclasses hold concrete logic (Business logic) that one task should execute, this can be both synchronous or asynchronous logic.
	 * To inform a client when a certain task is done, a Task generates certain events, so we can setup a flow. 
	 * This differs from a normal Command (which could be asynchronous) which does not inform a client via an event.
	 * 
	 * A Sequence should be able to run a sequence of Tasks without forcing other (domain) objects that are not tasks to know they are part of a sequence.
	 * for instance: a preloader should function whether it is part of a sequence or not, we should not bother to implement flow logic IN the preloader.
	 * However, the preloader should give other objects opportunities to get information out of it, for instance, when it is done loading.
	 * That is why an object should provide an interface to inform clients of it's state. 
	 * A Task or a subclass of Task can use that object via composition to query it's data or state and to do useful things with the object, or react to it's state changes.
	 * In this way, the Task is responsible for a little piece of action in a more eleborate sequence flow.
	 * In our example, a subclass of Task that has a reference to the preloader will be informed that the preloader is done.
	 * The subclass will generate an event, which will be picked up by the Sequence, and the next task will be executed.
	 * For this preloader example, this might be the start of the intro animation of the site, followed by a Task subclass that loads some external assets, etcetera.
	 * 
	 * The benefits are: 
	 * - easy task structuring, make one object responsible for one thing, tasks can be reordered without difficult code rewrites
	 *   (for instance when there are functions calling the next function to execute: a crappy sequence managing way)
	 * - business logic encapsulation in specialized task classes that can be reused throughout your application.
	 * - no more reinventing sequence managers by developers.
	 * - easy to learn and easy to use with the right way to use sequences!!
	 * - logic that should be written anyway for sequence management (like event listeners, callbacks, flow control)
	 *   is now encapsulated in the right object and does not clutter domain objects.
	 * - since Task implements ICommand it can be substituted for a command, to make full use of the power of commands 
	 *   (eg: a Task can be injected into interface logic etc).
	 * - Sequence also implements ICommand, so the previous line is also valid for a sequence as a whole.
	 * 
	 * A subclass of Task should override at least one hook function (http://en.wikipedia.org/wiki/Hooking), the possible hooks are executeTaskHook() where your business logic execution is started,
	 * or destroyTaskHook, where you can do a cleanup of all hook functionality. Be sure to call the protected method done() or error() from your subclass when a Task has finished doing it's thing, to be able to continue sequence flow.
	 * 
	 * A Task should be responsible for it's own destruction. 
	 * Whenever a class is done executing, it will be cleaned up by the destroy() method (override destroyTaskHook()).
	 * Remove event listeners and references that might cause memory leaks.
	 * Preferrably, a Task should only run once, and then be invalidated. If you want to do something again, you would create a new Task, just like in real life.
	 * This is also the safest assumption when dealing with unknown classes at runtime.
	 * Also, Sequence calls destroy() on a Task after the task has been executed.
	 * 
	 * Keep in mind, that when a Task in a sequence depends on some data that is generated by an earlier task, 
	 * that that information can easily be shared by having them both share (or depend on) a common object that has been passed in via the constructor of both tasks,
	 * a method know as dependency injection.
	 * They need an indirect means of communicating as they do not know of each other (thereby providing loose coupling),
	 * but the Task can be sure that it will get it's data from an object that is in a valid state.
	 * As an example: A certain task will load xml and creates User domain objects from it. The task has been passed a UserList in it's constructor which it populates.
	 * It does not know where the UserList comes from.
	 * Another Task that executes later will have the same Userlist passed in via it's constructor and will generate a UI widget from it.
	 * Both tasks do not know of each other's existence, no data is lost, testing is made easier (since we can provide mock objects or stubs) and each task only has it's own responsibilities.
	 * example:
	 * <code>
	//empty list, that will hold User objects
	var userList: List = new LinkedList(); 
	 
	//task that will load users from xml and will populate an externally provided list.
	var userTask: Task = new UserCreationTask("users.xml", userList);
	//remember, at this point, the list is still empty.
	//pass a reference to the widgetTask
	var widgetTask: Task = new UserWidgetTask(userList);
	
	//create a complex sequence of tasks that incrementally need more information
	var sequence: Sequence = new Sequence();
	sequence.add(userTask);
	//... etc.
	seqence.add(widgetTask);
	//fire it up!
	sequence.execute();
	//as the sequence of tasks progresses, widgetTask will have a reference to a userList that is initially empty, but is filled before widgetTask itself is executed.
</code>
	 * 
	 * 
	 * @see nl.dpdk.commands.tasks.Sequence
	 * 
	 * @author Rolf Vreijdenberger
	 * @author Thomas Brekelmans
	 * @author Oskar van Velden	 
	 */
	 
	/**
	 * Error event from a Task. The error message can be retrieved from the event.
	 * This event occurs when a Task finishes with an Error, which it does when it should abortOnError. The DONE event is not dispatched when ERROR is dispatched. 
	 * The error event type is also used internally in every Task subclass, but a client can listen to this event from a specific subclass, 
	 * to have more fine grained control over where exactly the error happened.
	 * 
	 */
	[Event(name="ERROR", type="nl.dpdk.commands.tasks.TaskEvent")]

	/**
	 * When a Task has totally finished executing, it's DONE event is dispatched.
	 * this is handled in subclasses of Task by calling the - protected - done() method
	 */
	[Event(name="DONE", type="nl.dpdk.commands.tasks.TaskEvent")]

	/**
	 * When a Task's execute method is called, it's START event type is dispatched.
	 * This might be useful to monitor when the task is part of a sequence.
	 */
	[Event(name="START", type="nl.dpdk.commands.tasks.TaskEvent")]

	public class Task extends EventDispatcher implements ICommand {
		private var executing : Boolean = false;

		
		/**
		 * Subclasses of Task can have context passed in via their constructor (references to other objects, or other kinds of data).
		 * These subclasses can also be listened to for specific events, and can have a fatter interface than their superclasses (to retrieve context for example, or to query the state of the task).
		 * 
		 * When a Task is executed, it should retrieve the necessary information at runtime from the context that was provided to the Task at construction time.
		 * 
		 * 
		 * This is also the way in which a concrete Command should work.
		 * @see ICommand
		 * @see Sequence
		 */
		public function Task() {
		}

		
		
		
		
		/**
		 * the method that starts it all. Call this method once to start the execution of the task.
		 * In order to be able to use the Task in an environment that supports Commands, the ICommand interface has been implemented.
		 */
		public final function execute() : void {
				dispatchEvent(new TaskEvent(TaskEvent.START, this, "execute() called on the task"));
				executeTaskHook();
			
		}

		
		
		
		/**
		 * used internally to set a flag. A Task might check if it is executing to control their own functionality.
		 * A class might not want it's execute() method to be called multiple times while it is executing.
		 */
		protected final function setExecuting(boolean : Boolean) : void {
			executing = boolean;
		}

		/**
		 * is this Task currently executing?
		 * 
		 * This method might be used by subclasses to control their own functionality. 
		 * A class might not want it's execute() method to be called multiple times while it is executing.
		 */
		protected final function isExecuting() : Boolean {
			return executing;
		}

		
		/**
		 * override this method in a subclass to implement your own Task logic here.
		 * It is a hook, which means that it can and should be used in a subclass when necessary.
		 * It is part of the template method pattern in execute().
		 * 
		 * Whenever a task is done executing, it must call the done() method or the error() method!!! Don't forget!!!
		 * When this is not done, the sequence will not continue!
		 * the overriden method should <i>not</i> call super.executeTaskHook().
		 * 
		 * A class might not want it's execute() method to be called multiple times while it is executing.
		 * A Sequence will not do this anyway, but the client that created the task might...
		 * If this is the case, it should set it's own executing state in this method.
		 * It could alter it's own behaviour by checking isExecuting() first.
		 * stub code is provided in this method.
		 */
		protected function executeTaskHook() : void {	
			fail("The method executeTaskHook needs to be overriden in " + this.toString());
			
			
			//example implementation
			if(isExecuting()){
				/**
				 * we are already executing this task!!!
				 * do something here that is appropiate when already executing.
				 */

			} else {
				setExecuting(true);
				//default implementation here..
			}
		}

		
		
		/**
		 * this method is the end of the line for sequence execution.
		 * It can only be called by the Task class itself, not by subclasses.
		 * @param message the error message for the TaskEvent
		 */
		private function signalDone(message : String) : void {
			//trace(toString() + ".signalDone(message)");
			setExecuting(false);
			dispatchEvent(new TaskEvent(TaskEvent.DONE, this, message));
		}

		/**
		 * this method should always be called when a subclass of Task is done executing.
		 * Don't forget to do this as it is essential for the whole sequence to continue.
		 * An example where this could be called is when doing a succesful asynchronous call on URLLoader in a subclass .
		 */
		protected final function done() : void {
			signalDone("normal ending of task: " + toString());
		}

		/**
		 * this method should always be called when a subclass of Task should end or has ended because of an error.
		 * Don't forget to do this as it is essential for the Sequence to continue.
		 * An example where this could be called is when doing an asynchronous call on URLLoader that generates an error in a subclass.
		 * @param message the message we want to give about the error.
		 */
		protected final function fail(message : String) : void {
			/*
			 * handle the error gracefully.
			 * the subclass has called this message
			 */
			signalError(message);
		}

		
		/**
		 * this method is the end of the line for sequence execution when an error has occured.
		 * It can only be called by the Task class itself.
		 * @param message the message we want to give about the error.
		 */
		private function signalError(message : String = "") : void {	
			setExecuting(false);
			dispatchEvent(new TaskEvent(TaskEvent.ERROR, this, message));
		}

		
		/**
		 * clean up this Task.
		 * Call only after a Task has totally finished executing.
		 * It removes all stuff that make this class work and invalidates the task
		 * a Sequence will always call this method after the task has executed, so be sure that any state, data or information you need from a task is preserved inside the task.
		 */
		public final function destroy() : void {
			//template method implementation, with a hook: destroyTaskHook()
			try {
				//since a subclass might do freaky stuff, catch any potential errors
				destroyTaskHook();
			}catch(e : Error) {
				trace("Error in " + toString() + ".destroyTaskHook(): " + e.message);
			}finally {
			}
		}

		
		/**
		 * override this method in a subclass to implement your own destruction logic here.
		 * It is a hook, which means that it can and should be used in a subclass when necessary.
		 * It is part of the template method pattern in destroy().
		 */
		protected function destroyTaskHook() : void {
			//custom stuff here, remove listeners, clean/clear objects etc.
			//trace(toString() + ".destroyTaskHook()");
		}

		
		/**
		 * 
		 */
		override public function toString() : String {
			//override for better error messages while debugging
			return "Task";
		}
	}
}
