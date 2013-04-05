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
	 * A linear collection that supports element insertion and removal at both ends. 
	 * The name deque is short for "double ended queue" and is usually pronounced "deck".
	 * A Deque is a more modern implementation of a queue and a stack structure in one.
	 * @author Rolf Vreijdenberger
	 * 
	 */
	public interface IDeque extends ICollection {
		
		/**
		 * adds data to the datastructure as the first item (queue.enqueue)
		 * @param data a data item of any type
		 * @return void
		 */
		function addFirst(data : *) : void;

		/**
		 * gets the first item of a datastructure.
		 * analogous to peek() on a queue.
		 * peeks at the first item (queue.peek()) but does not remove it.
		 * @return a data item of any type
		 */
		function getFirst() : *;

		/**
		 * adds data to the datastructure as the last item (stack.push())
		 * @param data a data item of any type
		 * @return void
		 */
		function addLast(data : *) : void;

		/**
		 * gets the last item of a datastructure.
		 * analogous to peek() on a Stack.
		 * peeks at the last item (stack.peek()) but does not remove it.
		 * @return a data item of any type
		 */
		function getLast() : *;


		/**
		 * removes the first item of a datastructure (queue.dequeue()).
		 * @return a data item of any type
		 */
		function removeFirst() : *;

		/**
		 * removes the last item of a datastructure (stack.pop()).
		 * @return a data item of any type
		 */
		function removeLast() : *;
	}
}
