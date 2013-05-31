package nl.dpdk.utils 
{
	import asunit.framework.TestCase;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class NumberUtilsTest extends TestCase 
	{
		public function NumberUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		public function testMapIndexToRange():void
		{
			assertEquals(NumberUtils.mapIndexToRange(5, 0, 6), 5);
			assertEquals(NumberUtils.mapIndexToRange(23, 0, 6), 2);
			
			assertEquals(NumberUtils.mapIndexToRange(5, -6, 0), -1);
			assertEquals(NumberUtils.mapIndexToRange(9, -6, 0), -4);
			
			assertEquals(NumberUtils.mapIndexToRange(5, 2, 8), 7);
			assertEquals(NumberUtils.mapIndexToRange(15, 2, 8), 3);
			
			assertEquals(NumberUtils.mapIndexToRange(4, -2, 4), 2);
			assertEquals(NumberUtils.mapIndexToRange(10, -2, 4), 1);
			
			assertEquals(NumberUtils.mapIndexToRange(190000000, -189999995, 10), 5);
			assertEquals(NumberUtils.mapIndexToRange(int.MAX_VALUE, 0, 1), 1);		//MAX_VALUE:int = 2147483647
		}

		public function testGetRandomBoolean():void
		{
			assertFalse(NumberUtils.getRandomBoolean(0));
			assertTrue(NumberUtils.getRandomBoolean(1));
		}

		public function testGetRandomSign():void
		{
			assertEquals(NumberUtils.getRandomSign(0), -1);
			assertEquals(NumberUtils.getRandomSign(1), 1);
		}

		public function testGetRandomBit():void
		{
			assertEquals(NumberUtils.getRandomBit(0), 0);
			assertEquals(NumberUtils.getRandomBit(1), 1);
		}

		public function testGetRandomNumberInRange():void
		{
			var min:Array = [0, -5, -15, 5, 5];
			var max:Array = [10, 5, -5, 15, 5];
			var random:Number;
			
			for (var i:int = 0;i < min.length;++i)
			{
				random = NumberUtils.getRandomNumberInRange(min[i], max[i]);
				assertTrue((random >= min[i] && random <= max[i]));
			}
		}

		public function testRandomFloat():void
		{
			var tolerance:Number = 0.001;
			
			assertEqualsFloat(NumberUtils.roundFloat(0.25, 0.1), 0.3, tolerance);
			assertEqualsFloat(NumberUtils.roundFloat(0.25, 1), 0, tolerance);
			assertEqualsFloat(NumberUtils.roundFloat(-0.26, 0.1), -0.3, tolerance);
			assertEqualsFloat(NumberUtils.roundFloat(0.50, 1), 1, tolerance);
			assertEqualsFloat(NumberUtils.roundFloat(0.55, 0.1), 0.6, tolerance);
			assertEqualsFloat(NumberUtils.roundFloat(-0.56, 0.1), -0.6, tolerance);
			assertEqualsFloat(NumberUtils.roundFloat(17, 10), 20, tolerance);
			assertEqualsFloat(NumberUtils.roundFloat(17, 0.1), 17, tolerance);
		}

		public function testFloorFloat():void
		{
			var tolerance:Number = 0.001;
			
			assertEqualsFloat(NumberUtils.floorFloat(0.25, 0.1), 0.2, tolerance);
			assertEqualsFloat(NumberUtils.floorFloat(0.25, 1), 0, tolerance);
			assertEqualsFloat(NumberUtils.floorFloat(-0.26, 0.1), -0.3, tolerance);
			assertEqualsFloat(NumberUtils.floorFloat(0.50, 1), 0, tolerance);
			assertEqualsFloat(NumberUtils.floorFloat(0.55, 0.1), 0.5, tolerance);
			assertEqualsFloat(NumberUtils.floorFloat(-0.56, 0.1), -0.6, tolerance);
			assertEqualsFloat(NumberUtils.floorFloat(17, 10), 10, tolerance);
		}

		public function testCeilFloat():void
		{
			var tolerance:Number = 0.001;
			
			assertEqualsFloat(NumberUtils.ceilFloat(0.25, 0.1), 0.3, tolerance);
			assertEqualsFloat(NumberUtils.ceilFloat(0.25, 1), 1, tolerance);
			assertEqualsFloat(NumberUtils.ceilFloat(-0.26, 0.1), -0.2, tolerance);
			assertEqualsFloat(NumberUtils.ceilFloat(0.50, 1), 1, tolerance);
			assertEqualsFloat(NumberUtils.ceilFloat(0.55, 0.1), 0.6, tolerance);
			assertEqualsFloat(NumberUtils.ceilFloat(-0.56, 0.1), -0.5, tolerance);
			assertEqualsFloat(NumberUtils.ceilFloat(17, 10), 20, tolerance);
		}

		public function testGetNormalizedValue():void
		{
			assertEquals(NumberUtils.getNormalizedValue(0, -5, 5), 0.5);
			assertEquals(NumberUtils.getNormalizedValue(300, 0, 300), 1);
			assertEquals(NumberUtils.getNormalizedValue(-1.75, -5, 1.5), 0.5);
			assertEqualsFloat(NumberUtils.getNormalizedValue(10000, -20000, 30000), 3 / 5, 0.001);
		}

		public function testGetPercentageValue():void
		{
			assertEquals(NumberUtils.getPercentageValue(0.5, 0, 100), 50);
			assertEquals(NumberUtils.getPercentageValue(0.5, 0, 1000), 500);
		}
	}
}
