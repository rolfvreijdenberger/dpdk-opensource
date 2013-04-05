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

	/**
	 * ConditionalTask is a concrete Task that allows a Sequence to wait upon other tasks to complete before the Sequence this task is in will proceed.
	 * This allows for a Sequence to wait to proceed until one or more conditions are fullfilled.
	 * A ConditionalTask can be placed in a sequence before another Task in a sequence. The next Task will run only if the previous task has finished.
	 * 
	 * When multiple sequences hold multiple tasks, very complex conditional statements and very complex branching can be achieved.
	 * 
	 * An example in words: suppose we want to continue a Sequence only when an animation is finished, some data is loaded and the user has finished doing some input.
	 * These processes are not serial, but rather they can be and should be parallel (data can load while an animation plays and the user can fill in a form at the same time)
	 * These kind of flow control/conditional branching sequences can be easily done with the ConditionalTask.
	 * 
	 * Please read the next example carefully as the ConditionalTask is one of the most powerful ways to create very complex sequences.
	 * 
	 * 
	 * usage:
	 * <code>
	//the main sequence of our logic flow
	var master: Sequence = new Sequence();
	//create two other sequences that are both independent of the master sequence and each other.
	var branch1: Sequence = new Sequence();
	var branch2: Sequence = new Sequence();
	//insert a concrete Task subclass that does an asynchronous thing (maybe a remote procedure call)
	branch1.add(new SomeStrangeAsynchronousTask());
	//create a local variable to hold a reference to diverse tasks we will be creating that will be fed to a ConditionalTask
	var task: Task;
	//the first task we make creates a delay of 50 frames before it is done
	task = new FrameDelayTask(50);
	//add this task to the branch1 sequence, remember branch1 already has a task that does some asynchronous stuff and so this task will be executed in the sequence after the asynch task has finished.
	branch1.add(task);
	//add the task to the master sequence *inside* a ConditionalTask. this conditional task can only finish when the FrameDelayTask is done.
	master.add(new ConditionalTask(task));
	//create another task, this time a task that waits for a preloader movieclip animation to finish on frame label "preloader_finished"
	task = new TimeLineTask(preloader_mc, "preloader_finished");
	//add the timelinetask to the other sequence referred to by the branch2 variable 
	branch2.add(task);
	//add another task to branch2 that will execute immediately after the preloader finishes. it fires the method 'postPreloaderAnimation'.
	//branch2.add(new CallBackTask(postPreloaderAnimation);
	//add the TimelineTask for the preloader to the master sequence also *inside* a conditional task. this conditional task can only finish when the TimelineTask has finished
	master.add(new ConditionalTask(task));
	//add callback task to master sequence of tasks, a method that will be called when all the previous tasks in the master sequence have finished.
	//in this case, the previous tasks will be two conditional tasks, both of whom are dependent on tasks in a different/independent sequence.
	master.add(new CallBackTask(doSomethingSpecial);
	sequence.addEventListener(SequenceEvent.DONE, onSequenceDone);
	//start all sequences!
	sequence.execute();
	branch1.execute();
	branch2.execute();
	//the end result will be very nice! The master sequence will finish when and only when both the preloader animation has finished AND the asynchronous task and the FrameDelay of 50 frames have finished.
	//it doesn't matter which of the two task finishes first, since the task after both ConditionalTasks in the master sequence can only execute when BOTH have finished.
	//The second conditional task can be 'primed' when the preloader has finished (marked for immediate finish when it is executed) while the task before that (the conditional task that waits for the framedelay task to finish) still has to wait on the framedelaytask.
	//it can also be the other way around: the framedelay might be finished before the preloader animation finishes.
	//in that case the first conditional task will execute and finish immediately but the second conditional task will only finish when it gets the signal from the preloader animation task.
	//when both tasks are done, the dependent ConditionalTasks will have both executed and the next Task will execute, in this case the CallBackTask that will call a method that everything has been done an we can startup the rest of what we want to do in our application.
	//Also keep in mind, that the "postPreloaderAnimation" method will be called right after the preloader finishes, as it is in a seperate sequence from the master sequence.
	//Thus we can have processes running in parallel.	 
	 * </code>
	 * 
	 * @author Mathijs Meijer
	 * @author Rolf Vreijdenberger
	 */
	public class ConditionalTask extends Task {
		private var taskToWaitFor : Task;
		private var continueOnError : Boolean;
		private var allowToContinue : Boolean = false;
		private var errorMessage : String;
		private var isError : Boolean = false;

		
		/**
		 * Constructor
		 * @param taskToWaitFor the task we will wait for to complete before this task can execute/finish.
		 * @param continueOnError when the task we are waiting for generates an error we might still want to continue. default is to not continue. This will be picked up by the Sequence this Task is in.
		 */
		public function ConditionalTask(taskToWaitFor : Task, continueOnError : Boolean = false) {
			this.continueOnError = continueOnError;
			this.taskToWaitFor = taskToWaitFor;
			taskToWaitFor.addEventListener(TaskEvent.DONE, onDone);
			taskToWaitFor.addEventListener(TaskEvent.ERROR, onError);
		}

		override protected function executeTaskHook() : void {
			//if a TaskEvent has not yet set this flag, we are still waiting on the dependent task to fire it's event.
			//we get here because we are being called from the Sequence we are contained in.
			if(!allowToContinue) {
				//set a flag
				allowToContinue = true;
			} else {
				//A TaskEvent has already set the flag
				//check whether it was an error event, or a normal event
				if(isError) {
					//it is an error event, but can we continue on an error?
					if(continueOnError) {
						//yes, continue normally
						done();
					} else {
						//no, send out the previously stored error message
						fail(errorMessage);
					}
				} else {
					//no error, just finish normally
					done();
				}
			}
		}

		private function onDone(event : TaskEvent) : void {
			//check if we are already executing...
			if(!allowToContinue) {
				//no, set a flag that the event has come in
				allowToContinue = true;
			} else {
				//yes, in that case, we can continue
				done();
			}
		}

		private function onError(event : TaskEvent) : void {
			//ooops, an error, get the message
			errorMessage = event.getMessage();
			//when we are not executing yet...
			if(!allowToContinue) {
				//set a flag
				allowToContinue = true;
				//set a flag that we have an error...
				isError = true;
			} else {
				//wa are executing, now test if wa can continue with an error
				if(!continueOnError) {
					//no, send an error
					fail(errorMessage);
				} else {
					//yes, pretend nothing happened
					done();
				}
			}
		}


		override protected function destroyTaskHook() : void {
			taskToWaitFor.removeEventListener(TaskEvent.DONE, onDone);
			taskToWaitFor.removeEventListener(TaskEvent.ERROR, onError);
			this.taskToWaitFor = null;
		}

		override public function toString() : String {
			return "ConditionalTask: " + taskToWaitFor.toString();
		}
	}
}
