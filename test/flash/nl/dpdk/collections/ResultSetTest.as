package nl.dpdk.collections 
{
	
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.lists.LinkedList;
	import nl.dpdk.collections.sets.ResultRow;
	import nl.dpdk.collections.sets.ResultSet;	

	public class ResultSetTest extends TestCase {
			 //"normal"
			 assertEquals(list.size(), 10);
			 assertTrue(list.contains(0));
			 assertTrue(list.contains(9));
			 assertFalse(list.contains(10));
			 
			 
			 
			 list = instance.getColumnAt(-1);
			 assertTrue(list.isEmpty());
			 list = instance.getColumnAt(4);
			 assertTrue(list.isEmpty());
			 
			 list = instance.getColumnByName('multiplica');
			 assertTrue(list.isEmpty());
			 
			 list = instance.getColumnByName('multiplication');
			 assertFalse(list.isEmpty());
			 assertEquals(list.size(), 10);
			 assertTrue(list.contains(0));
			 assertTrue(list.contains(10));
			 assertTrue(list.contains(18));
			 assertFalse(list.contains(20));
			 
			 
			 
			 