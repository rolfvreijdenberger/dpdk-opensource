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
	import nl.dpdk.collections.iteration.IIteratorExtended;	
	
	/**
	 * An iterator over a basic array.
	 * this provides functionality for normal iteration and reversed iteration, but this depends on the datatype of a client's iterator: IIterator or IIteratorExtended
	 */
	public class ArrayIterator implements IIteratorExtended {
		private var array : Array;
		private var position : Number;

		/**
		 * creates an IIterator over an Array.
		 * @param array the array to iterate over
		 */
		public function ArrayIterator(array : Array) {
			this.array = array;
			begin();
		}

		
		public function hasNext() : Boolean {
			if(position < array.length - 1) return true;
			return false;
		}

		
		public function next() : * {
			if(position++ > array.length) position = array.length;
			var data : * = array[position];
			return data;
		}

		
		public function remove() : Boolean {
			if(array.length == 0 || position >= array.length || position < 0) return false;
			array.splice(position, 1);
			if(--position < 0 ) position = 0;
			return true;
		}

		
		/**
		 * can be called to insert data at a specific point.
		 * It inserts the data before the current element and remains at the current element.
		 * used with previous() and next() in can insert before or after a certain element in the list.
		 * if we are not at a valid pointer, the data is appended.
		 * when traversing a list with an iterator and the list is manipulated by adding/deleting/inserting items on the list itself, the iterator is invalidated
		 * @param data the data item to insert
		 */
		public function insert(data : *) : void {
			if(position > array.length - 1 ) position = array.length - 1;
			if(position < 0 ) position = 0;
			array.splice(position, 0, data);
			++position;
		}

		
		/**
		 * resets the list to the beginning of the list
		 */
		public function begin() : void {
			position = -1;
		}

		
		/**
		 * resets to the end of the array
		 */
		public function end() : void {
			position = array.length;
		}

		
		/**
		 * Returns true if this iterator has more elements when traversing in the reverse direction.
		 * checks if there is a previous element
		 * @return true if there is a previous data element
		 */
		public function hasPrevious() : Boolean {
			return position > 0;
		}

		
		/**
		 * gets the previous data item
		 * This method may be called repeatedly to iterate through the array backwards, or intermixed with calls to next to go back and forth. 
		 * Note that alternating calls to next and previous will return the same element repeatedly.
		 * @return the previous data item in the array (the last if it is called the first time after using end()) or null if there is no item
		 */
		public function previous() : * {
			if(--position < -1) position = -1;
			var data : * = array[position];
			return data;
		}

		
		/**
		 * Replaces the last element returned by next or previous with the specified element
		 * @return true if we have a valid pointer, false otherwise
		 */
		public function set(data : *) : Boolean {
			if(position < 0 || position > array.length - 1 || array.length == 0) return false;
			array[position] = data;
			return true;
		}
	}
}