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

package nl.dpdk.collections.core {
	import nl.dpdk.collections.core.ICollection;	
	
	/**
	 * A Stack is a LIFO (Last in First Out) structure. Often referred to as a pushdown stack.
	 * The last item to be put on the Stack is the first one to come out.
	 * Often used for evaluating parse trees or to implement recursive functions in an iterative form.
	 * @author Rolf Vreijdenberger
	 */
	public interface IStack extends ICollection {
		/**
		 * pops / removes an item from the stack
		 * @return the data item that is next to come of the stack or null if stack is empty
		 */
		function pop():*;
		
		/**
		 * pushes /adds a data item to the stack
		 * @param data the data item to be pushed on the stack
		 */
		function push(data: *): void;

	}
}
