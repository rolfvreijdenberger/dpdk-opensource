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
	import nl.dpdk.collections.iteration.IIterable;	

	/**
	 * The main interface for the whole collections package.
	 * A collection is a group of objects. 
	 * No assumptions are made about the order and the structure of the collection (if any), or whether it may contain duplicate elements.
	 * @author Rolf Vreijdenberger
	 */
	public interface ICollection extends IIterable {
		/**
		 * adds data to the collection, exactly how is implementation specific.
		 * @param data any type of data we wish to put in the collection (make  sure it is the same datatype throughout the list)
		 */
		function add(data : *) : void;

		
		/**
		 * clears the whole collection, removes all elements
		 */		
		function clear() : void;

		
		/**
		 * checks if the collection contains a certain piece of data.
		 * @param data the data item to check for
		 * @return	true if in the collection
		 */		
		function contains(data : *) : Boolean;

		
		/**
		 * is the collection empty (0 data items)
		 * @return true if this collection contains no elements
		 */
		function isEmpty() : Boolean;

		
		/**
		 * Removes a single instance of the specified element from this collection, if it is present (the first one encountered if more instances are in the collection)
		 * @param data any type of data we wish to remove
		 * @return true if removal worked, false otherwise (data not available)
		 */		
		function remove(data : *) : Boolean

		
		/**
		 * get the size of the collection
		 * @return the number of elements in this collection.
		 */
		function size() : int;

		
		/**
		 * returns an array of the data items in the collection, the order of the items and the output is implementation specific.
		 * This can be used to get all the data elements, but do not make any assumption about the order of the items. Ever.
		 * @return an array with the data items
		 */		
		function toArray() : Array;

		
		/**
		 * @return toString representation of the list.
		 * This can be anything and should only be used for debugging.
		 */
		function toString() : String;
	}
}
