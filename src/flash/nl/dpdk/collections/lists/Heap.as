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
	import nl.dpdk.collections.core.IPriorityQueue;
	import nl.dpdk.collections.iteration.ArrayIterator;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.iteration.UnmodifiableIterator;
	import nl.dpdk.collections.sorting.SortOrder;	

	/**
	 * A Heap is a complete binary tree with values stored in its nodes so that no child has a value greated than the value of it's parent (heap ordered).
	 * This is the contiguous sequential representation with an array as the heap.
	 * <p><p>
	 * A seperate class might be useful in the case of 'removing a random item' or in the case of 'reprioritizing an item'.
	 * This would need some seperate methods on the interface. For a normal Heap there is no need for these methods.
	 * <p> 
	 * OrderedList is also useful for quickly removing a random item in a sorted structure (IPriorityQueue), as it uses a binary search for this.
	 * <p>
	 * PriorityQueue is a 'real' IPriorityQueue implementation as it allows for more behaviour. Speed, ease of use and space are the tradeoff for this however.
	 * @see OrderedList
	 * @see PriorityQueue
	 * @see IPriorityQueue
	 * @author Rolf Vreijdenberger
	 */
	public class Heap implements ICollection, IPriorityQueue 
	{
		/**
		 * the array that contains the heap ordered binary tree
		 */
		protected var collection : Array;
		protected var comparator : Function;

		/**
		 * The constructor
		 * @param comparator the comparator is the method that is used for keeping the heap sorted.
		 * @param collection an ICollection that can be passed to fill the heap. This will use heapsort which will take time O(n).
		 * @see Comparators
		 */
		public function Heap(comparator : Function, collection : ICollection = null)
		{
			this.collection = new Array(1);
			setComparator(comparator);
			addCollection(collection);
		}

		
		/**
		 * the swim method (or walkup) is a helper method to sort a value in the heap when it is inserted at the end of the heap.
		 */
		protected function swim(i : int) : void
		{
			var up : int;
			//while not at the root
			while(i > 1 )
			{
				//divide by 2 ( Math.floor(i*2) ) to get the parent
				up = i >> 1;
				//check if we need to exchange
				if(comparator(collection[up], collection[i]) == SortOrder.LESS)
				{
					exchange(i, up);
					i = up;
					continue;
				}else
				{
					//no need, we are done
					break;
				}
			}
		}

		
		/**
		 * exchanges two values in an arry
		 */
		protected function exchange(a : int, b : int) : void 
		{
			var tmp : * = collection[a];
			collection[a] = collection[b];
			collection[b] = tmp;
		}

		
		/**
		 * sink (or crawldown) is a helper method that puts an element in position after a removal has taken place.
		 */
		protected function sink(i : int) : void
		{
			var max : int = size();
			var down : int;
			/**
			 * multiply by 2 and check if we are in bounds.
			 * this gives us the left child of the binary tree node.
			 */
			while((down = (i << 1)) <= max )
			{
				//get the largest child by comparing the left and right node
				if(down < max && comparator(collection[down], collection[down + 1]) == SortOrder.LESS)
				{
					//right is the larger child, so increase the index to get the right child
					++down;	
				}
				//we now have the largest child, check if we need to do an exchange.
				if(comparator(collection[i], collection[down]) == SortOrder.LESS)
				{
					//the parent is smaller, which means we have to do an exchange.
					exchange(i, down);
					i = down;	
				}else
				{
					//we are done, leave the loop
					break;	
				}
			}
		}

		
		/**
		 * helper method for the construction proces.
		 */
		private function addCollection(collection : ICollection) : void
		{
			if(collection)
			{
				var iterator : IIterator = collection.iterator();
				while(iterator.hasNext())
				{
					//
					/**
					 * instead of creating the heap by adding elements succesively (as in: add(iterator.next());),
					 * we first create an array that is unordered and then heapify it at once, which is much faster.
					 */
					this.collection.push(iterator.next());
				}	
				heapify();
			}
		}

		
		/**
		 * adds data to the heap.
		 * @param data the data to insert in the heap. it has to be able to be compared by the comparator method and therefore needs to be of one datatype only.
		 */
		public function add(data : *) : void
		{
			//add to the end of the heap, and swim upwards to get to the right sorted position.
			swim((collection.push(data) - 1));
		}

		
		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			collection = new Array(1);
		}

		
		/**
		 * @inheritDoc
		 */
		public function contains(data : *) : Boolean
		{
			for(var i : int = 1;i < collection.length;++i)
			{
				if(collection[i] == data)
				{
					return true;	
				}	
			}
			return false;
		}

		
		/**
		 * @inheritDoc
		 */
		public function isEmpty() : Boolean
		{
			return size() <= 0;
		}

		
		/**
		 * @inheritDoc
		 */
		public function getMaximum() : *
		{
			return collection[1];
		}

		
		/**
		 * @inheritDoc
		 */
		public function removeMaximum() : *
		{
			return removeAt(1);
		}

		
		/**
		 * removes a value at the specified index, and heapifies the heap again.
		 */
		protected function removeAt(i : int) : *
		{
			var data : * = collection[i];
			if(data == null)
			{
				
				return null;
			}
			if(size() > 1)
			{
				collection[i] = collection.pop();
				sink(i);
				return data;
			}
			return collection.pop();
		}

		
		/**
		 * removes data from the heap.
		 * Does a lineair search and then reheapifies the heap.
		 * To make removal run faster, we would need an object handler on our interface that could instantly O(1) look up the index of the data.
		 * This might be done in a seperate PriorityQueue class, but in practice this would mean keeping a seperate datastructure for fast lookup of indexes (a Dictionary).
		 * Currently, we are only interested in using the Heap as a means to only select the maximum and have no need for random removal.
		 * @inheritDoc
		 */
		public function remove(data : *) : Boolean
		{
			var length : int = collection.length;
			for(var i : int = 1;i < length;++i)
			{
				if(collection[i] == data)
				{
					removeAt(i);
					return true;	
				}
			}
			return false;
		}

		
		/**
		 * make the Heap a heap :)
		 * This might be useful if we want to sort the heap again when the client knows a priority in the heap has changed.
		 * There are more efficient ways of doing so, but this would require an alternate interface for a PriorityQueue.
		 */
		public function heapify() : void
		{
			/**
			 * for the internal nodes of the heap in reverse level order: sink the suckers.
			 * the last internal node is the parent of the last leaf (in a commplete binary tree).
			 * The last leaf is the last element in the array.
			 * It's parent can be found by dividing the index by 2.
			 * The algorithm here is actually part of the heapsort algorithm.
			 */
			for(var i : int = size() >> 1;i >= 1;--i)
			{
				sink(i);	
			}
		}

		
		/**
		 * @inheritDoc
		 */
		public function size() : int
		{
			return collection.length - 1;
		}

		
		/**
		 * @inheritDoc
		 */
		public function toArray() : Array
		{
			return collection.slice(1);
		}

		
		/**
		 * @inheritDoc
		 */
		public function toString() : String
		{
			return "Heap of size " + size();
		}

		
		/**
		 * returns an unmodifiable iterator, as the heap should not be altered through the iterator.
		 * If the heap could be altered via the iterator, we would have to call heapify().
		 * this might be a nice to have, so think about it.
		 */
		public function iterator() : IIterator
		{
			return new UnmodifiableIterator(new ArrayIterator(toArray()));
		}

		
		/**
		 * setting a new comparator also reheapifies the Heap.
		 * @param comparator the comparator method to use to keep the Heap in order.
		 */
		public function setComparator(comparator : Function) : void
		{
			if(this.comparator === comparator)
			{
				return;
			}
			this.comparator = comparator;
			heapify();
		}
	}
}
