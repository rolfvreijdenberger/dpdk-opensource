package nl.dpdk.collections 
{
	import nl.dpdk.collections.CollectionTest;
	import nl.dpdk.collections.lists.Heap;
	import nl.dpdk.collections.sorting.Comparators;		

	/**
	 * @author Rolf Vreijdenberger
	 */
	public class HeapTest extends CollectionTest 
	{
		private var instance : Heap;

		public function HeapTest(testMethod : String = null)
		{
			super(testMethod);
		}
		
			/**
		 * this method sets up all stuff we need before we run the test
		 */
		protected override function setUp() : void {
			instance = new Heap(Comparators.compareIntegers);
		}
		
		public function testHeap():void{
			trace("HeapTest.testHeap()");
			instance = new Heap(Comparators.compareIntegers);
			assertEquals(instance.size(), 0);
			assertEquals(instance.isEmpty(), true);
			trace(';starting with adding: 1,3,6,0,2,4,5,8,7,9');
			instance.add(1);
			instance.add(3);
			instance.add(6);
			instance.add(0);
			instance.add(2);
			instance.add(4);
			instance.add(5);
			instance.add(8);
			instance.add(7);
			instance.add(9);
			assertEquals(instance.size(), 10);
			assertFalse(instance.isEmpty());
			trace('heap is now: ' + instance.toArray());
			assertEquals('9',instance.removeMaximum(), 9);
			assertEquals('8',instance.removeMaximum(), 8);
			assertEquals('7',instance.removeMaximum(), 7);
			assertEquals('6',instance.removeMaximum(), 6);
			assertEquals('5',instance.removeMaximum(), 5);
			assertEquals('4',instance.removeMaximum(), 4);
			assertEquals('3',instance.removeMaximum(), 3);
			assertEquals('2',instance.removeMaximum(), 2);
			assertEquals('1',instance.removeMaximum(), 1);
			assertEquals('0',instance.removeMaximum(), 0);
			assertEquals('null',instance.removeMaximum(), null);
			assertEquals('null',instance.removeMaximum(), null);
			trace('heap is now: ' + instance.toArray());
			assertNull('null', instance.removeMaximum());
		}
		
		public function testHeapify():void{
			trace("HeapTest.testHeapify()");
			instance = new Heap(Comparators.compareIntegers);
			assertEquals(instance.size(), 0);
			assertEquals(instance.isEmpty(), true);
			trace(';starting with adding: 1,3,6,0,2,4,5,8,7,9');
			instance.add(1);
			instance.add(3);
			instance.add(6);
			instance.add(0);
			instance.add(2);
			instance.add(4);
			instance.add(5);
			instance.add(8);
			instance.add(7);
			instance.add(9);
			assertEquals(instance.size(), 10);
			assertFalse(instance.isEmpty());
			//trace('heap is now: ' + instance.toArray());
			assertEquals('9',instance.removeMaximum(), 9);
			assertEquals('8',instance.removeMaximum(), 8);
			assertEquals('7',instance.removeMaximum(), 7);
			assertEquals('6',instance.removeMaximum(), 6);
			//wohaaaa, reverse order biatch!
			instance.setComparator(Comparators.compareIntegersDescending);
			//trace('heap is now: ' + instance.toArray());
			assertEquals('0',instance.removeMaximum(), 0);
			//trace('heap is now -0: ' + instance.toArray());
			assertEquals('1',instance.removeMaximum(), 1);
			//trace('heap is now - 1: ' + instance.toArray());
			assertEquals('2',instance.removeMaximum(), 2);
			//trace('heap is now - 2: ' + instance.toArray());
			assertEquals('3',instance.removeMaximum(), 3);
			//trace('heap is now - 3: ' + instance.toArray());
			assertEquals('4',instance.removeMaximum(), 4);
			assertEquals('5',instance.removeMaximum(), 5);
			
		}

		
		/**
		 *	use to remove all stuff not needed after this test
		 */
		protected override function tearDown() : void {
			instance = null;
		}
		
		public function testInstantiated() : void {
			trace("HeapTest.testInstantiated()");
		}
	}
}
