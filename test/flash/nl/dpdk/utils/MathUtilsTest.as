package nl.dpdk.utils 
{
	import asunit.framework.TestCase;

	import flash.utils.ByteArray;
	/**
	 * @author Peter Schmidt
	 */
	public class MathUtilsTest extends TestCase 
	{
		public function MathUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
		}

		override protected function tearDown():void
		{
		}

		public function testGetHexFromBytes():void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes("This is a string, which is about to be converted to a byteArray.");
			assertEquals("54686973206973206120737472696e672c2077686963682069732061626f757420746f20626520636f6e76657274656420746f2061206279746541727261792e", MathUtils.getHexadecimalStringFromBytes(bytes));
			
			bytes.clear();
			bytes.writeUnsignedInt(0xFF00FFFF);
			assertEquals("ff00ffff", MathUtils.getHexadecimalStringFromBytes(bytes));
			
			bytes.clear();
			assertTrue("length is zero", bytes.length == 0);
			bytes.writeInt(int.MAX_VALUE);
			assertEquals("bytes match int", MathUtils.getHexadecimalStringFromBytes(bytes), "7fffffff");
		}
	}
}
