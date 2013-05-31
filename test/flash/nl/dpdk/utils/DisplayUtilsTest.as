package nl.dpdk.utils 
{
	import asunit.framework.TestCase;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class DisplayUtilsTest extends TestCase 
	{
		private var parent:DisplayObjectContainer;

		public function DisplayUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
			parent = new Sprite();
			
			for (var i:int = 0;i < 10;++i)
			{
				var child:DisplayObject = new Sprite();
				
				child.name = "child" + i;
				parent.addChild(child);			
			}
		}

		override protected function tearDown():void
		{
			parent = null;
		}

		public function testRemoveAllChildren():void
		{
			DisplayUtils.removeAllChildren(parent);
			
			assertEquals(parent.numChildren, 0);
		}

		public function testSetToTopIndex():void
		{
			var child:DisplayObject = parent.getChildAt(0);
			DisplayUtils.setToTopIndex(child);
			
			assertEquals(parent.getChildIndex(child), parent.numChildren - 1);
		}

		public function testSetToBottomIndex():void
		{
			var child:DisplayObject = parent.getChildAt(parent.numChildren - 1);
			DisplayUtils.setToBottomIndex(child);
			
			assertEquals(parent.getChildIndex(child), 0);
		}

		public function testRemoveChild():void
		{
			var child:DisplayObject = parent.getChildAt(parent.numChildren - 1);
			assertEquals(child, DisplayUtils.removeChild(parent, child));
			assertFalse(parent.contains(child));
			
			var newChild:DisplayObject = new Sprite();
			assertFalse(parent.contains(newChild));
			assertNull(DisplayUtils.removeChild(parent, newChild));
		}
	}
}
