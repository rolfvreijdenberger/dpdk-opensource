package nl.dpdk.utils 
{
	import asunit.framework.TestCase;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class StringUtilsTest extends TestCase 
	{
		private var url:String = "www.dpdk.nl";
		private var alphabet:String = "abcdefghijklmnopqrstuvwxyz";
		private var sentence:String = "Testing is fun.";
				
		public function StringUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}
		
		public function testContains():void
		{
			assertTrue(StringUtils.contains(url, "."));
			assertTrue(StringUtils.contains(url, "nl"));
			assertFalse(StringUtils.contains(url, "a"));
			assertFalse(StringUtils.contains(url, "DPDK"));
		}
		
		public function testContainsCaseInSensitive():void
		{
			assertTrue(StringUtils.containsCaseInSensitive(url, "."));
			assertTrue(StringUtils.containsCaseInSensitive(url, "nl"));
			assertTrue(StringUtils.containsCaseInSensitive(url, "DPDK"));
			assertTrue(StringUtils.containsCaseInSensitive("wWw.DpDk.Nl", "DPDK"));
		}
		
		public function testGenerateRandomString():void
		{
			var random:String = StringUtils.generateRandomString(alphabet, 5);
			
			assertEquals(random.length, 5);
			assertFalse(StringUtils.contains(random, "A"));
			assertFalse(StringUtils.contains(random, "1"));
		}

		public function testPrefixWithZeroIfUnderTen():void
		{
			assertTrue(StringUtils.prefixWithZeroWhenUnderTen(5) == "05");
			assertTrue(StringUtils.prefixWithZeroWhenUnderTen(20) == "20");
			assertTrue(StringUtils.prefixWithZeroWhenUnderTen(-5) == "-5");
		}
		
		public function testPrefixStringWithZeroIfUnderTen():void
		{
			assertTrue(StringUtils.prefixStringWithZeroWhenUnderTen("5") == "05");
			assertTrue(StringUtils.prefixStringWithZeroWhenUnderTen("20") == "20");
			assertTrue(StringUtils.prefixStringWithZeroWhenUnderTen("-5") == "-5");
		}
		
		public function testAfterFirst():void
		{
			assertTrue(StringUtils.afterFirst(url, ".") == "dpdk.nl");
			assertFalse(StringUtils.afterFirst(url, ".") == "nl");
			assertFalse(StringUtils.afterFirst(alphabet, "."));
		}
		
		public function testAfterLast():void
		{
			assertTrue(StringUtils.afterLast(url, ".") == "nl");
			assertFalse(StringUtils.afterLast(url, ".") == "dpdk.nl");
			assertFalse(StringUtils.afterLast(alphabet, "."));
		}
		
		public function testBetween():void
		{
			assertTrue(StringUtils.between(url, ".", ".") == "dpdk");
			assertTrue(StringUtils.between(alphabet, "a", "f") == "bcde");
			assertFalse(StringUtils.between(alphabet, "z", "a"));
		}
		
		public function testBlock():void
		{
			var chunks:Array = StringUtils.block(url, 5);
			
			assertEquals(chunks[0], "www.");
			assertEquals(chunks[1], "dpdk.");
			assertEquals(chunks[2], "nl");
		}

		public function testBlockLenght():void
		{
			var chunks:Array = StringUtils.block(url, 4);
			
			assertEquals(chunks[0], "www.");
			assertEquals(chunks[1], "d...");
			assertEquals(chunks[2], "nl");
			
//			var chunks:Array = StringUtils.block("help.adobe.com/en_US/AS3LCR/Flash_10_0/index.html",5);
		}

		public function testBlockDelimiter():void
		{
			var chunks:Array = StringUtils.block("M*A*S*H", 2, "*");
			
			assertEquals(chunks[0], "M*");
			assertEquals(chunks[1], "A*");
			assertEquals(chunks[2], "S*");
			assertEquals(chunks[3], "H");
		}
		
		public function testHasText():void
		{
			assertTrue(StringUtils.hasText(sentence));
		}
		
		public function testIsEmpty():void
		{
			assertTrue(StringUtils.isEmpty(""));
			assertFalse(StringUtils.isEmpty(sentence));
		}
	}
}
