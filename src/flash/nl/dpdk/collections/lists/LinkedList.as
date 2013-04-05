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
	import nl.dpdk.collections.core.ICollection;	import nl.dpdk.collections.core.IMapper;	import nl.dpdk.collections.iteration.IIterator;	import nl.dpdk.collections.iteration.IIteratorExtended;	import nl.dpdk.collections.lists.LinkedListIterator;	import nl.dpdk.collections.lists.List;	import nl.dpdk.collections.sorting.SortOrder;	import nl.dpdk.collections.sorting.SortTypes;	import nl.dpdk.specifications.ISpecification;		/**
	 * The LinkedList class is a double linked list implementation.
	 * It's main purpose is to be a robust and functional class. 
	 * It is not optimized to have a small footprint.
	 * Clarity of code goes over speed of access and memory, as accessors are provided and the class is fully encapsulated.
	 * <p>
	 * It encapsulates the implementation totally, so it's not possible to reference the nodes outside of this class.
	 * Therefore also not to be used as a multilist.
	 * <p>
	 * The array implementation of this class is ArrayList.
	 * Be sure to know the differences between the two (in terms of performance and memory) when implementing either one of them.
	 * <p>
	 * This class can be subclassed to provide alternate behaviour (for perhaps an iterator)
	 * <p>
	 * It can serve as a variety of abstract data types that can be represented by a linked list such as:
	 * <ul>
	 * <li>A normal List (List type)</li>
	 * <li>A queue (IQueue interface)</li>
	 * <li>A Stack (IStack interface)</li>
	 * <li>A Deque (IDeque interface). Double ended queue, a replacement for the traditionalist stack and queue data types</li>
	 * <li>A linked list, with all the functionality of it's implemented interfaces</li>
	 * </ul>
	 * <p>
	 * <p>
	 * It implements various interfaces and can thus be used in different contexts.
	 * <p>
	 * for example:
	 * <ul>
	 * <li>make it a queue implementation
	 * <code>
	 * var queue: IQueue = new LinkedList();
	 * queue.enqueue(data);</code>
	 * </li>
	 * <li>make it a stack implementation
	 * <code>
	 * var stack: IStack = new LinkedList();
	 * stack.push(data);</code>
	 * </li>
	 * <li>make it a deque implementation
	 * <code>
	 * var deque: IDeque = new LinkedList();
	 * deque.addFirst(data);</code>
	 * </li>
	 *  <li>make it a List implementation
	 * <code>
	 * var list: List = new LinkedList();
	 * list.add(data);</code>
	 * </li>
	 * </ul>
	 * <p><p>
	 * The List type (and therefore also linked list) can be used for all this functionality, but also has sorting, mapping, folding, applying and selecting as <em>major</em> features.
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class LinkedList extends List {
		/**
		 * the sentinel is an easy reference node to make manipulation of the list easier.
		 * It makes the use of head and tail nodes obsolete as it <em>is</em> the head and the tail node.
		 */
		protected  var sentinel : LinkedListNode;


		/**
		 * The constructor can take a ICollection instance to create a default list from another ICollection.
		 * @param collection an already existing instance of ICollection
		 */
		public function LinkedList(collection : ICollection = null) {
			setup();		
			addCollection(collection);
		}





		/**
		 * @inheritDoc
		 */		public override function map(mapper : IMapper) : List {
			var iterator : IIterator = iterator();
			var list : List = new LinkedList();
			while(iterator.hasNext()) {
				list.add(mapper.map(iterator.next()));
			}
			return list;
		}

		
		private function setup() : void {
			sentinel = new LinkedListNode();
			sentinel.next = sentinel.previous = sentinel;
		}



		
		/**
		 * Appends the specified element to the end of this list
		 * adds data to the list in an appending way: at the end of the list
		 * As this method is on ICollection and this class implements both IQueue and IStack, add is actually the same behaviour as push() and enqueue()
		 * @param data any type of data we wish to put in the list (make  sure it is the same datatype throughout the list)
		 * @return void
		 */
		public override function add(data : *) : void {
			var node : LinkedListNode = new LinkedListNode(data);
			insertNode(node, sentinel);
		}

		
		/**
		 * @inheritDoc
		 */		public override function clear() : void {
			//clear the references to the list. nodes cannot be reached and will be garbage collected
			sentinel.next = sentinel.previous = sentinel;
			listSize = 0;
		}

		
		/**
		 * @inheritDoc
		 */		public override function contains(data : *) : Boolean {
			var node : LinkedListNode = sentinel;
			while(node.next != sentinel) {
				node = node.next;
				if(node.data == data) {
					return true;
				}	
			}
			return false;
		}



		
		/**
		 * remove a certain data item from this list, the first encountered.
		 * Use in a loop if there are multiple occurences of the data: while(list.remove(data));
		 * This method does a lineair pass through the list. If a client is working with an iterator and holds a reference to the data, remove the data with the iterator, which is faster (direct access to  the data item via the iterator)
		 * @param data any type of data we want to remove
		 * @return true if data was found (and removed), else false
		 */
		public override function remove(data : *) : Boolean {
			var node : LinkedListNode = sentinel;
			while(node.next != sentinel) {
				node = node.next;
				if(node.data == data) {
					node.next.previous = node.previous;
					node.previous.next = node.next;
					node.data = null;
					--listSize;
					return true;	
				}
			}
			return false;
		}

		
		/**
		 * TRICKY: an expensive operation for a linked list, which has to scan the list sequentially
		 * @inheritDoc
		 */
		public override function removeAt(i : int) : Boolean {
			if(i >= listSize || i < 0 || listSize == 0) return false;
			var node : LinkedListNode = getNodeAt(i);
			return removeNode(node);
		}

		
		/**
		 * helper method to remove a certain node
		 * @param node the node to remove
		 * 
		 */
		private function removeNode(node : LinkedListNode) : Boolean {
			if(node == sentinel) return false;
			
			node.next.previous = node.previous;
			node.previous.next = node.next;
			node.data = null;
			node.next = null;
			node.previous = null;
			--listSize;
			return true;
		}

		
		/**
		 * inserts an item in the list at position. the item is added if input of i is invalid.
		 * for the linked list makes a serial pass through the list, which is slower than the array based implementation for lookup, but faster for insertion itself.
		 * @inheritDoc
		 */
		public override function insertAt(i : int, data : *) : void {
			if(i < 0 || i >= listSize || listSize == 0  ) {
				add(data);
				return;
			}
			var newNode : LinkedListNode = new LinkedListNode(data);
			var node : LinkedListNode = sentinel;
			var count : int = 0;
			
			while(node.next != sentinel) {
				node = node.next;
				if(count == i) {
					insertNode(newNode, node);
					return;
				}
				++count;
			}
		}

		
		/**
		 * helper method to insert a new node
		 * @param newNode the new Node to insert
		 * @param node the node before which to insert the new node
		 * 
		 */
		protected function insertNode(newNode : LinkedListNode, node : LinkedListNode) : void {
			node.previous.next = newNode;
			newNode.previous = node.previous;
			newNode.next = node;
			node.previous = newNode;
			++listSize;	
		}


		
		/**
		 * @inheritDoc
		 */
		public override function toArray() : Array {
			var array : Array = new Array();
			var node : LinkedListNode = sentinel;
			while(node.next != sentinel) {
				node = node.next;
				array.push(node.data);	
			}
			return array;
		}

		/**
		 * @inheritDoc
		 */
		public override function toString() : String {
			return "LinkedList of size " + size();
		}

		
		/**
		 * @inheritDoc
		 */
		public override function iterator() : IIterator {
			return new LinkedListIterator(this, sentinel, increaseListSize, decreaseListSize);
		}

		/**
		 * helper method for the iterator
		 */		private function decreaseListSize() : void {
			--listSize;
		}

		/**
		 * helper method for the iterator
		 */		private function increaseListSize() : void {
			++listSize;
		}

		
		/**
		 * @inheritDoc
		 */
		public override function iteratorExtended() : IIteratorExtended {
			return new LinkedListIterator(this, sentinel, increaseListSize, decreaseListSize);
		}

		/**
		 * @inheritDoc
		 */
		public override function addFirst(data : *) : void {
			var node : LinkedListNode = new LinkedListNode(data);
			insertAfter(sentinel, node);
		}

		
		/**
		 * @inheritDoc
		 */
		public override function getFirst() : * {
			return sentinel.next.data;
		}

		


		
		/**
		 * @inheritDoc
		 */
		public override function getLast() : * {
			return sentinel.previous.data;
		}

		/**
		 * @inheritDoc
		 */
		public override function removeFirst() : * {
			var node : LinkedListNode = sentinel.next;
			if(node != sentinel) {
				
				sentinel.next = node.next;
				sentinel.next.previous = sentinel;
				--listSize;
				return node.data;
			}	
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public override function removeLast() : * {
			var node : LinkedListNode = sentinel.previous;
			if(node != sentinel) {
				
				sentinel.previous = node.previous;
				sentinel.previous.next = sentinel;
				--listSize;
				return node.data;
			}	
			return null;
		}



		
		/**
		 * @inheritDoc
		 */
		public override function enqueue(data : *) : void {
			var node : LinkedListNode = new LinkedListNode(data);
			insertNode(node, sentinel);
			//add(data);
		}

		
		/**
		 * @inheritDoc
		 */
		public override function dequeue() : * {
			var node : LinkedListNode = sentinel.next;
			if(node != sentinel) {
				
				sentinel.next = node.next;
				sentinel.next.previous = sentinel;
				--listSize;
				return node.data;
			}	
			return null;
			
			//return removeFirst();
		}

		
		/**
		 * @inheritDoc
		 */
		public override function pop() : * {
			var node : LinkedListNode = sentinel.previous;
			if(node != sentinel) {
				
				sentinel.previous = node.previous;
				sentinel.previous.next = sentinel;
				--listSize;
				return node.data;
			}	
			return null;
			//return removeLast();
		}

		/**
		 * @inheritDoc
		 */
		public override function push(data : *) : void {
			var node : LinkedListNode = new LinkedListNode(data);
			insertNode(node, sentinel);
			//addLast(data);
		}

		
		/**
		 * get a data item at a certain (0 based) position.
		 * This is a slow operation on a LinkedList. it's better to use the ArrayList instead.
		 * @inheritDoc
		 */
		public override function get(i : int) : * {
			if(i >= size() || i < 0) return null;
			return getNodeAt(i).data;
		}

		
		/**
		 * get a Node at a certain (0 based) position.
		 * @param i the place at which we want to get the data item.
		 * @return the Node if found, or sentinel Node if not found or if the input is bogus (out of bounds, negative).
		 */
		private function getNodeAt(i : int) : LinkedListNode {
			var count : int = 0;
			var node : LinkedListNode = sentinel;

			//check what the shortest traversal path is, forward to the node or backward to the node, by getting the middle point
			if((listSize / 2) >= i ) {
				//first half
				while(node.next != sentinel) {
					node = node.next;	
					if(count == i) {
						return node;
					}
					++count;
				}
			}else {
				//last half
				count = listSize - 1;
				while(node.previous != sentinel) {
					node = node.previous;	
					if(count == i) {
						return node;
					}
					--count;
				}
			}
			
			//failed
			return sentinel;
		}

		
		/**
		 * The default behaviour is to add to the list if the position is as yet undefined on the list (out of bounds, negative or empty list)
		 * <p>
		 * TRICKY: this is a slow operation for a linked list, as a linked list does not have easy O(1) [constant time] access to the i-th element.
		 * It has to search the whole list (actually half the list) sequentially until the index is reached. this is done from the beginning or end, depending on where i is compared to the size.
		 * @inheritDoc
		 */
		public override function set(i : int, data : *) : void {
			if(i < 0 || i >= listSize || listSize == 0) {
				add(data);
				return;	
			}
			getNodeAt(i).data = data;
		}

		
		/**
		 * @inheritDoc
		 */
		public override function indexOf(data : *) : int {
			var index : int = 0;
			var node : LinkedListNode = sentinel;
			while(node.next != sentinel) {
				node = node.next;	
				if(node.data == data) {
					return index;
				}
				++index;
			}
			
			return -1;
		}

		
		/**
		 * @inheritDoc
		 */
		public override function lastIndexOf(data : *) : int {
			var index : int = listSize - 1;
			var node : LinkedListNode = sentinel;
			while(node.previous != sentinel) {
				node = node.previous;	
				if(node.data == data) {
					return index;
				}
				--index;
			}
			return -1;
		}

		
//		/**
//		 * @inheritDoc
//		 */
//		public override function addAll( collection : ICollection) : void {
//			var newNode : Node;
//			var node : Node = sentinel;
//			
//			var iterator : IIterator = collection.iterator();
//			while(iterator.hasNext()) {
//				insertBefore(node, newNode = new Node(iterator.next()));
//			}
//		}

		
		/**
		 * inserts a node after another node in this list.
		 * an internal helper method.
		 */
		private function insertAfter(currentNode : LinkedListNode, newNode : LinkedListNode) : void {
			//trace("LinkedList.insertAfter("+currentNode.data +","+ newNode.data+")");
			currentNode.next.previous = newNode;
			newNode.next = currentNode.next;
			currentNode.next = newNode;
			newNode.previous = currentNode;
			++listSize;
		}

		
		/**
		 * inserts a node after another node in this list.
		 * an internal helper method.
		 */
		private function insertBefore(currentNode : LinkedListNode, newNode : LinkedListNode) : void {
			//trace("LinkedList.insertBefore("+currentNode.data +","+ newNode.data+")");
			currentNode.previous.next = newNode;
			newNode.next = currentNode;
			newNode.previous = currentNode.previous;
			currentNode.previous = newNode;
			++listSize;
		}

		
		/**
		 * @inheritDoc
		 */
		public override function subList(from : int, to : int) : List {
			var list : LinkedList = new LinkedList();
			if(from < 0 || from >= listSize || listSize == 0 || to <= from ) {
				//empty list
				return list;	
			}
			var total : int = to - from;
			var count : int = 0;
			var node : LinkedListNode = getNodeAt(from);
			//it is more likely that a client provides valid input than that we reach the end. keep the check in the loop tight by putting count first
			while(count != total && node != sentinel) {
				++count;
				list.add(node.data);
				node = node.next;
			}
			return list;
		}

		
		/**
		 * @inheritDoc
		 */
		public override function reverse() : void {
			if(size() == 0 || size() == 1) return;

			//stores a reference to hold during the reversal process
			var forward : LinkedListNode = sentinel;
			var reversing : LinkedListNode = sentinel;
			
			//meet in the middle, check for odd and even list size
			while(forward.next != reversing && forward.next != reversing.previous) {
				forward = forward.next;
				reversing = reversing.previous;
				exchange(forward, reversing);
			}
		}

		
		/**
		 * performs a sort on the current list and returns the sorted list.
		 * Check the notes on the Comparator class for implementations of Comparators on stable sort types.
		 * <p>
		 * implemented sort types (READ THE NOTES in the SortType class) are:
		 * <ul>
		 * <li>bubble: do not use</li>
		 * <li>selection</li>
		 * <li>insertion: fast on nearly sorted lists</li>
		 * <li>merge: the default sort type for linked lists.</li>
		 * </ul>
		 * <p>
		 * Some sort types are not (easily) implemented for linked lists and are not implemented here:
		 * <ul>
		 * <li>shell</li>
		 * <li>quick</li>
		 * </ul>
		 * @param comparator a comparator function. basic comparators can be found in the Comparators class.  when not implemented correctly, runtime errors <em>will</em> occur. duh!
		 * @param sortType the sort types to be used can be found in the SortTypes class. Default is merge sort. Use insertion sort on a nearly sorted list or to sort a sorted list after adding new data.
		 * @return void
		 * @see SortTypes
		 * @see Comparators
		 */
		public override function sort(comparator : Function, sortType : int = 6 ) : void {
			switch(sortType) {
				case SortTypes.SELECTION:
					selectionSort(comparator);
					break;
				
				case SortTypes.BUBBLE:
					bubbleSort(comparator);
					break;
				
				case SortTypes.INSERTION:
					insertionSort(comparator);
					break;
				
				case SortTypes.MERGE:
				//fall through to default
				default:
					mergeSort(comparator);
					break;
			}
		}

		
		/**
		 * insertion sort is very effective for nearly sorted lists
		 */
		protected function insertionSort(comparator : Function) : void {
			//start at second element
			var node : LinkedListNode = sentinel.next.next;
			//list of 0 or 1
			if(node == sentinel) return;
			
			var searchingNode : LinkedListNode;
			var comparingNode : LinkedListNode;
			var tmp : *;
			//for all the nodes
			while(node != sentinel) {
				//when starting this is node 1
				searchingNode = node;
				comparingNode = searchingNode.previous;
				
				while(comparingNode != sentinel && comparator(searchingNode.data, comparingNode.data) == SortOrder.LESS) {
					//the next three lines are inlined
					tmp = searchingNode.data;
					searchingNode.data = comparingNode.data;
					comparingNode.data = tmp;
					//this is the same as the previous three lines
					//exchange(searchingNode, comparingNode);
					searchingNode = searchingNode.previous;
					comparingNode = searchingNode.previous;
				}
				node = node.next;
			}
		}

		
		/**
		 * override the diverse sort methods in the testsuite to get counts of comparisons
		 * bubble sort is the worst sorting algorithm out there, do not use
		 */
		protected function bubbleSort(comparator : Function) : void {
			var node : LinkedListNode = sentinel;
			var reversingNode : LinkedListNode;
			while(node.next != sentinel) {
				node = node.next;
				reversingNode = sentinel;
				while(reversingNode.previous != node) {
					reversingNode = reversingNode.previous;
					compareAndExchange(comparator, reversingNode, reversingNode.previous);		
				}
			}
		}

		
		/**
		 * a priority queue sorting algorithm (together with heap sorting).
		 * bad performer
		 */
		protected function selectionSort(comparator : Function) : void {
			var node : LinkedListNode = sentinel;
			var minimumNode : LinkedListNode;
			var searchingNode : LinkedListNode;
			
			//while the end is not reachted
			while(node.next != sentinel) {
				minimumNode = node = node.next;
				searchingNode = node.next;
				//select the smallest element in the whole list
				while(searchingNode != sentinel) {
					if(comparator(searchingNode.data, minimumNode.data) == SortOrder.LESS) {
						//set the new node containing the minimum value
						minimumNode = searchingNode;
					}
					//update the searching node
					searchingNode = searchingNode.next;
				}
				//the smallest has been found, now exchange
				exchange(minimumNode, node);
			}
		}

		
		/**
		 * our preferred sorting method of choice for list based sorting, as it performs with O(N Log N) in all cases.
		 * some methods can outperform linked sorts in certain circumstances, but have worst case behaviour of O(N^2)
		 * This method is actually not as fast as I'd like, the recursive methods are too costly, too much creation of helper nodes etc.
		 * I should refactor this to a non recursive implementation instead.
		 * But, it is still fast :)
		 */
		private function mergeSort(comparator : Function) : void {
			
			if(size() <= 1) {
				return;
			}
			 
			//remove the sentinel from the end
			sentinel.previous.next = null;
			sentinel.previous = null;
			 
			/**
			 * recursively do this. at the end, reconnect the sentinel to the beginning and the end.
			 * this is a case where the sentinel does not serve us well, as we need to reinstall it at the end, which makes us traverse the entire list one time extra.
			 */
			var head : LinkedListNode = doMergeSort(sentinel.next, comparator);
			
			//now prepend the sentinel
			sentinel.next = head;
			head.previous = sentinel;
			//search the last item
			while(head.next != null) {
				head = head.next;	
			}
			//append the sentinel to complete the circle
			head.next = sentinel;
			sentinel.previous = head;
		}

		
		private function doMergeSort(node : LinkedListNode, comparator : Function) : LinkedListNode {
			if(node.next == null) return node;
			//reference to left node
			var left : LinkedListNode = node;
			//the right splitting node
			var right : LinkedListNode = node.next;
			while(right != null && right.next != null) {
				node = node.next;
				//go forward twice as fast to reach the end
				right = right.next.next;	
			}
			//now get the middle node
			right = node.next;
			right.previous.next = null;
			right.previous = null;
			
			//this is the recursive mofo.
			return merge(doMergeSort(left, comparator), doMergeSort(right, comparator), comparator);
		}

		
		/**
		 * helper method for merge sort
		 */
		private function merge(left : LinkedListNode, right : LinkedListNode, comparator : Function) : LinkedListNode {
			var tmp : LinkedListNode = new LinkedListNode();
			var head : LinkedListNode = tmp;
			while(left != null && right != null) {
				if(comparator(left.data, right.data) == SortOrder.LESS) {
					//merge nodes, update links and go to next
					tmp.next = left;
					left.previous = tmp;
					tmp = left;
					left = left.next;
				}else {
					//swap left and right nodes an go to next
					tmp.next = right;
					right.previous = tmp;
					tmp = right;
					right = right.next;	
				}
			}
			tmp.next = (left == null) ? right : left;
			tmp.next.previous = tmp;

			return head.next;
		}

		
		/**
		 * compares two nodes with the comparator function and exchanges the data
		 */
		protected final function compareAndExchange(comparator : Function, shouldBeLess : LinkedListNode, shouldBeMore : LinkedListNode) : void {
			if(comparator(shouldBeLess.data, shouldBeMore.data) == SortOrder.LESS) {
				exchange(shouldBeLess, shouldBeMore);
			}
		}

		
		/**
		 * exchanges the data of two nodes
		 */
		protected final function exchange(tango : LinkedListNode, cash : LinkedListNode) : void {
			var temp : * = tango.data;
			tango.data = cash.data;
			cash.data = temp;	
		}

		
		/**
		 * @inheritDoc
		 */
		public override function selectBy(specification : ISpecification) : List {
			var list : LinkedList = new LinkedList();
			var node : LinkedListNode = sentinel;
			while(node.next != sentinel) {
				node = node.next;
				if(specification.isSatisfiedBy(node.data)) {
					list.add(node.data);	
				}	
			}
			return list;	
		}
	}
}



