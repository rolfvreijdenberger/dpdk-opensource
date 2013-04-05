/*
Copyright (c) 2008 De Pannekoek en De Kale B.V.,  www.dpdk.nl

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

package nl.dpdk.commands {
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.lists.LinkedList;	

	/**
	 * Command Pattern [GoF] implementation
	 * CompositeCommand (aka MacroCommand) can be used to insert multiple ICommand instances which will be handled in the execute() method
	 * @author rolf
	 */
	public class CompositeCommand implements ICompositeCommand {
		private var commands : List;

		public function CompositeCommand() {
			commands = new LinkedList();
		}

		
		/**
		 * this method will call all commands added to this class
		 */
		public function execute() : void {
			var command : ICommand;
			var iterator : IIterator = commands.iterator();
			while(iterator.hasNext()) {
				command = iterator.next() as ICommand;	
				command.execute();	
			}
		}

		
		/**
		 * this method can be used to add multiple commands that will be used in the execute() method
		 * @param command	a concrete command that implements the ICommand interface
		 */
		public function add(command : ICommand) : void {
			commands.add(command);
		}

		
		public function remove(command : ICommand) : Boolean {
			return commands.remove(command);	
		}

		public function contains(command : ICommand) : Boolean {
			return commands.contains(command);	
		}

		public function toString() : String {
			return "CompositeCommand";
		}
	}
}
