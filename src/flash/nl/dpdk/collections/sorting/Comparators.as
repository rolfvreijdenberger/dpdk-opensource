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
	import nl.dpdk.collections.sorting.SortOrder;	

	/**
	 * Comparators holds some default implementations for comparision methods used for sorting and searching.
	 * <p>
	 * This class can be subclassed with domain specific comparison methods to hold business logic for comparisons on datasets in one place in the code.
	 * Then again, subclassing is not necessary, the methods can be defined anywhere, including in instances of objects that are preconfigured (for instance with specifications that are used in the comparator at runtime) and they do not need to be static.
	 * <p><p>
	 * Multiple keys of objects can be used to sort the result, so it is possible to have sorted list inside the sorted structure (nested sorts).
	 * See the commented example in the source code.
	 * <p><p>
	 * When a sorting algorithm is stable, the relative order in the first list (on multiple keys) will be preserved in the ordered list.
	 * Stable sorts, or sorts that can be made stable, are:
	 * <ul> 
	 * <li>bubble sort</li>
	 * <li>selection sort</li>
	 * <li>insertion sort</li>
	 * <li>shell sort</li>
	 * <li>mergesort</li>
	 * </ul>
	 * Quicksort and heapsort are not stable.
	 * <p><p>
	 * All methods take as input two parameters of the type we are comparing and are compared to see what the sort order is. 
	 * If a sorts before b for our type of comparison (A<B), -1 is returned, if the same (A==B) 0 is returned,  else (A>B) 1.
	 * Make sure to put the comparison that is most likely to succeed as the first check in the method, to optimize for speed.
	 * <p><p>
	 * Caution should be taken when implementing this kind of methods to make them as fast as possible, as sorting is expensive and these methods will be called lots of times (probably in a nested loop).
	 * In the best case at least O(NlogN) times, in worst case O(N^2) times, with N being the input length.
	 * <p><p>
	 * The implementation of an IComparable type of interface (compareTo(a,b)) is specifically not chosen as this would probably severely hinder the usage of the different datasets (of type ICollection, which would then have to take an input datatype of IComparable).
	 * 
	 * @see ArrayList.sort()
	 * @see LinkedList.sort();
	 * @see BinarySearchTree.search()
	 * @see PriorityQueue
	 * @see ISpecification
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class Comparators {
		public static function compareString(a : String, b : String) : int {
			/**
			 * this could also be done on a character level, but we will just let flash deal with that for us
			 */
			if(a < b) return SortOrder.LESS;
			if(a > b) return SortOrder.LARGER;
			return SortOrder.EQUAL;	
		}

		
		public static function compareStringDescending(a : String, b : String) : int {
			return -compareString(a, b);	
		}

				public static function compareStringCaseInsensitive(a : String, b : String) : int {
			return	compareString(a.toLowerCase(), b.toLowerCase());
		}

				public static function compareStringCaseInsensitiveDescending(a : String, b : String) : int {
			return -compareStringCaseInsensitive(a, b);
		}

		
		public static function compareIntegers(a : int, b : int) : int {
			if(a < b) return SortOrder.LESS;
			if(a > b) return SortOrder.LARGER;
			return SortOrder.EQUAL;	
		}

		
		public static function compareIntegersDescending(a : int, b : int) : int {
			return -compareIntegers(a, b);
		}

		
//		public static function exampleNestedSort(a : *, b : * ) : int {
//			/**
//			 * the objects to be compared have properties x, y, z;
//			 * nested sorting can become very complex, so check the example below. 
//			 */
//			//smaller
//			if(a.x < b.x) return SortOrder.LESS;
//			//nested sorting always takes place in the equals comparison
//			if(a.x == b.x) {
//				//sort on second key
//				if(a.y < b.y) return SortOrder.LESS;
//				//if more keys exist, just check for the next keys
//				if(a.y == b.y) return SortOrder.EQUAL;
//				//larger
//				if(a.z == 1) {
//					/**
//					 * complex rule! 
//					 * we have a specific property we are looking for only when the x's are equal and the y of a is larger 
//					 */
//					return SortOrder.LARGER
//				}else {
//					return SortOrder.LESS;	
//				}
//			}
//			//larger
//			return SortOrder.LARGER;
//		}
	}
}
