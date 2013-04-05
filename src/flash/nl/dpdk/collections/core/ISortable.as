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

	/**
	 * An interface that explicitely says the instance can be sorted.
	 * @see Comparators
	 * @see SortTypes
	 * @author Rolf Vreijdenberger
	 */
	public interface ISortable {
		
		/**
		 * basic comparators can be found in Comparators.
		 * the sort types to be used can be found in SortTypes.
		 * Check the implementation if the sortType is supported and to what it defaults if not supported.
		 * @param comparator the comparison function to be used on the data to be sorted.
		 * @param sortType the sorttype to be used. defaults to the most general useful one for our implementation when a sortType is not implemented on the implementation.
		 */
		function sort(comparator : Function, sortType : int = 0) : void;
	}
}
