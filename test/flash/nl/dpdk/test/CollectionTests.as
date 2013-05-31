package nl.dpdk.test 
{
	import asunit.framework.TestSuite;

	import nl.dpdk.collections.ArrayListTest;
	import nl.dpdk.collections.BinarySearchTreeTest;
	import nl.dpdk.collections.BinaryTreeNodeTest;
	import nl.dpdk.collections.ComparatorsTest;
	import nl.dpdk.collections.HashMapTest;
	import nl.dpdk.collections.HeapTest;
	import nl.dpdk.collections.IteratorTest;
	import nl.dpdk.collections.LinkedListTest;
	import nl.dpdk.collections.OrderedListTest;
	import nl.dpdk.collections.PQTest;
	import nl.dpdk.collections.ResultSetTest;
	import nl.dpdk.collections.SetTest;
	import nl.dpdk.collections.TreeNodeTest;
	import nl.dpdk.collections.graphs.GraphTest;
	import nl.dpdk.collections.graphs.ShortestPathTest;
	public class CollectionTests extends TestSuite 
	{
		/**
		 * Constructor which adds all available tests to the list.
		 */
		public function CollectionTests() 
		{	

			trace("CollectionTests.CollectionTests()");
			
			addTest(new ComparatorsTest());
			addTest(new IteratorTest());
			addTest(new ArrayListTest());
			addTest(new LinkedListTest());
			addTest(new BinaryTreeNodeTest());
			addTest(new BinarySearchTreeTest());
			addTest(new TreeNodeTest());
			addTest(new ResultSetTest());
			addTest(new SetTest());
			addTest(new OrderedListTest());
			addTest(new HeapTest());
			addTest(new PQTest());
			addTest(new GraphTest());
			addTest(new ShortestPathTest());
			addTest(new HashMapTest());
		}
	}
}
