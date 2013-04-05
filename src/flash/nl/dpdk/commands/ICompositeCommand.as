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
	import nl.dpdk.commands.ICommand;			
	/**
	 * The Interface for a CompositeCommand aka. MacroCommand.
	 * @author rolf vreijdenberger
	 */
	public interface ICompositeCommand extends ICommand {
		/**
		 * add a command to the composite, to be executed in the sequence of commands
		 * @param command the ICommand to add
		 */
		function add(command : ICommand) : void;		/**
		 * remove a command from the composite
		 * @param command the ICommand to remove
		 * @return Boolean, whether or not the removal was succesful
		 */
		function remove(command : ICommand) : Boolean;		/**
		 * checks if a certain command is present.
		 * @param command The Icommand to check for.
		 * @return Boolean true if the command is in the composite.
		 */
		function contains(command : ICommand) : Boolean;
	}
}
