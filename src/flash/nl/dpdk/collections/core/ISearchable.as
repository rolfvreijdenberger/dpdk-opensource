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
	 * An interface that explicitely says we can do searches.
	 * @see Comparators
	 * @author Rolf Vreijdenberger
	 */
	public interface ISearchable extends ICollection {
		/**
		 * searches for a data item in a collection that has the same key implemented to be compared to.
		 * the key is provided in the data object, the comparison method is injected in the implementing class.
		 * The comparison method is specific for the data type that is used. Examples can be found in the Comparators class.
		 * @param data the data item to search for
		 * @return the data item if it is found, null otherwise
		 */
		function search(data : *) : *;

	}
}
