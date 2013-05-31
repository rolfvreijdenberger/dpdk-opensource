package nl.dpdk.collections {
	import nl.dpdk.collections.CollectionTest;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.sets.Set;	

	/**
	 * @author Rolf Vreijdenberger
	 */
	public class SetTest extends CollectionTest {
		private var instance : Set;

		public function SetTest(testMethod : String = null) {
			super(testMethod);
		}

		
		public function testAddRemoveContainsGet() : void {
			trace("SetTest.testAddRemoveContainsGet()");	
			basicSetup();
			assertTrue(instance.isEmpty());
			assertEquals(instance.size(), 0);
			assertFalse(instance.contains('a'));
			instance.add('a');
			//trace(instance.toString() + ', ' + instance.toArray());
			assertFalse('instance not empty after adding a', instance.isEmpty());
			assertEquals('size 1', instance.size(), 1);
			instance.add('a');
			assertFalse('instance not empty after adding a 2nd time', instance.isEmpty());
			assertEquals('still size 1', instance.size(), 1);
			assertTrue(instance.contains('a'));
			assertFalse(instance.contains('b'));
			assertFalse(instance.contains(null));
			assertTrue(instance.remove('a'));
			assertFalse(instance.contains('a'));
			assertTrue(instance.isEmpty());
			assertEquals(instance.size(), 0);
			assertFalse(instance.remove('a'));
			var a : Object = new Object();
			var b : Object = new Object();
			instance.add(a);
			assertTrue(instance.contains(a));
			assertFalse(instance.contains(b));
			assertFalse(instance.contains('a'));
			assertFalse(instance.contains('b'));
			assertNotSame(a, b);
			instance.add(b);
			assertTrue(instance.contains(b));
			assertEquals(instance.size(), 2);
			assertTrue(instance.remove(a));
			assertEquals(instance.size(), 1);
			assertTrue(instance.remove(b));
			assertEquals(instance.size(), 0);
			assertFalse(instance.remove(b));
			assertFalse(instance.remove(a));
		}

		
		private function basicSetup() : void {
			instance = new Set();
		}

		
		public function testConstructor() : void {
			trace("SetTest.testConstructor()");
			basicSetup();
			var list : List = new ArrayList();
			list.add('a');
			list.add('b');
			list.add('b');
			assertEquals(list.size(), 3);
			instance = new Set(list);
			assertEquals('no duplicates in set', instance.size(), 2);
			assertFalse(instance.isEmpty());
			assertTrue(instance.contains('a'));
			assertTrue(instance.contains('b'));
			assertEquals('no order implied, but length is constant', instance.toArray().length, 2);
			assertEquals('no order implied, but length is same as Set', instance.toArray().length, instance.size());
		}

		
		public function testClearSizeEmpty() : void {
			trace("SetTest.testClearSizeEmpty()");
			instance.clear();
			instance.add('a');
			assertEquals(instance.size(), 1);
			assertFalse(instance.isEmpty());
			instance.clear();
			assertEquals(instance.size(), 0);
			assertTrue(instance.isEmpty());
			instance.add('b');
			instance.add('a');
			instance.add('b');
			instance.add('c');
			assertFalse(instance.isEmpty());
			assertEquals(instance.size(), 3);
			instance.clear();
			assertEquals(instance.size(), 0);
			assertTrue(instance.isEmpty());
		}

		
		public function testIterator() : void {
			trace("SetTest.testIterator()");	
			basicSetup();
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.add(new Object());
			instance.add('e');
			instance.add('h');
			instance.add('f');
			instance.add(new Object());
			assertEquals(instance.size(), 8);
			var iterator:IIterator = instance.iterator();
			var data: *;
			assertTrue(iterator.hasNext());
			var count: int;
			
			count = 0;
			trace('---');
			while(iterator.hasNext())
			{
				count ++;
				data = iterator.next();
				trace('iteration of set (not ordered): ' + data);
				assertTrue(instance.contains(data));
			}
			assertEquals(count, 8);
			
			iterator = instance.iterator();
			data = iterator.next();
			iterator.remove();
			assertFalse(instance.contains(data));
			
			count = 0;
			trace('---');
			while(iterator.hasNext())
			{
				count ++;
				data = iterator.next();
				trace('iteration of set (not ordered) with one removed: ' + data);
				assertTrue(instance.contains(data));
			}
			assertEquals(count, 7);
			
			count = 0;
			trace('---');
			iterator = instance.iterator();
			while(iterator.hasNext())
			{
				count ++;
				data = iterator.next();
				assertTrue(instance.contains(data));
				assertTrue(iterator.remove());
				trace('iteration of set (not ordered) while removing: ' + data);
				assertFalse(instance.contains(data));
			}
			assertEquals(count, 7);
			assertEquals(instance.size(), 0);
		}

		
		/**
		 * this method sets up all stuff we need before we run the test
		 */
		protected override function setUp() : void {
			instance = new Set();
		}

		
		/**
		 *	use to remove all stuff not needed after this test
		 */
		protected override function tearDown() : void {
			instance = null;
		}

		
		/**
		 *	a test implementation
		 */
		public function testInstantiated() : void {
			assertTrue("Set instantiated", instance is Set);
		}
	}
}
