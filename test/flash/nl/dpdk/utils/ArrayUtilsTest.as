package nl.dpdk.utils 
{
	import asunit.framework.TestCase;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class ArrayUtilsTest extends TestCase 
	{
		public function ArrayUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
		}

		override protected function tearDown():void
		{
		}

		public function testContains():void
		{
			trace("ArrayUtilsTest.testContains()");
			var array:Array = new Array();
			array.push(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
			
			assertTrue("array contains 0", ArrayUtils.contains(array, 0));
			assertTrue("array contains 1", ArrayUtils.contains(array, 1));
			assertTrue("array contains 2", ArrayUtils.contains(array, 2));
			assertFalse("array doesn't contain 20", ArrayUtils.contains(array, 20));
			assertFalse("array doesn't contain 'something'", ArrayUtils.contains(array, "something"));
			assertFalse("array doesn't contain null", ArrayUtils.contains(array, null));
		}

		public function testExchange():void
		{
			trace("ArrayUtilsTest.testExchange()");
			var array:Array = new Array();
			array.push(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);

			assertEquals("first position equals value 0", array[0], 0);
			assertEquals("last position equals value 9", array[9], 9);
			assertEquals("array has a length of 10", array.length, 10);
			
			ArrayUtils.exchange(array, 0, 9);
			
			assertTrue("first position isn't 0", array[0] != 0);
			assertTrue("last position isn't 9", array[9] != 9);
			
			assertEquals("first position now equals 9", array[0], 9);
			assertEquals("last position now equals 0", array[9], 0);
			assertEquals("second position still equals 1", array[1], 1);			
			assertEquals("third position still equals 2", array[2], 2);			
			assertEquals("fourth position still equals 3", array[3], 3);
			assertEquals("array still has a length of 10", array.length, 10);			
		}
	}
}
