package nl.dpdk.utils 
{
	import asunit.framework.TestCase;

	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.Heap;
	import nl.dpdk.collections.lists.LinkedList;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.sorting.Comparators;
	import nl.dpdk.commands.ChangePropertyCommand;
	import nl.dpdk.user.User;

	import flash.display.Sprite;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class CollectionUtilsTest extends TestCase 
	{
		public function CollectionUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
		}

		override protected function tearDown():void
		{
		}

		public function testCallMethod():void
		{
			var list:ICollection = new ArrayList();
			var sprite:Sprite = new Sprite();
			
			list.add(new ChangePropertyCommand(sprite, "x", 50));
			list.add(new ChangePropertyCommand(sprite, "y", 100));
			list.add(new ChangePropertyCommand(sprite, "alpha", 0.5));
			
			CollectionUtils.callMethod(list, "execute");
			
			assertEquals("sprite's x is 50",sprite.x, 50);
			assertEquals("sprite's y is 100",sprite.y, 100);
			assertEquals("sprite's alpha is 0.5",sprite.alpha, 0.5);	
		}

		public function testCallMethodWithArgs():void
		{
			var list:ICollection = new ArrayList();
			//needed a class with explicit accesors here
			list.add(new User());
			list.add(new User());
			list.add(new User());
			
			CollectionUtils.callMethod(list, "setSurname", "Janssen");
			
			var iterator:IIterator = list.iterator();
			var user:User;
			while(iterator.hasNext())
			{
				user = iterator.next() as User;
				assertEquals("all users have the same surname ", user.getSurname(), "Janssen");
			}
		}

		public function testExchange():void
		{
			var list:ArrayList = new ArrayList();
			
			for (var i:int = 0;i < 10;++i)
			{
				list.add(i);
			}
			
			assertTrue('exchange worked', CollectionUtils.exchange(list, 0, 9));
			
			assertEquals('size of the list is 10', list.size(), 10);
			assertEquals('at index 0 is "9"', list.get(0), 9);
			assertEquals('at index 9 is "0"', list.get(9), 0);
			
			assertFalse('exchange failed', CollectionUtils.exchange(list, 90, 2));
			assertFalse('exchange failed', CollectionUtils.exchange(list, 2, 10));
			
			assertFalse('size of list is not 90', list.size() == 90);
			assertTrue('list size is still 10', list.size() == 10);
			assertEquals('at index 2 is still 2', list.get(2), 2);
			
		}

		public function testAddArray():void
		{
			var array:Array = [1,2,3,4,5,6,7];
			var collection:ArrayList = new ArrayList();
			
			assertEquals('size of collection is zero', collection.size(), 0);
			assertFalse('collection does not contain "1"', collection.contains(1));
			
			CollectionUtils.addArrayToCollection(array, collection);
			
			assertFalse('size of collection is not zero', collection.size() == 0);
			assertEquals('size of collection is 7', collection.size(), 7);
			assertTrue('collection contains "1"', collection.contains(1));
			assertEquals('collection contains the array', collection.toArray().toString(), "1,2,3,4,5,6,7");
			
			collection.clear();
			
			collection.add(8);
			collection.add(9);
			collection.add(0);
			
			CollectionUtils.addArrayToCollection(array, collection);
			
			assertFalse('size of new collection is not zero', collection.size() == 0);
			assertEquals('size of new collection is 10', collection.size(), 10);
			assertTrue('new collection contains "1"', collection.contains(1));
			assertTrue('new collection contains "7"', collection.contains(7));
			assertTrue('new collection contains "0"', collection.contains(0));
			assertEquals('new collection contains the array', collection.toArray().toString(), "8,9,0,1,2,3,4,5,6,7");
		}
		
		public function testRemoveArray():void
		{
			var array:Array = [1,2,3,4,5,6,7];
			var collection:ArrayList = new ArrayList();
			
			assertEquals('size of collection is zero', collection.size(), 0);
			assertFalse('collection does not contain "1"', collection.contains(1));
			
			CollectionUtils.addArrayToCollection(array, collection);
			
			assertFalse('size of collection is not zero', collection.size() == 0);
			assertEquals('size of collection is 7', collection.size(), 7);
			assertTrue('collection contains "1"', collection.contains(1));
			assertEquals('collection contains the array', collection.toArray().toString(), "1,2,3,4,5,6,7");
			
			CollectionUtils.removeArrayFromCollection(array, collection);
			assertTrue('size of collection is zero again', collection.size() == 0);
			assertFalse('collection no longer contains "1"', collection.contains(1));
			CollectionUtils.addArrayToCollection(array, collection);
			CollectionUtils.removeArrayFromCollection([], collection);
			
			assertFalse('size of collection is not zero', collection.size() == 0);
			assertEquals('size of collection is 7', collection.size(), 7);
			assertTrue('collection contains "1"', collection.contains(1));
			assertEquals('collection contains the array', collection.toArray().toString(), "1,2,3,4,5,6,7");
		}

		public function testRemoveAll():void
		{
			var a:List = new ArrayList();
			var b:List = new LinkedList();
			
			assertTrue('a is empty', a.size() == 0);
			assertTrue('b is empty', b.size() == 0);
			
			CollectionUtils.addArrayToCollection([1,2,3,4], a);
			
			assertTrue('a contains 4 items', a.size() == 4);
			assertTrue('a contains "1"', a.contains(1));
			assertTrue('b contains 0 items', b.size() == 0);
			assertFalse('b does not contain "1"', b.contains(1));
			
			b.add(1);
			b.add(2);
			
			assertTrue('b contains 2 items', b.size() == 2);
			assertEquals('b contains "1" and "2"', b.toArray().toString(), "1,2");
			
			CollectionUtils.removeAll(b, a);
			
			assertFalse('a no longer contains 4 items', a.size() == 4);
			assertTrue('a contains 2 items', a.size() == 2);
			assertFalse('a no longer contains "1"', a.contains(1));
			assertFalse('a no longer contains "2"', a.contains(2));
			assertEquals('a now contains "3"and "4"', a.toArray().toString(), "3,4");
		}

		public function testCardinality():void
		{
			var collection:ArrayList = new ArrayList();
			
			assertEquals('size of collection is zero', collection.size(), 0);
			assertFalse('collection does not contain "1"', collection.contains(1));
			
			CollectionUtils.addArrayToCollection([1,2,3,4,5,6,7], collection);
			
			assertFalse('size of collection is not zero', collection.size() == 0);
			assertEquals('size of collection is 7', collection.size(), 7);
			assertTrue('collection contains "1"', collection.contains(1));
			assertEquals('collection contains the array', collection.toArray().toString(), "1,2,3,4,5,6,7");
			
			
			assertEquals('cardinality of -1 is 0', CollectionUtils.cardinality(-1, collection), 0);
			assertEquals('cardinality of 1 is 1', CollectionUtils.cardinality(1, collection), 1);
			assertEquals('cardinality of 3 is 1', CollectionUtils.cardinality(3, collection), 1);
			assertEquals('cardinality of 7 is 1', CollectionUtils.cardinality(7, collection), 1);
			
			CollectionUtils.addArrayToCollection([1,2,3,4,5,6,7], collection);
			
			assertEquals('cardinality of 1 is 2', CollectionUtils.cardinality(1, collection), 2);
			assertEquals('cardinality of 3 is 2', CollectionUtils.cardinality(3, collection), 2);
			assertEquals('cardinality of 7 is 2', CollectionUtils.cardinality(7, collection), 2);
			
			CollectionUtils.addArrayToCollection([9,9,9,9,9,9,9,9,9,9,9,9,9,9,9], collection);
			
			assertEquals('cardinality of 9 is 15', CollectionUtils.cardinality(9, collection), 15);
		}

		public function testSubstract():void
		{
			var a:List = new ArrayList();
			var b:List = new LinkedList();
			
			CollectionUtils.addArrayToCollection([1,2,3,4,5,6,7], a);
			
			assertEquals('returned contains the same size as collection', CollectionUtils.substract(a, b).size(), a.size());
			assertEquals('returned contains the same as collection', CollectionUtils.substract(a, b).toArray().toString(), a.toArray().toString());
			
			b.add(1);
			
			assertFalse('returned no longer contains the same as collection', CollectionUtils.substract(a, b).toArray().toString() == a.toArray().toString());
			assertEquals('returned is the right collection', CollectionUtils.substract(a, b).toArray().toString(), '2,3,4,5,6,7');
			
			CollectionUtils.addArrayToCollection([2,3,4,5,6,7], b);
			
			assertEquals('returned is now an empty collection', CollectionUtils.substract(a, b).size(), 0);
			
			a.clear();
			b.clear();
			CollectionUtils.addArrayToCollection([0,0,1,1,2,2,3,3,4,4], a);
			CollectionUtils.addArrayToCollection([0,1,2,3,4], b);
			
			assertEquals('returned is substracted correctly 1/2', CollectionUtils.substract(a, b).toArray().toString(), '0,1,2,3,4');
			
			CollectionUtils.addArrayToCollection([1,2,2,3,3,3,4,4,4,4], a);
			a.sort(Comparators.compareIntegers);
			
			assertEquals('returned is substracted correctly 2/2', CollectionUtils.substract(a, b).toArray().toString(), '0,1,1,2,2,2,3,3,3,3,4,4,4,4,4');
			
			
		}
		
		public function testRetainAll():void
		{
			var a:List = new ArrayList();
			var b:List = new LinkedList();
			
			CollectionUtils.addArrayToCollection([1,2,3,4,5,6,7], a);
			
			assertEquals('returned contains nothing', CollectionUtils.retainAll(a,b).size(), 0);
			
			b.add(1);
			assertEquals('returned contains 1 item', CollectionUtils.retainAll(a, b).size(), 1);
			assertEquals('returned contains "1"', CollectionUtils.retainAll(a, b).toArray().toString(), "1");
			
			b.add(3);
			b.add(5);
			b.add(7);
			
			assertEquals('returned contains 4 items', CollectionUtils.retainAll(a, b).size(), 4);
			assertTrue('returned contains "1"', CollectionUtils.retainAll(a, b).contains(1));
			assertTrue('returned contains "3"', CollectionUtils.retainAll(a, b).contains(3));
			assertEquals('returned returns the right list', CollectionUtils.retainAll(a, b).toArray().toString(), "1,3,5,7");
			
			var c:Heap = new Heap(Comparators.compareIntegers);
			a.reverse();
			CollectionUtils.addArrayToCollection([7,6,5,4,3,2,1], c);
			a.add(999);
			c.add(999);
			
			assertEquals('returned a/c contains 8 items', CollectionUtils.retainAll(a, c).size(), 8);
			assertTrue('returned a/c contains "999"', CollectionUtils.retainAll(a, c).contains(999));
			assertTrue('returned a/c contains "3"', CollectionUtils.retainAll(a, c).contains(3));
			assertEquals('returned a/c returns the right list', CollectionUtils.retainAll(a, c).toArray().toString(), "7,6,5,4,3,2,1,999");
			
			//duplicates
			a.add(999);
			a.add(999);
			a.add(999);
			
			var retained:ICollection = CollectionUtils.retainAll(a, c);
			assertEquals('returned a/c contains 11 items', retained.size(), 11);
			assertTrue('returned a/c contains "999"', retained.contains(999));
			assertEquals('returned a/c contains "999" four times', CollectionUtils.cardinality(999, retained), 4);
			assertTrue('returned a/c contains "3"', retained.contains(3));
			assertEquals('returned a/c returns the right list', retained.toArray().toString(), "7,6,5,4,3,2,1,999,999,999,999");
		}
		
		public function testEquals():void
		{
			var a:List = new ArrayList();
			var b:List = new LinkedList();
			
			assertTrue('equals returns boolean', CollectionUtils.equals(a, b) is Boolean);
			CollectionUtils.addArrayToCollection([1,2], a);
			CollectionUtils.addArrayToCollection([2,1], b);
			assertTrue('a equals b', CollectionUtils.equals(a, b));
			assertFalse('a does not equal new', CollectionUtils.equals(a, new ArrayList()));
			CollectionUtils.addArrayToCollection([3,4], b);
			assertFalse('a does not equal b', CollectionUtils.equals(a, b));
			CollectionUtils.addArrayToCollection([4,3,2], a);
			assertFalse('a is larger than b', CollectionUtils.equals(a, b));
			a.remove(2);
			assertTrue('a equals b', CollectionUtils.equals(a, b));
			
			var c:Heap = new Heap(Comparators.compareIntegers);
			assertFalse('a does not equal c', CollectionUtils.equals(a, c));
			assertFalse('b does not equal c', CollectionUtils.equals(b, c));
			c.add(1);
			c.add(2);
			assertFalse('a does not equal c', CollectionUtils.equals(a, c));
			assertFalse('b does not equal c', CollectionUtils.equals(b, c));
			c.add(3);
			assertFalse('a does not equal c', CollectionUtils.equals(a, c));
			assertFalse('b does not equal c', CollectionUtils.equals(b, c));
			c.add(4);
			assertTrue('a equals c', CollectionUtils.equals(a, c));
			assertTrue('b equals c', CollectionUtils.equals(b, c));
		}
		
		public function testMerge():void
		{
			var a:List = new ArrayList();
			var b:List = new ArrayList();
			
			a.add(1);
			a.add(2);
			a.add(3);
			a.add(4);
			b.add(5);
			b.add(6);
			b.add(7);
			b.add(8);
			
			assertEquals('a contains the right items', a.toArray().toString(), "1,2,3,4");
			assertEquals('b contains the right items', b.toArray().toString(), "5,6,7,8");
			
			var c:List = CollectionUtils.merge(a, b) as List;
			
			assertTrue('c is a List ', c is List);
			assertEquals('c contains 8 items', c.size(), 8);
			assertEquals('order of c is as expected', c.toArray().toString(), "1,2,3,4,5,6,7,8");
			
			a.add(5);
			a.add(6);
			b.add(3);
			b.add(4);
			
			c = CollectionUtils.merge(a, b) as List;
			
			assertTrue('c is a List ', c is List);
			assertEquals('c contains 8 items', c.size(), 8);
			assertEquals('c contains items only once', c.toArray().toString(), "1,2,5,6,7,8,3,4");
			
			a.clear();
			b.clear();
			
			a.add(1);
			a.add(2);
			a.add(3);
			a.add(4);
			a.add(5);
			a.add(5);
			b.add(5);
			b.add(6);
			b.add(7);
			b.add(8);
			
			c = CollectionUtils.merge(a, b) as List;
			
			assertEquals('c contains 9 items', c.size(), 9);
			assertEquals('c contains number 5 twice, others once', c.toArray().toString(), "1,2,3,4,5,5,6,7,8");
		}
		
		public function testAddIfNotNull():void
		{
			var a:List = new LinkedList();
			assertTrue('added item "1"', CollectionUtils.addIfNotNull(a, "1"));
			assertEquals('a contains 1 item', a.size(), 1);
			assertEquals('a contains the right item', a.toArray().toString(), "1");
			assertFalse('cannot add null item', CollectionUtils.addIfNotNull(a, null));
			assertEquals('a still contains 1 item', a.size(), 1);
			assertEquals('a still contains 1 item', a.toArray().toString(), "1");
			assertFalse('cannot add to null collection', CollectionUtils.addIfNotNull(null, 1));
			assertFalse('cannot add null item to null collection', CollectionUtils.addIfNotNull(null, null));
			
		}
	}
}
