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

package nl.dpdk.collections.sorting {

	/**
	 * A collection of sort types to be used on the sorting methods of ICollection instances, so a client can choose his own sorting type if he knows what he is doing.
	 * Defaults are provided for the sort methods that are best in most cases.
	 * <p>
	 * <ul> 
	 * <li>bubble sort O(N^2), don't ever use, the worst sort algorithm</li>
	 * <li>selection sort O(N^2), simple and easy but slow</li>
	 * <li>insertion sort O(N^2) worst case to O(N) for nearly sorted list, great for keeping an almost sorted list sorted, then appending some stuff and sort again</li>
	 * <li>shell sort O(N^(4/3)), variation on insertion sort, but with better performance (which highly depends on some performance optimizers)</li>
	 * <li>mergesort O(NlogN) in all cases</li>
	 * <li>quicksort O(N^2) worst case for sorted input, to O(N^(1,2) for random input). This is only empirical, as of yet not proven mathematically. This is not a stable sort</li>
	 * <li>heapsort O(NlogN) in all cases</li>
	 * <li>proximity map (which is not a comparison sort, also called key indexed sort or counting sort) sorting O(N) for best case (no duplicate keys) O(N^2) for worst case (all keys equal value). a good mapping function has to be provided, which converts the search key to an integer (signature)</li>
	 * <li>radix sort (which is not a comparison sort, examines individual bits of keys ) O(N) guaranteed (k linear passes through the 'deck' of n keys when the keys have k digits). a good mapping function has to be provided, which converts the search key to an integer (signature)</li>
	 * </ul>
	 * 
	 * 
	 * stable: it preserves the input order of equal elements in the sorted output.
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class SortTypes {
		//the native flash sort, on an array, probably quicksort based.
		public static const NATIVE : int			= 0;
		//selection sort
		public static const SELECTION: int 			= 1;
		//bubble sort, the worst possible sort
		public static const BUBBLE: int 			= 2;
		//insertion sort, very fast for nearly sorted lists, bad otherwise.
		public static const INSERTION: int 			= 3;
		//shell sort, a variation on quick sort, which runs very fast.
		public static const SHELL: int 				= 4;
		//quicksort, one of the fastest sorting algorithms that is comparison based with O(NLogN) to O(n^2) worst case.
		public static const QUICK: int 				= 5;
		//merge sort, the method of choice for linked lists with O(NLogN) as worst and average case.
		public static const MERGE: int 				= 6;
		//heap sort, fast sorting algorithm with O(NLogN) as worst and average case.
		public static const HEAP: int 				= 7;
		//proximity map sorting is an O(N) based sort. it is not a comparison based method but an address calculation based technique.
		public static const PROXIMITYMAP: int		= 8;
		//radix sorting: O(N) guaranteed (since at most d linear passes are made if a key has d digits)
		public static const RADIX: int 				= 9;
		//binary insertion sort, optimizer for insertion sort, great for nearly sorted lists.
		public static const BINARY_INSERTION: int	= 10;
	}
}
