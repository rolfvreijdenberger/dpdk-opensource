package nl.dpdk.collections.lists {	import nl.dpdk.collections.iteration.IIteratorExtended;
	/**	 * iterator implementation for this class.	 * must have access to some fields of list	 */	public class LinkedListIterator implements IIteratorExtended {		private var current : LinkedListNode;		private var sentinel : LinkedListNode;		private var theList : LinkedList;		private var increaseListSize : Function;		private var decreaseListSize : Function;
		/**		 * ugly constructor to keep sentinel and listsize encapsulated for a client, but still usable by the internal class		 * therefore we need two methods to get and set size. I have not yet found an alternative way of implementing this.		 */		public function LinkedListIterator(list : LinkedList, sentinel : LinkedListNode, increaseListSize : Function, decreaseListSize : Function) {			this.increaseListSize = increaseListSize;			this.decreaseListSize = decreaseListSize;			this.theList = list;			this.sentinel = sentinel;			begin();		}
		
		public function set(data : *) : Boolean {			if(current != sentinel) {				current.data = data;				return true;				}			return false;		}
		
		public function hasNext() : Boolean {			return current.next != sentinel;		}
		
		public function next() : * {			//we treat this as a circular list			current = current.next;			if(current == sentinel) {				current = sentinel.next;			}			return current.data;		}
		
		public function remove() : Boolean {			if(current == sentinel) return false;			//it would be great if we could refactor this to just call a method on LinkedList itself			current.previous.next = current.next;			current.next.previous = current.previous;			current.data = null;			current = current.previous;			decreaseListSize();			return true;		}
		
		public function begin() : void {			current = sentinel;		}
		
		public function end() : void {			current = sentinel;		}
		
		public function insert(data : *) : void {			if(current == sentinel) {				theList.add(data);				return;			}			//it would be great if we could refactor this to just call a method on LinkedList itself, but the protected node methods are not accessible here			var node : LinkedListNode = new LinkedListNode(data);			current.previous.next = node;			node.previous = current.previous;			node.next = current;			current.previous = node;			increaseListSize();			}
		
		public function hasPrevious() : Boolean {			//this actually makes it possible to directly start at the end			return current.previous != sentinel;		}
		
		public function previous() : * {			//we treat this as a circular list			current = current.previous;			if(current == sentinel) {				current = sentinel.previous;			}			return current.data;		}	}}