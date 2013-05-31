package nl.dpdk.utils 
{
	import asunit.framework.TestCase;

	import flash.display.MovieClip;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class ResizeUtilsTest extends TestCase 
	{
		private var movieClip:MovieClip;
		
		public function ResizeUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
			movieClip = new MovieClip();
			movieClip.graphics.beginFill(0x000000);
			movieClip.graphics.drawRect(0, 0, 500, 250);
			movieClip.graphics.endFill();			
		}

		override protected function tearDown():void
		{
			movieClip.graphics.clear();
			movieClip = null;
		}

		public function testResizeToRatioSmaller():void
		{
			ResizeUtils.resizeToRatio(movieClip, 250, 500);
			
			assertEquals("w: ", movieClip.width, 1000);
			assertEquals("h: ", movieClip.height, 500);
		}
		
		public function testResizeToRatioEqual():void
		{
			ResizeUtils.resizeToRatio(movieClip, 2000, 1000);
			
			assertEquals("w: ", movieClip.width, 2000);
			assertEquals("h: ", movieClip.height, 1000);
		}
		
		public function testResizeToRatioGreater():void
		{
			ResizeUtils.resizeToRatio(movieClip, 500, 200);
			
			assertEquals("w: ", movieClip.width, 500);
			assertEquals("h: ", movieClip.height, 250);
		}
		
		//desired width > desired height
		public function testResizeToFitKeepingRatioSmaller():void
		{
			ResizeUtils.resizeToFitKeepingRatio(movieClip, 100, 200);
			
			assertEquals("w: ", movieClip.width, 100);
			assertEquals("h: ", movieClip.height, 50);
		}

		//desired width == desiredHeight
		public function testResizeToFitKeepingRatioEqual():void
		{
			ResizeUtils.resizeToFitKeepingRatio(movieClip, 100, 100);
			
			assertEquals("w: ", movieClip.width, 100);
			assertEquals("h: ", movieClip.height, 50);
		}
		
		//desired width < desired height
		public function testResizeToFitKeepingRatioGreater():void
		{
			ResizeUtils.resizeToFitKeepingRatio(movieClip, 300, 100);
			
			assertEquals("w: ", movieClip.width, 200);
			assertEquals("h: ", movieClip.height, 100);
		}
		
		public function testResizeToRatioWithinBoundariesSmaller():void
		{
			ResizeUtils.resizeToRatioWithinBoundaries(movieClip, 250, 500);

			assertEquals("w: ", movieClip.width, 250);
			assertEquals("h: ", movieClip.height, 125);
		}

		public function testResizeToRatioWithinBoundariesEqual():void
		{
			ResizeUtils.resizeToRatioWithinBoundaries(movieClip, 1000, 500);

			assertEquals("w: ", movieClip.width, 1000);
			assertEquals("h: ", movieClip.height, 500);
		}

		public function testResizeToRatioWithinBoundariesGreater():void
		{
			ResizeUtils.resizeToRatioWithinBoundaries(movieClip, 500, 200);

			assertEquals("w: ", movieClip.width, 400);
			assertEquals("h: ", movieClip.height, 200);
		}
	}
}
