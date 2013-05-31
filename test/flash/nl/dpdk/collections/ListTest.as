package nl.dpdk.collections {
	import nl.dpdk.collections.core.IApplyer;
	import nl.dpdk.collections.core.IDeque;	import nl.dpdk.collections.core.IFolder;	import nl.dpdk.collections.core.IMapper;	import nl.dpdk.collections.core.IQueue;	import nl.dpdk.collections.core.IStack;	import nl.dpdk.collections.iteration.IIterator;	import nl.dpdk.collections.iteration.IIteratorExtended;	import nl.dpdk.collections.lists.ArrayList;	import nl.dpdk.collections.lists.LinkedList;	import nl.dpdk.collections.lists.List;	import nl.dpdk.collections.sorting.SortOrder;	import nl.dpdk.collections.sorting.SortTypes;	import nl.dpdk.commands.ICommand;	import nl.dpdk.debug.RunTimer;	import nl.dpdk.specifications.BooleanSpecification;	
	/**
	 * test class for the list abstract data type
	 * for concrete implementations, the setup method is overriden to create the right list type (array or linked)
	 * this is a non exhaustive test (as is any test), but most functionality has been tested here..
	 * @author Rolf Vreijdenberger
	 */
	public class ListTest extends CollectionTest {
		//override
		protected var instance : List;
		protected var checkSortedList : String;
		public static const LIST_EMPTY : String = "0 elements";
		public static const LIST_ONE_ELEMENT : String = "one element";
		public static const LIST_SORTED_ELEMENTS : String = "alphabet";
		public static const LIST_ALMOST_SORTED_ELEMENTS : String = "alpabet almost sorted";
		public static const LIST_UNSORTED : String = "alphabet random";
		public static const LIST_LARGE : String = "1000 elements";
		public static const LIST_LARGE_KEYS : String = "500 keys with size of alpabet before randomization takes place";
		public static const LIST_ODD : String = "5 keys";
		public static const LIST_DUPLICATE : String = "duplicate items available";
		public static const LIST_EVEN : String = "4 keys";
		public static const LIST_LARGE_SORTED : String = "1000 keys";

		/**
		 * constructor
		 */
		public function ListTest(testMethod : String = null) {
			super(testMethod);
		}

		
		/**
		 * this method sets up all stuff we need before we run the test
		 */
		protected override function setUp() : void {
			instance = getConcreteList();
		}

		
		/**
		 * factory method
		 * override for the right list
		 */
		protected function getConcreteList() : List {
			return new ArrayList();
		}

		
		/**
		 *	use to remove all stuff not needed after this test
		 */
		//protected override function tearDown() : void {
		//	instance = null;
		//}

		
		/**
		 *	a test implementation
		 */
		public function testInstantiated() : void {
			trace("ListTest.testInstantiated()");
			assertTrue("List instantiated", instance is List);
		}

		
		/**
		 * ICollection
		 */
		public function testContains() : void {
			trace("ListTest.testContains()");
			instance.clear();
			assertFalse(instance.contains("a"));
			instance.add("a");	
			assertTrue(instance.contains("a"));
			assertFalse(instance.contains("b"));
			instance.add("b");	
			assertTrue(instance.contains("a"));
			assertTrue(instance.contains("b"));
		
			instance.clear();	
			assertFalse(instance.contains("a"));
			assertFalse(instance.contains("b"));
			
			
			var a : Object = new Object();
			a.id = 1;
			var b : Object = new Object();
			b.id = 2;
			assertFalse(instance.contains(a));
			assertFalse(instance.contains(b));
			instance.add(a);
			assertTrue(instance.contains(a));
			assertFalse(instance.contains(b));
			instance.add(b);
			assertTrue(instance.contains(a));
			assertTrue(instance.contains(b));
		}

		
		/**
		 * ICollection
		 */
		public function testIsEmpty() : void {
			trace("ListTest.testIsEmpty()");
			instance.clear();
			assertTrue(instance.isEmpty());
			instance.add("a");
			assertFalse(instance.isEmpty());
			instance.clear();
			assertTrue(instance.isEmpty());
			instance.add("a");
			instance.add("a");
			instance.add("a");
			instance.add("a");
			instance.clear();
			assertTrue(instance.isEmpty());
		}

		
		/**
		 * ICollection
		 */
		public function testClear() : void {
			trace("ListTest.testClear()");
			instance.clear();
			assertEquals(instance.size(), 0);
			instance.add('a');
			assertEquals(instance.size(), 1);
			instance.add('a');
			instance.add('a');
			assertEquals(instance.size(), 3);
			instance.clear();
			assertEquals(instance.size(), 0);
			instance.clear();
			assertEquals(instance.size(), 0);
		}
		
		public function testFold():void{
			trace("ListTest.testFold()");
			instance.clear();
			var folder:IFolder = new SquareFolder();
			assertEquals('empty list folded defaults to SquaredFolder\'s init value', 0, instance.fold(folder));
			folder = new SquareFolder();
			instance.add(3);
			instance.add(4);
			assertEquals("3 squared and 4 squared", 25, instance.fold(folder));
			folder = new SquareFolder();
			instance.add(5);
			assertEquals('3,4,5 squared is 50', 50, instance.fold(folder));
		}
		
		public function testMap():void{
			trace("ListTest.testMap()");
			var mapper: IMapper;
			instance.clear();
			mapper = new ConcatMapper('concat_this');
			assertTrue('mapping on empty list returns ampty list', instance.map(mapper).size() == 0);
			instance.add('a');
			instance.add('b');
			assertEquals('concatenated', instance.map(mapper).toArray().toString(),'concat_thisa,concat_thisb');
		}
		
		public function testApply():void{
			trace("ListTest.testApply()");
			instance.clear();
			var action: IApplyer = new DoubleAction();
			instance.apply(action);
			assertEquals(instance.size(), 0);
			instance.add({name: 'a'});
			instance.add({name: 'b'});
			instance.apply(action);
			assertEquals(instance.get(0).name, 'aa');
			assertEquals(instance.get(1).name, 'bb');
			instance.apply(action);
			assertEquals(instance.get(0).name, 'aaaa');
			assertEquals(instance.get(1).name, 'bbbb');		
		}
		
		/**
		 * ICollection
		 */
		public function testSize() : void {
			assertEquals("initial size", instance.size(), 0);
			instance.add("a");	
			assertEquals("after one input", instance.size(), 1);
			instance.clear();
			assertEquals("after clear", instance.size(), 0);	
			instance.add("a");	
			instance.add("a");	
			instance.add("a");	
			instance.add("a");	
			instance.add("a");	
			assertEquals("after multiple additions", instance.size(), 5);	
		
			instance.remove("a");	
			assertEquals("after removal", instance.size(), 4);
			while(instance.remove('a'));	
			assertEquals("remove all", instance.size(), 0);
		}

		
		/**
		 * ICollection
		 */
		public function testAddition() : void {
			trace("ListTest.testAddition()");
			assertEquals(instance.size(), 0);
			instance.add("a");
			instance.add("b");
			instance.add("c");
			assertEquals(instance.size(), 3);
			instance.clear();
			assertEquals(instance.size(), 0);
			instance.add("a");
			instance.add("b");
			instance.add("c");
			assertEquals(instance.size(), 3);
			assertEquals(instance.toArray().toString(), "a,b,c");
			instance.clear();
			assertEquals(instance.size(), 0);
			instance.add("b");
			instance.add("c");
			instance.add("a");
			assertEquals(instance.size(), 3);
			assertEquals(instance.toArray().toString(), "b,c,a");
			instance.remove('c');
			assertEquals(instance.toArray().toString(), "b,a");
			instance.add("b");
			assertEquals(instance.toArray().toString(), "b,a,b");
		}

		
		/**
		 * ICollection
		 */
		public function testRemove() : void {
			trace("ListTest.testRemove()");
			instance.clear();
			instance.add('a');
			assertEquals(instance.size(), 1);
			instance.remove("a");
			assertEquals(instance.size(), 0);
			instance.add('a');
			instance.add('a');
			instance.add('a');
			assertEquals(instance.size(), 3);
			instance.remove("a");
			assertEquals(instance.size(), 2);
			instance.remove("a");
			instance.remove("a");
			assertEquals(instance.size(), 0);
			assertTrue(instance.isEmpty());
			
			var a : Object = new Object();
			a.id = 1;
			var b : Object = new Object();
			b.id = 2;
			var c : Object = new Object();
			c.id = 3;
			
			instance.add(b);
			instance.add(a);
			assertEquals(instance.size(), 2);
			assertFalse(instance.isEmpty());
			assertTrue(instance.contains(a));
			assertTrue(instance.contains(b));
			assertFalse(instance.contains(c));
			
			assertFalse(instance.remove(c));
			assertTrue(instance.remove(a));
			assertTrue(instance.remove(b));
			instance.add(c);
			assertTrue(instance.contains(c));
			instance.remove(c);
			assertTrue(instance.isEmpty());
			instance.add(c);
			instance.add(c);
			assertTrue(instance.contains(c));
			assertEquals(instance.size(), 2);
			instance.remove(c);
			assertTrue(instance.contains(c));
			assertEquals(instance.size(), 1);
			instance.remove(c);
			assertFalse(instance.contains(c));
			assertEquals(instance.size(), 0);
		}

		
		public function testIteratorList() : void {
			trace("ListTest.testIteratorEList()");

			instance.clear();
			instance.add("a");
			instance.add("b");
			instance.add("c");
			instance.add("d");
			
			var i : IIteratorExtended = instance.iteratorExtended();
			assertTrue('circular implementation of previous at the beginning of an iteration', i.hasPrevious());
			
			
			
			i.end();
			assertTrue('extended iterator has previous 1', i.hasPrevious());
			assertTrue('extended iterator has next at the end: 1 item', i.hasNext());
			assertEquals("previous d", i.previous(), "d");
			assertTrue('extended iterator has previous 2', i.hasPrevious());
			assertEquals("previous c", i.previous(), "c");
			assertTrue('extended iterator has previous 3', i.hasPrevious());
			assertEquals("previous b", i.previous(), "b");
			assertTrue('extended iterator has previous 4', i.hasPrevious());
			assertEquals("previous a", i.previous(), "a");
			assertFalse('extended iterator has no previous', i.hasPrevious());

			assertTrue('extended iterator has next 1', i.hasNext());
			assertEquals("next b", i.next(), "b");
			assertTrue('extended iterator has previous 5', i.hasPrevious());
			
			assertEquals("previous is a", i.previous(), "a");
			assertTrue('extended iterator has next 2', i.hasNext());
			assertFalse('extended iterator has no previous', i.hasPrevious());
			
			i.end();
			assertTrue('extended iterator has next at the end (circular list)', i.hasNext());
			assertEquals("previous is d", i.previous(), "d");
			assertFalse('extended iterator has  no next when at last item', i.hasNext());
			i.begin();
			assertTrue('extended iterator has next  at the beginning', i.hasNext());
			assertTrue('extended iterator has previous  at the beginning (circular)', i.hasPrevious());
			assertEquals("next is a", i.next(), "a");
			assertTrue('extended iterator has  next 3', i.hasNext());
			
			
			
			/**
			 * try some removals when the iterator has not been manipulated yet
			 */
			i = instance.iteratorExtended();
			i.end();
			try {
				i.remove();
				fail('invalid remove');
			}catch(e : Error) {
			}
			
			i = instance.iteratorExtended();
			i.begin();
			try {
				i.remove();
				fail('invalid remove');
			}catch(e : Error) {
			}
			
			i = instance.iteratorExtended();
			try {
				i.remove();
				fail('invalid remove');
			}catch(e : Error) {
			}
			
			
			/**
			 * removals on manipulated list
			 * 
			 */
			i = instance.iteratorExtended();
			i.next();
			try {
				i.remove();
			}catch(e : Error) {
				fail('invalid remove');
			}
			//back at invalid position
			try {
				i.remove();
				fail('invalid remove');
			}catch(e : Error) {
			}
			
			i.end();
			i.previous();
			//still content
			try {
				i.remove();
			}catch(e : Error) {
				fail('invalid remove');
			}
			
			try {
				i.remove();
			}catch(e : Error) {
				fail('invalid remove');
			}
			
			
			
			/**
			 * removals on an empty list
			 */
			instance.clear();
			i = instance.iteratorExtended();
			i.end();
			try {
				i.remove();
				fail('invalid remove');
			}catch(e : Error) {
			}
			
			i = instance.iteratorExtended();
			i.begin();
			try {
				i.remove();
				fail('invalid remove');
			}catch(e : Error) {
			}
			
			i = instance.iteratorExtended();
			try {
				i.remove();
				fail('invalid remove');
			}catch(e : Error) {
			}
			
			
			/**
			 * insertion on iterator
			 */
			instance.clear();
			instance.add('a');
			instance.add('b');
			i = instance.iteratorExtended();
			i.next();
			i.insert('c');
			assertEquals("insertion on iterator", instance.toArray().toString(), "c,a,b");
			assertEquals(i.next(), 'b');
			i.insert('d');
			assertEquals("insertion on iterator", instance.toArray().toString(), "c,a,d,b");
			assertEquals('cyclic implementation', i.next(), 'c');
			
			
			instance.clear();
			i = instance.iteratorExtended();
			assertFalse('no next', i.hasNext());
			assertFalse('no previous', i.hasPrevious());
			//insertion on empty list, adds the element
			i.insert('a');
			assertTrue('has next', i.hasNext());
			assertTrue('has previous', i.hasPrevious());
			assertEquals('element is a', i.next(), 'a');
			assertFalse('no next while on 1 sized list', i.hasNext());
			assertFalse('no previous while on 1 sized list', i.hasPrevious());
			
			
			/**
			 * setting on iterator
			 */
			instance.clear();
			instance.add('c');
			instance.add('a');
			instance.add('b');
			i = instance.iteratorExtended();
			i.next();
			i.next();
			i.next();
			 
			assertTrue('setting on iterator at valid pointer', i.set('bb'));
			assertEquals("setting on iterator", instance.toArray().toString(), "c,a,bb");
			
			i.previous();
			assertTrue('setting on iterator at valid pointer (prev)', i.set('bb'));
			assertEquals("setting on iterator (prev)", instance.toArray().toString(), "c,bb,bb");
			
			i.next();
			assertTrue('setting on iterator at valid pointer (next)', i.set('aa'));
			assertEquals("setting on iterator (next)", instance.toArray().toString(), "c,bb,aa");
			
			 
			instance.clear();
			instance.add('a');
			instance.add('b');
			i = instance.iteratorExtended();
			assertFalse("setting on interator not valid", i.set('bb'));
			assertEquals("setting on iterator with no pointer does not change", instance.toArray().toString(), "a,b");
			
			instance.clear();
			instance.add('a');
			instance.add('b');
			i = instance.iteratorExtended();
			i.end();
			assertFalse("setting on interator not valid (end)", i.set('bb'));
			assertEquals("setting on iterator with no pointer does not change (end)", instance.toArray().toString(), "a,b");
			
			
			/**
			 * cyclic implementation tests
			 */
			instance.clear();
			instance.add("a");
			i = instance.iteratorExtended();
			assertTrue("previous on list for a new list", i.hasPrevious());
			assertEquals("previous is a because of cyclic implementation", i.previous(), 'a');
			assertFalse("no previous on list when going back", i.hasPrevious());
			assertEquals("previous is still a because of cyclic implementation, we are looping", i.previous(), 'a');
			assertFalse("no next while we are on a", i.hasNext());
			assertEquals("next is a because of cyclic implementation", i.next(), 'a');
			 
			instance.clear();
			instance.add("a");
			i = instance.iteratorExtended();
			i.end();
			assertTrue("previous on list for a new list at the end", i.hasPrevious());
			assertEquals("previous is a, normal behaviour", i.previous(), 'a');
			assertFalse("no previous on list when going back", i.hasPrevious());
			assertEquals("previous is still a because of cyclic implementation, we are looping", i.previous(), 'a');
			assertFalse("no next while we are on a", i.hasNext());
			assertEquals("next is a because of cyclic implementation", i.next(), 'a');
			 
			instance.clear();
			i = instance.iteratorExtended();
			assertFalse("previous on list for a new list at the end", i.hasPrevious());
			assertNull("previous is null, normal behaviour", i.previous());
			assertFalse("no previous on list when going back", i.hasPrevious());
			assertNull("previous is still null because of cyclic implementation, we are looping", i.previous());
			assertFalse("no next while when empty list", i.hasNext());
			assertNull("next is null because of cyclic implementation", i.next());
		}

		
		/**
		 * ICollection
		 */
		public function testIterator() : void {
			trace("ListTest.testIterator()");
			instance.clear();
			var i : IIterator = instance.iterator();
			//event though flash is not mutlithreaded it's still nice to test the results of two simultaneaously operating iterators
			var it : IIterator = instance.iterator();
			assertTrue(instance.iterator() is IIterator);
			assertFalse("has no next", i.hasNext());
			//iterator is invalidated when adding to the list directly, therefore 
			instance.add('a');
			instance.add('b');
			instance.add('c');
			i = instance.iterator();
			it = instance.iterator();
			assertTrue("has next", i.hasNext());
			assertTrue("has next is a", i.next() == 'a');
			assertTrue("has next after a", i.hasNext());
			assertTrue("has next is b", i.next() == 'b');
			assertTrue("iterator two next is a", it.next() == "a");
			assertTrue("has next after b", i.hasNext());
			assertTrue("has next is c", i.next() == 'c');
			assertFalse("no next after c", i.hasNext());
			assertTrue("iterator two next is b", it.next() == "b");

			
			assertEquals("size still 3", instance.size(), 3);
			assertFalse("is empty", instance.isEmpty());
			
			var data : *;
			i = instance.iterator();
			while(i.hasNext()) data = i.next();
			assertEquals('data is c', data, 'c');
			i.remove();
			assertTrue("contains a after removal", instance.contains('a'));
			assertTrue("contains b after removal", instance.contains('b'));
			assertFalse("does not contain c after removal 1", instance.contains('c'));
			assertFalse("still has next after removal", i.hasNext());
						
			assertEquals("size 2", instance.size(), 2);
			assertFalse("not empty", instance.isEmpty());
			
			i.remove();
			assertTrue("contains a after removal", instance.contains('a'));
			assertFalse("does not contain b after removal", instance.contains('b'));
			assertFalse("does not contain c after removal 2", instance.contains('c'));
			assertFalse("still has next after 2nd removal", i.hasNext());
			
			
			assertEquals("size 1", instance.size(), 1);
			assertFalse("not empty after 2nd removal", instance.isEmpty());
			assertFalse("no more next items", i.hasNext());
			
			i.remove();
			assertFalse("does not contain a after removal", instance.contains('a'));
			assertFalse("does not contain b after removal", instance.contains('b'));
			assertFalse("does not contain c after removal 3", instance.contains('c'));
			assertFalse("no more next items", i.hasNext());
			
			assertEquals("size 0", instance.size(), 0);
			assertTrue("is emptied", instance.isEmpty());
			assertFalse("no next item", i.hasNext());
			
			var a : Object = new Object();
			a.id = 1;
			var b : Object = new Object();
			b.id = 2;
			
			instance.add(b);
			instance.add(a);
			i = instance.iterator();
			assertEquals("objects added size 2", instance.size(), 2);
			assertFalse("not empty with objects", instance.isEmpty());
			assertTrue("has objects", i.hasNext());
			assertTrue("contains objc a", instance.contains(a));
			assertTrue("contains object b", instance.contains(b));
			//has no pointer to the current item
			assertFalse("cannot remove, we have not yet gone to the next element", i.remove());
			assertTrue("next is object b", i.next() == b);
			i.remove();
			assertTrue("contains object a", instance.contains(a));
			assertFalse("does not contain object b", instance.contains(b));
			
			instance.add(b);
			i = instance.iterator();
			assertEquals("next is object a", i.next(), a);
			assertTrue("has next, an object", i.hasNext());
			assertEquals("next is object b", i.next(), b);
			assertFalse("no more objects as next", i.hasNext());
			i.remove();
			i.remove();
			assertEquals("empty string for toArray", instance.toArray().toString(), '');
		}

		
		/**
		 * IQueue
		 * methods of ICollection need not be tested here as they are tested elsewhere.
		 * only add() needs to be tested to have the same functionality as enqueue
		 */
		public function testQueue() : void {
			trace("ListTest.testQueue()");
			var q : IQueue = instance as IQueue;
			q.enqueue("a");
			q.enqueue("b");
			q.enqueue("c");
			assertEquals("abc", q.toArray().toString(), 'a,b,c');
			assertEquals("size 3", q.size(), 3);
			assertEquals("peek a", q.peek(), 'a');
			assertEquals("size 3 after peek", q.size(), 3);
			assertEquals("dequeu a", q.dequeue(), 'a');
			assertEquals("size 2 after dequeue", q.size(), 2);
			//add needs to be the same for both queue and stack: put at the end of the list
			q.add('d');
			assertEquals("b,c,d after adding d", q.toArray().toString(), 'b,c,d');
			assertEquals("peek b", q.peek(), 'b');
			assertEquals("dequeu b", q.dequeue(), 'b');
			assertEquals("size after dequeeu b", q.size(), 2);
			assertEquals("peek c", q.peek(), 'c');
			assertEquals("dequeue c", q.dequeue(), 'c');
			assertEquals("size 1 after dequeue c", q.size(), 1);
			q.add('a');
			assertEquals("size 2", q.size(), 2);
			assertEquals("peek d", q.peek(), 'd');
			assertEquals("dequeue d", q.dequeue(), 'd');
			assertEquals("size 1", q.size(), 1);
			q.enqueue('b');
			assertEquals("dize 2", q.size(), 2);
			assertEquals("peek a ..", q.peek(), 'a');
			assertEquals("dequeue a..", q.dequeue(), 'a');
			assertEquals("size 1", q.size(), 1);
			assertFalse("cannot remove a", q.remove('a'));
			assertTrue("cannot remove b", q.remove('b'));
			assertEquals("size o", q.size(), 0);
			
			q.enqueue('a');
			q.enqueue('b');
			q.enqueue('c');
			assertNotNull("not null", q.dequeue());
			assertNotNull("not null peek", q.peek());
			assertEquals("size 2....", q.size(), 2);
			q.clear();
			assertEquals("size 0 empty", q.size(), 0);
			
			assertNull("deque null", q.dequeue());
			assertNull("peek null", q.peek());
			
			//trivial iterator tests
			q.enqueue('a');
			q.enqueue('b');
			q.enqueue('c');
			assertEquals("size 3..", q.size(), 3);
			var i : IIterator = q.iterator();
			//the next is not possible, as the iterator will be invalidated
			//			while(i.hasNext()) {
			//				//nice
			//				q.remove(q.peek());	
			//			}
			//			assertEquals("emptied by iterator", q.size(), 0);
			instance.clear();
			q.enqueue('a');
			q.enqueue('b');
			q.enqueue('c');
			assertEquals("size 3", q.size(), 3);
			i = q.iterator();
			
		//	while(i.hasNext()) {
				//this differs for the implementation of linked and arraylist.
				//on the other hand, this is also the behaviour of the java implementation which warns against manipulating the list while using an iterator
				//so using it this way should be avoided anyway
				//the pointer for the link stays at the same node
				//the pointer to the index takes another position in the array.
				//the preferred way is the linked list way
				//assertEquals("i next = q.dequeue", i.next(), q.dequeue());
					
		//	}
		//	assertEquals("size 0", q.size(), 0);
		}

		
		/**
		 * IStack
		 * methods of ICollection need not be tested here as they are tested elsewhere.
		 * only add() needs to be tested to have the same functionality as push()
		 */
		public function testStack() : void {
			trace("ListTest.testStack()");
			var s : IStack = instance as IStack;
			assertNull(s.pop());
			assertNull(s.push('a'));
			s.clear();
			assertEquals(s.size(), 0);
			assertTrue(s.isEmpty());
			s.push('a');
			s.push('b');
			s.push('c');
			assertEquals(s.size(), 3);
			assertFalse(s.isEmpty());
			assertEquals(s.toArray().toString(), 'a,b,c');
			assertEquals(s.pop(), 'c');
			assertEquals(s.size(), 2);
			assertEquals(s.pop(), 'b');
			assertEquals(s.size(), 1);
			assertEquals(s.pop(), 'a');
			assertEquals(s.size(), 0);
			assertNull(s.pop());
			s.push('a');
			s.push('b');
			s.push('c');
			s.pop();
			s.pop();
			s.push('b');
			assertEquals(s.size(), 2);
			assertEquals(s.pop(), 'b');
			//queue and stack have same behaviour on list for the add operation
			s.add('c');
			
			//ICollection test
			assertTrue(s.contains('c'));
			assertTrue(s.contains('a'));
			assertFalse(s.contains('b'));
			
			assertEquals(s.pop(), 'c');
			assertEquals(s.pop(), 'a');
		}

		
		/**
		 * IDeque
		 * stack/queue functionality is tested elsewhere in this class for the list
		 */
		public function testDeque() : void {
			trace("ListTest.testDeque()");	
			var d : IDeque = instance as IDeque;
			d.addFirst('a');
			d.addLast('b');
			assertEquals(d.toArray().toString(), 'a,b');
			d.add('c');
			assertEquals(d.toArray().toString(), 'a,b,c');
			assertEquals(d.getFirst(), 'a');
			assertEquals(d.size(), 3);
			assertEquals(d.getLast(), 'c');
			assertEquals(d.size(), 3);
			assertEquals(d.removeFirst(), 'a');
			assertEquals(d.size(), 2);
			assertEquals(d.removeLast(), 'c');
			assertEquals(d.size(), 1);
			assertEquals(d.getFirst(), 'b');
			assertEquals(d.getLast(), 'b');
			assertEquals(d.removeFirst(), 'b');
			
			d.add('b');
			d.add('c');
			d.addFirst('a');
			d.addLast('d');
			d.addLast('e');
			d.add('f');
			d.addFirst('-a');
			
			assertEquals(d.toArray().toString(), '-a,a,b,c,d,e,f');
		}

		
		private function setUpListForSorting(whichList : String = LIST_UNSORTED) : void {
			instance.clear();
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var output : Array;
			var s : String;
			switch(whichList) {
				case LIST_EMPTY:
					setCheckList("");
					break;	
				case LIST_ONE_ELEMENT:
					instance.add("a");
					setCheckList("a");
					break;	
				case LIST_ALMOST_SORTED_ELEMENTS:
					instance.add("a");
					instance.add("b");
					instance.add("c");
					instance.add("d");
					instance.add("e");
					instance.add("f");
					instance.add("g");
					instance.add("h");
					instance.add("i");
					instance.add("j");
					instance.add("k");
					instance.add("l");
					instance.add("m");
					instance.add("n");
					instance.add("o");
					instance.add("p");
					instance.add("q");
					instance.add("r");
					instance.add("t");
					instance.add("u");
					instance.add("w");
					instance.add("x");
					instance.add("z");
					instance.add("s");
					instance.add("v");
					instance.add("y");
					setCheckList("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z");
					break;	
				case LIST_UNSORTED:
					instance.add("w");
					instance.add("k");
					instance.add("a");
					instance.add("b");
					instance.add("r");
					instance.add("d");
					instance.add("f");
					instance.add("h");
					instance.add("e");
					instance.add("g");
					instance.add("j");
					instance.add("n");
					instance.add("y");
					instance.add("c");
					instance.add("l");
					instance.add("q");
					instance.add("o");
					instance.add("p");
					instance.add("m");
					instance.add("s");
					instance.add("t");
					instance.add("u");
					instance.add("v");
					instance.add("x");
					instance.add("z");
					instance.add("i");
					setCheckList("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z");
					break;	
				case LIST_SORTED_ELEMENTS:
					instance.add("a");
					instance.add("b");
					instance.add("c");
					instance.add("d");
					instance.add("e");
					instance.add("f");
					instance.add("g");
					instance.add("h");
					instance.add("i");
					instance.add("j");
					instance.add("k");
					instance.add("l");
					instance.add("m");
					instance.add("n");
					instance.add("o");
					instance.add("p");
					instance.add("q");
					instance.add("r");
					instance.add("s");
					instance.add("t");
					instance.add("u");
					instance.add("v");
					instance.add("w");
					instance.add("x");
					instance.add("y");
					instance.add("z");
					setCheckList("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z");
						
					break;	
				case LIST_LARGE:
					output = new Array();
					//1000/26 = 38,..
					for(i = 0;i < 50;++i) {
						for(j = 0;j < alphabet.length; j++) {
							instance.add(alphabet.charAt(i) + j);
							output.push(alphabet.charAt(i) + j); 
						}
					}
					//RunTimer.start();
					//since array sorting is native, this beats all our custom sorts.
					output.sort();
					//RunTimer.traceRunTime("sort large for normal array", true);
					s = "";
					for(k = 0;k < output.length;++k) {
						s = s + "," + output[k];
					}	
					s = s.substr(1, s.length);
					setCheckList(s);
					
			 
					break;	
				case LIST_ODD:
					instance.add("e");
					instance.add("d");
					instance.add("q");
					instance.add("b");
					instance.add("a");
					instance.add("z");
					instance.add("c");
					setCheckList("a,b,c,d,e,q,z");
				
					break;	
				case LIST_EVEN:
					instance.add("z");
					instance.add("e");
					instance.add("g");
					instance.add("y");
					setCheckList("e,g,y,z");
				
					break;	
				case LIST_DUPLICATE:
					instance.add("a");
					instance.add("b");
					instance.add("c");
					instance.add("a");
					instance.add("b");
					instance.add("e");
					instance.add("a");
					instance.add("d");
					instance.add("d");
					instance.add("f");
					setCheckList("a,a,a,b,b,c,d,d,e,f");
				
					break;	
				case LIST_LARGE_KEYS:
					output = new Array();
					for(i = 0;i < alphabet.length; i++) {
						//1000/26 = 38,..
						for(j = 0;j < 20;++j) {
							instance.add('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'+alphabet.charAt(i) + j);
							output.push('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'+alphabet.charAt(i) + j); 
						}
					}
					output.sort();
					s = "";
					for(k = 0;k < output.length;++k) {
						s = s + "," + output[k];
					}	
					s = s.substr(1, s.length);
					setCheckList(s);
					break;	
				case LIST_LARGE_SORTED:
					s = "";
					for(i = 0;i < 1000; i++) {
						instance.add(i);
						s = s + "," + i; 
					}
					s = s.substr(1, s.length);
					setCheckList(s);
					break;	
			}
		}

		
		protected function setCheckList(check : String) : void {
			checkSortedList = check;
		}

		
		protected function getOutputStringForCurrentSortedList() : String {
			return checkSortedList;
		}

		
		/**
		 * List
		 */
		public function testListSetAndGet() : void {
			trace("ListTest.testListSetAndGet()");
			instance.clear();
			instance.set(10, 'b');
			assertEquals(instance.indexOf('b'), 0);
			instance.set(1, 'b');
			assertEquals(instance.indexOf('b'), 0);
			instance.set(0, 'a');
			assertEquals(instance.indexOf('a'), 0);
			assertEquals(instance.indexOf('b'), 1);
			assertEquals(instance.get(0), 'a');
			assertEquals(instance.get(1), 'b');
			assertNull(instance.get(2));
			assertNull(instance.get(-1));
			instance.clear();
			assertNull(instance.get(-1));
			assertNull(instance.get(0));
			assertNull(instance.get(1));
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.add('d');
			instance.add('e');
			instance.add('a');
			instance.set(4, '4');
			assertEquals(instance.get(0), 'a');
			assertEquals(instance.get(1), 'b');
			assertEquals(instance.get(5), 'a');
			assertEquals(instance.get(4), '4');
			assertEquals(instance.get(6), null);
		}

		
		/**
		 * List
		 */
		public function testListSelect() : void {
			trace("ListTest.testListSelect()");
			instance.clear();
			var result : List = new LinkedList();
			var a : Object = new Object();
			var b : Object = new Object();
			var c : Object = new Object();
			var d : Object = new Object();
			var e : Object = new Object();
			var f : Object = new Object();
			var g : Object = new Object();
			var h : Object = new Object();
			a.id = 1;
			b.id = 2;
			c.id = 3;
			d.id = 3;
			e.id = 3;
			f.id = 2;
			g.id = 4;
			h.id = 4;
			a.name = 'a';
			b.name = 'bac';
			c.name = 'cd';
			d.name = 'ccd';
			e.name = 'cbd';
			f.name = 'ba';
			g.name = 'h';
			h.name = 'g';
			instance.add(a);
			instance.add(b);
			instance.add(c);
			instance.add(d);
			instance.add(e);
			instance.add(f);
			instance.add(g);
			instance.add(h);
		
			result = instance.selectBy(new BooleanSpecification(false));
			assertTrue("listsize 0", result.size() == 0);
			
			result = instance.selectBy(new BooleanSpecification(true));
			assertTrue("listsize not zeror", result.size() != 0);
			
			
			result = instance.selectBy(new ObjectIdSpecification(3));
			assertEquals(result.size(), 3);
			
			result = instance.selectBy(new ObjectIdSpecification(1));
			assertEquals(result.size(), 1);
			assertEquals(result.get(0), a);
			
			result = instance.selectBy(new ObjectIdSpecification(4));
			assertEquals(result.size(), 2);
			
			result = instance.selectBy(new ObjectIdSpecification(999));
			assertEquals(result.size(), 0);
			assertTrue(result.isEmpty());
			
			result = instance.selectBy(new ObjectIdSpecification(-1));
			assertEquals(result.size(), 0);
			assertTrue(result.isEmpty());
			
			result = instance.selectBy(new ObjectIdSpecification(-1).not());
			assertEquals(result.size(), 8);
			assertFalse(result.isEmpty());
		}

		
		protected function doSort(func : Function, sorttype : int, sortListType : String, message : String) : void {
			trace(message);
			setUpListForSorting(sortListType);
			RunTimer.start();
			instance.sort(func, sorttype);
			RunTimer.traceRunTime(message, true);
			assertEquals(message, instance.toArray().toString(), getOutputStringForCurrentSortedList());
		}

		
		public function testNestedSort() : void {
			trace("ListTest.nestedSort()");
			instance.clear();
			
			var a : Object = new Object();
			var b : Object = new Object();
			var c : Object = new Object();
			var d : Object = new Object();
			var e : Object = new Object();
			var f : Object = new Object();
			var g : Object = new Object();
			var h : Object = new Object();
			a.id = 1;
			b.id = 2;
			c.id = 3;
			d.id = 3;
			e.id = 3;
			f.id = 2;
			g.id = 4;
			h.id = 4;
			a.name = 'a';
			b.name = 'bac';
			c.name = 'cd';
			d.name = 'ccd';
			e.name = 'cbd';
			f.name = 'ba';
			g.name = 'h';
			h.name = 'g';
			instance.add(a);
			instance.add(b);
			instance.add(c);
			instance.add(d);
			instance.add(e);
			instance.add(f);
			instance.add(g);
			instance.add(h);
			var nested : Function = function (aC : Object, bC : Object):int {
				if(aC.id < bC.id) return SortOrder.LESS;
				if(aC.id == bC.id) {
					if(aC.name < bC.name) return SortOrder.LESS;
					if(aC.name == bC.name)return SortOrder.EQUAL;
					return SortOrder.LARGER;
				}
				return SortOrder.LARGER;	
			}
			instance.sort(nested, SortTypes.BUBBLE);
			var arr : Array = instance.toArray();
			//trace("ListTest.nestedSort(): output");
			for(var i : int = 0;i < arr.length; ++i){
				//trace(arr[i].id + ': ' + arr[i].name);	
			}
			assertTrue(instance.get(0), a);
			assertTrue(instance.get(1), f);
			assertTrue(instance.get(2), b);
			assertTrue(instance.get(3), e);
			assertTrue(instance.get(4), d);
			assertTrue(instance.get(5), c);
			assertTrue(instance.get(6), h);
			assertTrue(instance.get(7), g);
		}

		
		/**
		 * IList
		 */
		public function testListRemoveAt() : void {
			trace("ListTest.testListRemoveAt()");
			instance.clear();
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.add('d');
			instance.add('e');		
			assertEquals("listsize 5", instance.size(), 5);
			assertFalse("cannot remove 6", instance.removeAt(6));
			assertFalse("cannot remove 5", instance.removeAt(5));
			assertTrue(instance.removeAt(4));
			assertTrue(instance.removeAt(3));
			assertTrue(instance.removeAt(2));
			assertTrue(instance.removeAt(1));
			assertTrue(instance.removeAt(0));
			assertFalse(instance.removeAt(-1));
			assertFalse(instance.removeAt(0));
			assertFalse(instance.removeAt(1));
			assertFalse(instance.removeAt(2));
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.add('d');
			instance.add('e');		
			assertTrue(instance.removeAt(0));
			assertFalse(instance.removeAt(4));
			assertTrue(instance.removeAt(3));
			assertFalse(instance.removeAt(3));
			assertFalse(instance.removeAt(-1));
			assertFalse(instance.removeAt(999));
			assertTrue(instance.removeAt(2));
			assertTrue(instance.removeAt(0));
			assertTrue(instance.removeAt(0));
			assertFalse(instance.removeAt(0));
		}

		
		/**
		 * List
		 */
		public function testListIndexOf() : void {
			trace("ListTest.testListIndexOf()");
			instance.clear();
			assertEquals(instance.indexOf('a'), -1);
			assertEquals(instance.indexOf(''), -1);
			assertEquals(instance.indexOf(null), -1);
			assertEquals(instance.indexOf(0), -1);
			assertEquals(instance.indexOf(true), -1);
			assertEquals(instance.indexOf(false), -1);
			
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.add('d');
			instance.add('e');
			assertEquals(instance.indexOf('a'), 0);
			assertEquals(instance.indexOf('b'), 1);
			assertEquals(instance.indexOf('c'), 2);
			assertEquals(instance.indexOf('d'), 3);
			assertEquals(instance.indexOf('e'), 4);
			instance.set(0, 'g');
			assertEquals(instance.indexOf('g'), 0);
			assertEquals(instance.indexOf('a'), -1);
			instance.add(null);
			assertEquals(instance.indexOf(null), 5);		
			assertEquals(instance.size(), 6);
			instance.add('a');
			instance.add('a');
			instance.add('b');
			assertEquals(instance.lastIndexOf('a'), 7);		
			instance.add('b');
			assertEquals(instance.lastIndexOf('a'), 7);
			instance.add('a');		
			assertEquals(instance.lastIndexOf('a'), 10);
			assertEquals(instance.indexOf('a'), 6);		
			instance.remove('a');
			assertEquals(instance.indexOf('a'), 6);		
			assertEquals(instance.size(), 10);
			assertEquals(instance.lastIndexOf('a'), 9);
			while(instance.remove('a'));
			assertEquals(instance.indexOf('a'), -1);
			assertEquals(instance.lastIndexOf('a'), -1);
		}

		
		public function testInsertAt() : void {
			trace("ListTest.testInsertAt()");
			instance.clear();
			instance.add("a");
			instance.add("b");
			instance.add("c");
			instance.insertAt(1, "d");
			assertEquals('insert d at 1', instance.toArray().toString(), 'a,d,b,c');
			instance.insertAt(1, "e");
			assertEquals('insert e at 1', instance.toArray().toString(), 'a,e,d,b,c');
			
			instance.clear();
			instance.insertAt(10, 'a');
			assertTrue('can insert out of bounds, contains a', instance.contains('a'));
			
			instance.clear();
			instance.insertAt(-1, 'a');
			assertTrue('can insert out of bounds -1, contains a', instance.contains('a'));
		}

		
		/**
		 * List
		 */
		public function testListSubList() : void {
			trace("ListTest.testListSubList()");
			instance.clear();
			var sub : List;
			
			sub = instance.subList(0, 0);
			assertEquals("sublist size 0", sub.size(), 0);
			sub = instance.subList(2, 3);
			assertEquals("sublist still 0", sub.size(), 0);
			sub = instance.subList(-1, 0);
			assertEquals("sublist still 0", sub.size(), 0);
			
			instance.add("a");
			instance.add("b");
			instance.add("c");
			sub = instance.subList(0, 1);
			assertEquals("sublist 0,1", sub.size(), 1);
			assertEquals("sublist content", sub.toArray().toString(), "a");
			
			sub = instance.subList(1, 2);
			assertEquals("sublist 1", sub.size(), 1);
			assertEquals("sublist content", sub.toArray().toString(), "b");
			
			sub = instance.subList(1, 3);
			assertEquals("sublist 2", sub.size(), 2);
			assertEquals("sublist content", sub.toArray().toString(), "b,c");
			
			assertEquals("original untouched", instance.size(), 3);
			
			
			instance.add('d');
			instance.add('e');
			
			sub = instance.subList(1, 0);
			assertEquals("sublist invalid input 1,1", sub.size(), 0);
			sub = instance.subList(-1, 1);
			assertEquals("sublist invalid input -1,1", sub.size(), 0);
			sub = instance.subList(-2, -1);
			assertEquals("sublist invalid input -2,-1", sub.size(), 0);
			
			var q : IQueue;
			q = instance.subList(0, instance.size()) as IQueue;
			assertTrue("converted to Iqueue", q is IQueue);
			assertEquals(q.size(), 5);
			assertNotSame("copy, not original", instance, q);
			assertEquals(q.peek(), "a");
			assertEquals(q.dequeue(), "a");
			assertEquals(q.dequeue(), "b");
		}

		
		/**
		 * List
		 */
		public function testListReverse() : void {
			trace("ListTest.testListReverse()");
			instance.clear();
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.reverse();
			assertEquals('odd', instance.toArray().toString(), 'c,b,a');
			instance.reverse();
			assertEquals('odd', instance.toArray().toString(), 'a,b,c');
			
			instance.add('d');
			assertEquals(instance.toArray().toString(), 'a,b,c,d');
			instance.reverse();
			assertEquals(instance.toArray().toString(), 'd,c,b,a');
			instance.reverse();
			assertEquals(instance.toArray().toString(), 'a,b,c,d');
		}
	}
}

