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
	import nl.dpdk.commands.tasks.Task;

	/**
	 * CommandTask acts as a wrapper/decorator (http://en.wikipedia.org/wiki/Decorator_pattern) around a Command, thereby making an implementation of ICommand itself sequencable.
	 * It allows us to feed an existing Command or CompositeCommand to a Task / sequence.
	 * 
	 * Commands can be asynchronous in execution, but this class does not take that into account.
	 * Commands also do not inform a client of it's execution state.
	 * For control over asynchronous commands and execution state, use a custom subclass of Task instead.
	 * 
	 * usage:
	 <code>
	 //create a task sequence, wait 1.5 seconds and execute a command via the CommandTask decorator.
	 var sequence: Sequence = new Sequence(); 
	 sequence.add(new TimeDelayTask(1500)); 
	 sequence.add(new CommandTask(new myConcreteCommandImplementation()));
	 sequence.execute();
	 </code>
	 * 
	 * @author rolf vreijdenberger, Thomas Brekelmans (inspiration)
	 */
	public class CommandTask extends Task {
		private var command: ICommand;
		
		public function CommandTask(command: ICommand) {
			this.command = command;
		}

		override protected function executeTaskHook() : void {
			command.execute();
			done();
		}

		override protected function destroyTaskHook() : void {
			trace("CommandTask.destroyTaskHook()");
			command = null;
		}
		
		override public function toString() : String {
			return "CommandTask";
		}
	}
}
