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

package nl.dpdk.collections.lists {
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.iteration.IIteratorExtended;

	/**
	 * Ordered collection, also known as a sequence. 
	 * Duplicates are generally permitted. 
	 * Allows positional access and is zero based. 
	 * Extends the ICollection interface
	 * @author Rolf Vreijdenberger
	 */
	public interface IList extends ICollection {
		/**
		 * Returns the data at the specified position in this list.
		 * gets the data at a certain index.
		 * @param i the place at which we want to get the data item
		 * @return the data item or null if it does not exist.
		 */
		function get(i : int) : *;

		
		/**
		 * Replaces the data at the specified position in this list with the specified data.
		 * sets the data of a specific index, adds the data if index is not correct.
		 * @param i the index of the position to set the data on.
		 * @param data the data to set at the index position
		 */
		function set(i : int, data : *) : void;
		
		/**
		 * removes a data item at the specified index. 
		 * @param i the index at which we remove the item (0 based index)
		 * @return true if removal succeeded, false otherwise (false index)
		 */
		function removeAt(i: int): Boolean;
		
		/**
		 * inserts an item at a certain index.
		 * @param i int the index at which we insert the item (0 based index)
		 * @param data the data to insert at the index position
		 */
		function insertAt(i: int, data:*): void;
		

		
		/**
		 * Returns the index of the first occurrence of the specified data item in this list, or -1 if this list does not contain the element.
		 * @param data the data we are looking for
		 * @return the index of the position (zero based) or -1 if not found.
		 */		
		function indexOf(data : *) : int;

		
		/**
		 * Returns the index of the last occurrence of the specified data item in this list, or -1 if this list does not contain the element.
		 * gets the last index of a certain piece of data in case of duplicate data.
		 * else it returns the same index as indexOf()
		 * @return the index of the last occurence, else -1
		 */
		function lastIndexOf(data : *) : int;

		
		/**
		 * adds a collection to the present collection
		 * @param collection a collection to add
		 * @return void
		 */
		function addAll( collection : ICollection) : void;

		
		/**
		 * get a sublist from this list (a copy, not a view). Default is to give back an empty list if the input cannot be normally sanitized.
		 * If 'to' is larger than the size of the list, everything from 'from' to the end of the list is returned 
		 * The sublist is not linked to the current list, so changes in the sublist are not reflected in the new list.
		 * @param from	which index in the list is the beginning of our new list?
		 * @param to	which index in the list is the ending (not included) of the items to add to our new list?
		 * @return List the same type of list as the current implementation with the items asked.
		 */
		function subList(from : int, to : int) : List;

		
		/**
		 * reverse does what is says, it reverses the list.
		 * @return void
		 */
		function reverse() : void;

		
		/**
		 * an extended iterator that has extra functionality.
		 * Returns an extended iterator over the elements in this list (in proper sequence).
		 * @return an extended iterator in proper sequence
		 */
		function iteratorExtended() : IIteratorExtended;

		
		


	}
}
