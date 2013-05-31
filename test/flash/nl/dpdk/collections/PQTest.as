package nl.dpdk.collections 
{	import nl.dpdk.collections.lists.PriorityQueueNode;	
	import nl.dpdk.collections.lists.PriorityQueue;	
	
	import asunit.framework.TestCase;	public class PQTest extends TestCase {		private var instance : PriorityQueue;
		/**		* constructor		*/		public function PQTest(testMethod:String = null) {			super(testMethod);		}				/**		* this method sets up all stuff we need before we run the test		*/		protected override function setUp():void {			instance = new PriorityQueue();		}		/**		*	use to remove all stuff not needed after this test		*/		protected override function tearDown():void {			instance = null; 		}		/**		*	a test implementation		*/ 		public function testInstantiated():void {			assertTrue("PriorityQueue instantiated", instance is PriorityQueue);		}			public function testPQ():void{
			trace("PQTest.testPQ()");
			instance.clear();
			//create some nodes with priorities, highest priorities come first.
			var z: PriorityQueueNode = new PriorityQueueNode(1,'z');
			var y: PriorityQueueNode = new PriorityQueueNode(2,'y');
			var x: PriorityQueueNode = new PriorityQueueNode(3,'x');
			var w: PriorityQueueNode = new PriorityQueueNode(4,'w');
			var v: PriorityQueueNode = new PriorityQueueNode(5,'v');
			var u: PriorityQueueNode = new PriorityQueueNode(6,'u');
			instance.add(z);	
			instance.add(y);	
			instance.add(x);	
			instance.add(w);	
			instance.add(v);	
			instance.add(u);	
			//remove em
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'u');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'v');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'w');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'x');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'y');
			assertFalse('not empty yet', instance.isEmpty());
			assertEquals('one left', instance.size(), 1);
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'z');
			assertTrue('empty ' , instance.isEmpty());
			assertEquals('size 0', instance.size(), 0);
			assertNull('null removed on empty', instance.removeMaximum());
			assertTrue('still empty' , instance.isEmpty());
			assertNull('null removed on empty', instance.removeMaximum());
			assertEquals('still 0', instance.size(), 0);
			
			
			instance.add(z);	
			instance.add(y);	
			instance.add(x);	
			instance.add(w);	
			instance.add(v);	
			instance.add(u);
			assertEquals('added 6', instance.size(), 6);
			//reprioritize via interface
			instance.rePrioritize(z, 7);
			assertEquals('reprioritized, should be z', PriorityQueueNode(instance.removeMaximum()).getData(), 'z');
			//reprioritize via node, then heapify (unoptimal implementation)
			y.setPriority(7);
			instance.heapify();
			assertEquals('reprioritized via node', PriorityQueueNode(instance.removeMaximum()).getData(), 'y');
			//normal removal
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'u');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'v');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'w');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'x');
			assertTrue('still empty..' , instance.isEmpty());
			assertNull('null removed on empty..', instance.removeMaximum());
			assertEquals('still 0..', instance.size(), 0);
			
			instance.add(z);	
			instance.add(y);	
			instance.add(x);	
			instance.add(w);	
			instance.add(v);	
			instance.add(u);
			assertEquals('added 6', instance.size(), 6);
			//reprioritize via interface
			instance.rePrioritize(z, 1);
			instance.rePrioritize(y, 2);
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'u');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'v');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'w');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'x');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'y');
			assertFalse('not empty yet', instance.isEmpty());
			assertEquals('one left', instance.size(), 1);
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'z');
			
			
			instance.add(z);	
			instance.add(y);	
			instance.add(x);	
			instance.add(w);	
			instance.add(v);	
			instance.add(u);
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'u');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'v');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'w');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'x');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'y');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'z');
			
			instance.add(z);	
			instance.add(y);	
			instance.add(x);	
			instance.add(w);	
			instance.add(v);	
			instance.add(u);
			assertFalse('still empty..' , instance.isEmpty());
			assertEquals('still 6', instance.size(), 6);
			instance.clear();
			assertTrue(instance.isEmpty());
			assertEquals('0 agian', instance.size(), 0);
			
			
			//contains and remove tests
			instance.add(z);	
			instance.add(y);	
			instance.add(x);	
			instance.add(w);	
			instance.add(v);	
			instance.add(u);
			
			assertTrue(instance.contains(z));
			assertTrue(instance.contains(y));
			assertTrue(instance.contains(x));
			assertTrue(instance.contains(w));
			assertTrue(instance.contains(v));
			assertTrue(instance.contains(u));
			assertFalse(instance.contains(instance));
			assertFalse(instance.contains(null));
			assertFalse(instance.contains(0));
			
			assertTrue(instance.remove(v));
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'u');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'w');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'x');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'y');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'z');
			
			
			
			
			
			
		}
		
	
		
		public function testRemoveAt():void{
			trace("PQTest.testRemoveAt()");
			
			//test and fix for bugreport by jan de vries at 18-06-2009
			instance.clear();
			//create some nodes with priorities, highest priorities come first.
			var z: PriorityQueueNode = new PriorityQueueNode(1,'z');
			var y: PriorityQueueNode = new PriorityQueueNode(2,'y');
			var x: PriorityQueueNode = new PriorityQueueNode(3,'x');
			var w: PriorityQueueNode = new PriorityQueueNode(4,'w');
			var v: PriorityQueueNode = new PriorityQueueNode(5,'v');
			var u: PriorityQueueNode = new PriorityQueueNode(6,'u');
			instance.add(z);//1	
			instance.add(y);//2	
			instance.add(x);//3	
			instance.add(w);//4	
			instance.add(v);//5	
			instance.add(u);//6	
			assertEquals(instance.size(), 6);
			assertTrue(instance.contains(z));
			assertTrue(instance.contains(y));
			assertTrue(instance.contains(x));
			assertTrue(instance.contains(w));
			assertTrue(instance.contains(v));
			assertTrue(instance.contains(u));
			
			assertTrue("first removal", instance.remove(z));
			assertFalse("second removal" , instance.remove(z));
			assertFalse("removed" , instance.contains(z));
			z.setPriority(7);
			instance.add(z);
			assertTrue("added and contains", instance.contains(z));
			assertEquals("p7",z.getPriority(), 7);
			assertEquals("size 6", instance.size(), 6);
			
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'z');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'u');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'v');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'w');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'x');
			assertEquals(PriorityQueueNode(instance.removeMaximum()).getData(), 'y');
			assertTrue( instance.isEmpty());
			assertEquals('one left', instance.size(), 0);
			
			
			
			instance.add(u);
			instance.add(v);
			instance.add(w);
			instance.add(x);
			instance.remove(u);
			instance.remove(v);
			instance.remove(x);
			instance.remove(w);
			assertFalse('contains u', instance.contains(u));
			assertFalse('contains v', instance.contains(v));
			assertFalse('contains w', instance.contains(w));
			assertFalse('contains z', instance.contains(z));
			
			
		}		
		public function testClear():void
		{
			//test and fix for bugreport by jan de vries at 18-06-2009
			instance.clear();
			//create some nodes with priorities, highest priorities come first.
			var z: PriorityQueueNode = new PriorityQueueNode(1,'z');
			var y: PriorityQueueNode = new PriorityQueueNode(2,'y');
			var x: PriorityQueueNode = new PriorityQueueNode(3,'x');
			var w: PriorityQueueNode = new PriorityQueueNode(4,'w');
			var v: PriorityQueueNode = new PriorityQueueNode(5,'v');
			var u: PriorityQueueNode = new PriorityQueueNode(6,'u');
			instance.add(z);//1	
			instance.add(y);//2	
			instance.add(x);//3	
			instance.add(w);//4	
			instance.add(v);//5	
			instance.add(u);//6	
			assertEquals(instance.size(), 6);
			assertTrue(instance.contains(z));
			assertTrue(instance.contains(y));
			assertTrue(instance.contains(x));
			assertTrue(instance.contains(w));
			assertTrue(instance.contains(v));
			assertTrue(instance.contains(u));
			
			instance.clear();
			assertEquals(instance.size(), 0);
			assertFalse(instance.contains(z));
			assertFalse(instance.contains(y));
			assertFalse(instance.contains(x));
			assertFalse(instance.contains(w));
			assertFalse(instance.contains(v));
			assertFalse(instance.contains(u));
			assertTrue(instance.isEmpty());
		}
	}}