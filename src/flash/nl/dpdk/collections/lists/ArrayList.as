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
	import nl.dpdk.collections.core.ICollection;	import nl.dpdk.collections.core.IMapper;	import nl.dpdk.collections.iteration.IIterator;	import nl.dpdk.collections.iteration.IIteratorExtended;	import nl.dpdk.collections.sorting.SortOrder;	import nl.dpdk.collections.sorting.SortTypes;	import nl.dpdk.specifications.ISpecification;	
	/**
	 * ArrayList, a datastructure to hold collections of items and to allow manipulations of these items.
	 * know caveats: this class is a bad queue when compared to a LinkedList, because we are not using a circular buffer implementation (not possible as this class is also a stack).
	 * <p>
	 * It's main purpose is to be a robust and functional class. 
	 * It is not optimized to have a small footprint.
	 * Clarity of code goes over speed of access and memory, as accessors are provided and the class is fully encapsulated.
	 * <p>
	 * The node implementation of this class is LinkedList.
	 * Be sure to know the differences between the two (in terms of performance and memory) when implementing either one of them.
	 * <p>
	 * This class can be subclassed to provide alternate behaviour (for perhaps an iterator)
	 * <p>
	 * It can serve as a variety of abstract data types that can be represented by a ArrayList such as:
	 * <ul>
	 * <li>A normal List (List type)</li>
	 * <li>A queue (IQueue interface)</li>
	 * <li>A Stack (IStack interface)</li>
	 * <li>A Deque (IDeque interface). Double ended queue, a replacement for the traditionalist stack and queue data types</li>
	 * <li>An ArrayList, with all the functionality of it's implemented interfaces</li>
	 * </ul>
	 * <p>
	 * <p>
	 * It implements various interfaces and can thus be used in different contexts.
	 * <p>
	 * for example:
	 * <ul>
	 * <li>make it a queue implementation
	 * <code>
	 * var queue: IQueue = new ArrayList();
	 * queue.enqueue(data);</code>
	 * </li>
	 * <li>make it a stack implementation
	 * <code>
	 * var stack: IStack = new ArrayList();
	 * stack.push(data);</code>
	 * </li>
	 * <li>make it a deque implementation
	 * <code>
	 * var deque: IDeque = new ArrayList();
	 * deque.addFirst(data);</code>
	 * </li>
	 *  <li>make it a List implementation
	 * <code>
	 * var list: List = new ArrayList();
	 * list.add(data);</code>
	 * </li>
	 * </ul>
	 * <p><p>
	 * The List type (and therefore also ArrayList) can be used for all this functionality, but also has sorting, mapping, folding, applying and selecting as <em>major</em> features.
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class ArrayList extends List  {
		internal var collection : Array = new Array();

		public function ArrayList(collection : ICollection = null) {
			
			addCollection(collection);
		}



		/**
		 * @inheritDoc
		 */
		public override function map(mapper : IMapper) : List {
			var iterator : IIterator = iterator();
			var list : List = new ArrayList();
			while(iterator.hasNext()) {
				list.add(mapper.map(iterator.next()));
			}
			return list;
		}


		
		/**
		 * expensive for this implementation.
		 * @inheritDoc
		 */
		public override function addFirst(item : *) : void {
			//expensive for large lists
			collection.unshift(item);
			++listSize;
		}

		/**
		 * @inheritDoc
		 */
		public override function getFirst() : * {
			return collection[0];
		}



		/**
		 * @inheritDoc
		 */
		public override function getLast() : * {
			return collection[listSize - 1];
		}

		
		/**
		 * expensive for this implementation.
		 */
		public override function removeFirst() : * {
			//expensive
			if(listSize == 0) return null;
			--listSize;
			return collection.shift();
		}

		/**
		 * @inheritDoc
		 */
		public override function removeLast() : * {
			if(listSize == 0) return null;
			--listSize;
			return collection.pop();
		}

		
		/**
		 * @inheritDoc
		 */
		public override function add(data : *) : void {
			++listSize;
			collection.push(data);
		}

		/**
		 * @inheritDoc
		 */
		public override function clear() : void {
			collection = new Array();
			listSize = 0;
		}

		/**
		 * @inheritDoc
		 */
		public override function contains(data : *) : Boolean {
			for(var i : int = 0;i < listSize;++i) {
				if(collection[i] == data) {
					return true;
				}
			}
			return false;
		}


		
		/**
		 * faster when used with the linked list implementation with the iterator.
		 * @inheritDoc
		 */
		public override function remove(data : *) : Boolean {
			for(var i : int = 0;i < listSize;++i) {
				if(collection[i] == data) {
					collection.splice(i, 1);
					--listSize;
					return true;
				}	
			}
			return false ;		
		}

		
		private function getListSize() : int {
			return listSize;
			//return collection.length;
		}



		/**
		 * @inheritDoc
		 */
		public override function toArray() : Array {
			/**
			 * don't mess directly with the list. make a copy
			 */
			return collection.concat();
		}

		/**
		 * @inheritDoc
		 */
		public override function toString() : String {
			return "ArrayList of size " + size();
		}

		/**
		 * @inheritDoc
		 */
		public override function iterator() : IIterator {
			/*
			 * we do not use an array iterator here, as we keep a size reference in this class that needs to be updated.
			 * this cannot be done through the ArrayIterator.
			 * we might want to refactor this and get rid of the size reference.
			 */
			return new ArrayListIterator(this, collection) ;
		}



		
		/**
		 * enqueues a data item in the queue.
		 * TRICKY: expensive for an array based list. 
		 * this implementation is naive because we do not use a circular buffer on the array because of the other functionality on the list.
		 * therefore, enqueing is very slow, use a linked list as a queue instead.
		 * @param data any type of data
		 * @return void
		 */
		public override function enqueue(data : *) : void {
			++listSize;
			collection.push(data);
			//addLast(data);
		}

		
		/**
		 * removes the item that is currently on the queue
		 * TRICKY: expensive for an array based list. 
		 * this implementation is naive because we do not use a circular buffer on the array because of the other functionality on the list.
		 * therefore, enqueing is very slow, use a linked list as a queue instead. 
		 * @return the data item that is taken out of  the queue to be processed by the client, or null if queue is empty
		 */
		public override function dequeue() : * {
			if(listSize == 0) return null;
			--listSize;
			return collection.shift();
			//return removeFirst();
		}

		/**
		 * @inheritDoc
		 */
		public override function pop() : * {
			if(listSize == 0) return null;
			--listSize;
			return collection.pop();
			//return removeLast();
		}

		
		/**
		 * @inheritDoc
		 */
		public override function push(data : *) : void {
			++listSize;
			collection.push(data);
			//addLast(data);
		}

		
		/**
		 * very fast on this implementation.
		 * @inheritDoc
		 */
		public override function get(i : int) : * {
			return collection[i];
		}

		/**
		 * @inheritDoc
		 */
		public override function set(i : int, data : *) : void {
			if(i > listSize || i < 0) {
				add(data);
				return;	
			}
			
			collection[i] = data;
			return;
		}

		/**
		 * @inheritDoc
		 */
		public override function removeAt(i : int) : Boolean {
			if(i >= listSize || i < 0) {
				return false;
			}
			
			collection.splice(i, 1);
			--listSize;
			return true;
		}

		/**
		 * @inheritDoc
		 */
		public override function insertAt(i : int, data : *) : void {
			if(i < 0 || i > listSize) {
				add(data);
				return;	
			}
			collection.splice(i, 0, data);
			++listSize;
			return;
		}

		/**
		 * @inheritDoc
		 */
		public override function indexOf(data : *) : int {
			return collection.indexOf(data);
		}

		/**
		 * @inheritDoc
		 */
		public override function lastIndexOf(data : *) : int {
			return collection.lastIndexOf(data);
		}



		/**
		 * @inheritDoc
		 */
		public override function subList(from : int, to : int) : List {
			
			var sub : ArrayList = new ArrayList();
			if(from < 0 || from >= getListSize() || getListSize() == 0 || to <= from ) {
				//empty list
				return sub;	
			}
			var temp : Array = collection.slice(from, to);
			var tempLength : int = temp.length;
			for(var i : int = 0;i < tempLength;++i) {
				sub.add(temp[i]);	
			}
			return sub;
		}

		/**
		 * @inheritDoc
		 */
		public override function reverse() : void {
			collection = collection.reverse();
		}

		/**
		 * @inheritDoc
		 */
		public override function iteratorExtended() : IIteratorExtended {
			return new ArrayListIterator(this, collection);
		}

		/**
		 * @inheritDoc
		 */
		public override function selectBy(specification : ISpecification) : List {
			var list : ArrayList = new ArrayList();
			var theSize : int = getListSize();
			for(var i : int = 0;i < theSize;++i) {
				if(specification.isSatisfiedBy(collection[i])) {
					list.add(collection[i]);
				}
			}	
			return list;
		}

		
		/**
		 * TODO, comment
		 * @inheritDoc
		 */
		public override function sort(comparator : Function, sortType : int = 5) : void {
			
			switch(sortType) {
				case SortTypes.SELECTION:
					selectionSort(comparator);
					break;
				
				case SortTypes.BUBBLE:
					bubbleSort(comparator);
					break;
				case SortTypes.BINARY_INSERTION:
					binaryInsertionSort(comparator);
					break;
				case SortTypes.INSERTION:
					insertionSort(comparator);
					break;
					
				case SortTypes.SHELL:
					shellSort(comparator);
					break;
					
				
				case SortTypes.MERGE:
					doMergeSort(comparator);
					break;
					
				case SortTypes.QUICK:
					quickSort(0, getListSize() - 1, comparator);
					/**
					 * a variation on quicksort can be a hybridsort.
					 * as a recursive program is bound to call itself for many small subfiles, we should try to let it call itself with the best method possible when encountering subfiles.
					 * we can do this by changing the test at the beginning of quiksort to:
					 * if(right - left <= 9) return;
					 * and after the quiksort, let insertionsort finish the job in O(n), as the list will be nearly sorted.
					 * insertionSort(comparator);
					 * a value of 9 turns out to give 10% improvement (empirically and analytically) 
					 */
					break;
					 
				case SortTypes.NATIVE:
				//fall through to default
				default:
					/**
					 * damn, this is actually the fastest, since this is ofcourse highly optimized for the flash player as arrays are native objects.
					 * well, I've had fun doing all the sortings anyway :)
					 */ 
					collection.sort(comparator);
					break;
			}
		}

		
		
		/**
		 * Shell sort, a variation of insertion sort, lets an element take bigger steps toward its expected sorted position.
		 * This particular implementation of Shell's sort is very fast, and benchmarked faster than the quicksort implementation.
		 */
		private function shellSort(comparator : Function) : void {
			
			
			/**
			 * gap sequence (diminishing increments), defined by a geometric progression or another sequence, this can be an extreme optimizer.
			 * the sequence defined below is faster than Shell's and Knuth's original proposals.
			 * Shell: i^2 for i >= 0.
			 * Knuth: (3*i) + 1 for i >= 0.
			 * this one: 4^(i+1) + (3*2^i) + 1 for i > 0.
			 */
			var gapSequence : Array = new Array();
			var gapIndex : int = 0;
			var theSize : int = getListSize();
			//we always come back to insertion sort, with a gap of 1.
			gapSequence.push(1);
			//create a short gap sequence that suffices for most flash purposes 
			for(var g : int = 1;g <= 10; ++g) {
				/**
				 * Knuth:
				 * gapSequence[g] = (3 * i) + 1;
				 */
				gapSequence[g] = Math.pow(4, g + 1) + (3 * Math.pow(2, g)) + 1;
				if(gapSequence[g] < theSize) {
					gapIndex = g;
				}else {
					break;
				} 
			}
			
			var gap : int;
			var j : int;
			var value : *;
			
			for(true;gapIndex >= 0; --gapIndex) {
				gap = gapSequence[gapIndex];
				for(var i : int = gap;i < theSize;++i) {
					j = i;
					value = collection[i];
					while(j >= gap && comparator(value, collection[j - gap]) == SortOrder.LESS) {
						collection[j] = collection[j - gap];
						j -= gap;	
					}
					collection[j] = value;
				}
			}
		}

		
		/**
		 * quicksort is a fast sorting algorithm on unsorted data O(NLogN), on sorted data (worst case scenario) it can be O(N^2)
		 * for almost sorted or sorted data use insertionSort as this will be faster: O(N).
		 * @see insertionSort
		 * @param left the left bound of the array
		 * @param right the right bound of the array
		 * @param comparator the comparison function
		 * @see partition
		 */
		private function quickSort(left : int, right : int, comparator : Function) : void {
			//recursive implementation, a divide and qonquer approach
			if(right <= left) return;
			var pivot : int = partition(left, right, comparator);
			//recursively sort the left part
			quickSort(left, pivot - 1, comparator);
			//and the right part
			quickSort(pivot + 1, right, comparator);
		}

		
		/**
		 * helper method for quicksort.
		 * since partition reorders some elements within itself, quicksort is not stable (at least, this version is not)
		 * @param theArray the array to quicksort
		 * @param left the left bound of the array
		 * @param right the right bound of the array
		 * @param comparator the comparison function 
		 * @see quickSort
		 */
		private function partition(left : int, right : int, comparator : Function) : int {
		
			var i : int = left - 1;
			var j : int = right;
			//take the rightmost part of the array as the pivot (note: there are other methods for getting more efficient pivot points)
			var value : * = collection[right];
			while (true) {
				//find index of element that should be swapped in the left part
				while(comparator(collection[++i], value) == SortOrder.LESS){};
				//find index of element that should be found in the right part
				while(comparator(value, collection[--j]) == SortOrder.LESS) {
					//we reached the end
					if(j == left) {
						break;
					}
				}
				//if we cross...
				if(i >= j) {
					break;
				}
				//exchange the parts that are not in the right place
				exchange(i, j);	
			}
			//exchange to get the new pivot point in the right position
			//one less element to process
			exchange(i, right);
			//new pivot point
			return i;
		}

		
		private function mergeSort(array : Array, comparator : Function) : Array {
			if(array.length <= 1) {
				return array;	
			}
			var middle : int = array.length >> 1;
			//a nonrecursive implementation will probably be faster, array.slice is expensive.
			return merge(mergeSort(array.slice(0, middle), comparator), mergeSort(array.slice(middle, array.length), comparator), comparator);
		}

		
		private function merge(a : Array, b : Array, comparator : Function) : Array {
			var auxilary : Array = new Array();
			var aLength : int = a.length;
			var bLength : int = b.length;
			var aLeft : int = 0;
			var bLeft : int = 0;
			var max : int = aLength + bLength;
			for(var i : int = 0;i < max; ++i) {
				if(aLeft >= aLength ) {
					auxilary[i] = b[bLeft++];
					continue;	
				}
				if(bLeft >= bLength ) {
					auxilary[i] = a[aLeft++];
					continue;	
				}
				auxilary[i] = ( comparator(a[aLeft], b[bLeft]) == SortOrder.LESS ) ? a[aLeft++] : b[bLeft++];
			}
			return auxilary;
		}

		
		private function doMergeSort(comparator : Function) : void {
			collection = mergeSort(collection, comparator);
		}

		
		private function selectionSort(comparator : Function) : void {
			var theSize : int = getListSize();
			var minimum : int;
			//get the minimum of the rest of the array and exchange with the current iteration
			for(var i : int = 0;i < (theSize - 1);++i) {
				minimum = i;
				for(var j : int = (i + 1);j < theSize;++j) {
					if(comparator(collection[j], collection[minimum]) == SortOrder.LESS) {
						minimum = j;
					}
				}	
				exchange(minimum, i);
			}
		}

		
		/**
		 * The insertion sort algorithm.
		 * Compare this with the way people sort a hand of cards: sort to the left, keeping the left side sorted and then pick the next card from the right portion of the hand of cards, and insert it into the right position on the left side. 
		 * time proportional to O(n^2) except for nearly sorted data, which sorts in time proportional to O(n), which is fast.
		 * This has been benchmarked against the native sort of Array and on nearly sorted data this is much faster when using insertion sort.
		 * The moral of the story: use insertion sort for nearly sorted data.
		 */
		private function insertionSort(comparator : Function) : void {
			/**
			 * to optimize, we could do a single pass through the array and set the smallest value as the first value.
			 * then do the sorting, so we don't have to use the extra check for j>0 in the inner loop (which is where the speed gain is) by starting at index 1 instead of 0
			 */
			var value : *;
			var j : int;
			//start at 1, as we go back in the inner loop
			for(var i : int = 1;i < listSize;++i) {
				j = i;
				value = collection[i];
				while(j > 0 && comparator(value, collection[(j - 1)]) == SortOrder.LESS) {
					collection[j] = collection[(j - 1)];
					--j;
				}	
				collection[j] = value;
			}
		}

		/**
		 * variation on the insertionsort algorithm.
		 * this was invented as early as 1946, but I 'reinvented' it again without prior knowledge on 2008-10-13 while sleeping :).
		 * I could have gone down in history, but alas...
		 * this version will be faster when comparing is expensive, as the binary search finds the target faster than the normal version.
		 */
		private function binaryInsertionSort(comparator : Function) : void {
			//trace("ArrayList.binaryInsertionSort(comparator)");
			if(listSize <= 1) {
				return;	
			}
			var value : *;
			var right : int;
			var left : int;
			var middle : int;
 
 			//for the list items
			for(var i : int = 1;i < listSize;++i) {
			//z,e,g,y  => e,g,z,y
				right = i;
				left = 0;
				//do binary search to find the position to insert. binary search lets us make less comparisons to find out where the datum should go.
				while (right >= left) {
					middle = (left + right) >> 1;
					trace("i: " + i + ", m: " + middle + ", l: " + left + ", r: " + right + ", c: " + collection.toString());
//					i: 1, m: 0, l: 0, r: 1, c: z,e,g,y
//					e < z => right = 0 - 1 => break => swap => next step 
//					i: 2, m: 1, l: 0, r: 2, c: e,z,g,y
//					2,1(g,z) => right = middle - 1 => r = 0 => continue (g < z, so continue)
//					i: 2, m: 0, l: 0, r: 0, c: e,z,g,y
//					//ok, middle is o, but should be 1
//					i: 3, m: 1, l: 0, r: 3, c: g,e,z,y
//					i: 3, m: 2, l: 2, r: 3, c: g,e,z,y

					//TODO, we need to get the middle point exactly, where do we have to insert the value????
					if (comparator(collection[i], collection[middle]) == SortOrder.LESS) {
						right = middle - 1;
					}else if(comparator(collection[i], collection[middle]) == SortOrder.LARGER) {
						left = middle + 1;
					}else{
						//found a match, we can insert, but lose the 'stableness' of the sort.
						break;	
					}
				}
//				if(middle < i) {
				if(true){
					//insertion point found.
					//move everything to the right
					value = collection[i];
					for(var j : int = i;j > middle;--j) {
						collection[j] = collection[j - 1]	;
					}
					//and insert the value
					collection[middle + 1] = value;
				}
			}
		}

		
		
		/**
		 * bubble sort is the worst sorting algorithm out there, do not use, ever
		 */
		private function bubbleSort(comparator : Function) : void {
			var theSize : int = getListSize();
			//go backward through the array, swapping elements that are not sorted
			for(var i : int = 0;i < theSize;++i) {
				for(var j : int = (theSize - 1);j > i;--j) {
					compareAndExchange(comparator, j, (j - 1));
				}	
			}
		}

		
		private function compareAndExchange(comparator : Function, changeWhenLess : int, changeWhenMore : int) : void {
			if(comparator(collection[changeWhenLess], collection[changeWhenMore]) == SortOrder.LESS) {
				exchange(changeWhenLess, changeWhenMore);
			}
		}

		
		/**
		 * this could be an array utils thinggie.
		 */
		private function exchange(a : int, b : int) : void {
			var tmp : * = collection[a];
			collection[a] = collection[b];
			collection[b] = tmp;
		}
	}
}
