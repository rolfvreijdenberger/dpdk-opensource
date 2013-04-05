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
	import nl.dpdk.commands.tasks.Task;

	/**
	 * A CallBackTask is a Task that executes a callback method.
	 * This can be very convenient in a sequence with a TimeDelayTask or FrameDelayTask.
	 * It means you could wait a while before executing a method.
	 * You can add any number of arguments to the constructor for the callback function to take as arguments when it is called.
	 * 
	 * usage:
	 * <code>
	 //wait 5 seconds to finish
	 var task: Task = new TimeDelayTask(5000);
	 //add callback task to sequence of tasks
	 task.addTask(new CallBackTask(myMethod);
	 //add listener
	 task.addEventListener(TaskEvent.DONE, onTaskDone);
	 //start the sequence.
	 task.execute();
	 * </code>
	 * 
	 * @see nl.dpdk.commands.CallBackCommand
	 * @author rolf vreijdenberger
	 */
	public class CallBackTask extends Task {
		private var callBack : Function;
		private var args: Array;
		
		/**
		 * @param callBack the method that will be called when executing this task.
		 * @param args any number of arguments that will be passed to the callback function when it is called.
		 * 
		 */
		public function CallBackTask(callBack: Function, ...args) {
			this.callBack = callBack;
			this.args = args;
		}
	
		override protected function executeTaskHook() : void {
			callBack.apply(null, args);
			done();
		}
	
		override protected function destroyTaskHook() : void {
			callBack = null;
			args = null;
		}
	
		override public function toString() : String {
			return "CallBackTask";
		}
	}
}
