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

	/**
	 * A simple implementation that serves as an example of a concrete Command implementation.
	 * It calls a function when the command is executed,
	 * with the additional functionality of adding multiple arguments at construction time.
	 * This command can be used as a parameterized delegate (for those who remember the as2 days and Delegate.create() )
	 * 
	 * This is very powerful since it means we can insert parameters for a method at construction time and just pass around the command through our application,
	 * and be sure that when the command is called, the callback is called with the right parameters.
	 * @author rolf vreijdenberger
	 */
	public class CallbackCommand implements ICommand {
		private var callback : Function;
		private var args: Array;

		/**
		 * constructor
		 * the constructor is used to inject a function in the command
		 * @param callback a function to be called in the execute() method
		 * @param args multiple optional arguments that will be used when the callback function is executed as parameters to the callback.
		 */
		public function CallbackCommand(callback : Function, ...args) {
			this.callback = callback;
			this.args = args;
		}

		
		/**
		 * execute the command
		 */
		public function execute() : void {
			callback.apply(null, args);	
		}

		public function toString() : String {
			return "CallbackCommand";
		}
	}
}
