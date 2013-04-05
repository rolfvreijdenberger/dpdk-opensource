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
	import nl.dpdk.collections.iteration.IIterator;

	/**
	 * In addition to the functionality of the Iterator interface, supports bi-directional iteration, element replacement, element insertion and element removal.
	 * @author Rolf Vreijdenberger
	 */
	public interface IIteratorExtended extends IIterator {
		/**
		 * can be called to insert data at a specific point.
		 * It inserts the data before the current element and remains at the current element.
		 * used with previous() and next() in can insert before or after a certain element in the structure.
		 * if we are not at a valid pointer, the data is appended.
		 * when traversing a structure with an iterator and the structure is manipulated by adding/deleting/inserting items on the structure itself, the iterator is invalidated
		 * @param data the data item to insert
		 */
		function insert(data : *) : void;

		
		/**
		 * resets the structure to the beginning of the structure
		 */
		function begin() : void;

		
		/**
		 * resets the structure to the end of the structure
		 */
		function end() : void;

		
		/**
		 * Returns true if this structure iterator has more elements when traversing the structure in the reverse direction.
		 * checks if there is a previous element
		 * @return true if there is a previous data element
		 */
		function hasPrevious() : Boolean;

		
		/**
		 * gets the previous data item
		 * calls to previous might be implemented in a circular way on the collection.
		 * This method may be called repeatedly to iterate through the structure backwards, or intermixed with calls to next to go back and forth. 
		 * Note that alternating calls to next and previous will return the same element repeatedly.
		 * @return the previous data item in the structure (the last if it is called the first time after using end()) or null if there is no item
		 */
		function previous() : *;

		
		/**
		 * Replaces the last element returned by next or previous with the specified element
		 * @return true if we have a valid pointer, false otherwise
		 */
		function set(data : *) : Boolean;
	}
}
