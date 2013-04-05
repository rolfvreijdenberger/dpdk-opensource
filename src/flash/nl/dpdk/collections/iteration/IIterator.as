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

package nl.dpdk.collections.iteration {

	/**
	 * An iterator over a structure.
	 * An interface to uniformly access collections of data.
	 * @see IIterable
	 * @author Rolf Vreijdenberger
	 */
	public interface IIterator {
		/**
		 * checks to see if there is a next data item in the structure
		 * @return true if there is another next element in  the structure
		 */
		function hasNext() : Boolean;

		
		/**
		 * Returns true if this structure iterator has more elements when traversing the structure.
		 * moves to the next data item in the structure and returns it.
		 * The first call returns the first object.
		 * use in conjunction with hasNext()
		 * @return the next data item to retrieve (the first if it is called the first time) or null if there is no data item to retrieve (out of bounds)
		 */
		function next() : *;

		
		/**
		 * Removes from the underlying structure the last element returned by the iterator.
		 * points to the element <em>before (implementation specific)</em> the current element (the one to remove) when finished.
		 * When using an iterator and an item is deleted via the structure directly instead of via the iterator, the behaviour might vary across implementations as to where the iterator is pointing to.
		 * In other words, when using traversal via an iterator and elements are removed on the structure itself, the iterator is invalidated!
		 * When using multiple iterators at the same time and using remove(), the iterator that is not used for the removal is invalidated.
		 * @return true if removal worked, false if not (structure empty or invalid pointer)
		 */
		function remove() : Boolean;
	}
}
