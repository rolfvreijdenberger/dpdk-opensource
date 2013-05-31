package nl.dpdk.utils 
{
	import asunit.framework.TestCase;

	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.lists.LinkedList;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class FilterTest extends TestCase 
	{
		public function FilterTest(testMethod:String = null)
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
		}

		override protected function tearDown():void
		{
		}

		public function testAdd():void
		{
			var filter:Filter = new Filter();
			filter.add("shit");
			filter.add("fuck");
			filter.add("bitch");
			
			assertTrue(filter.contains("shit"));
			assertTrue(filter.contains("fuck"));
			assertTrue(filter.contains("bitch"));
			assertFalse(filter.contains("potverdikkie"));
		}

		public function testAddConstructor():void
		{
			var badWords:ICollection = new LinkedList();
			badWords.add("shit");
			badWords.add("fuck");
			badWords.add("bitch");
			
			var filter:Filter = new Filter(true, badWords);
			
			assertTrue(filter.contains("shit"));
			assertTrue(filter.contains("fuck"));
			assertTrue(filter.contains("bitch"));
			assertFalse(filter.contains("potverdikkie"));
		}

		public function testAddNotString():void
		{
			var filter:Filter = new Filter();
			
			var i:int = 1;
			var j:Number = 1;
			
			filter.add(i);
			filter.add(j);
			filter.add(new MovieClip());
			filter.add(new Date());
			filter.add(new BitmapData(1, 1));
			
			assertTrue(filter.isEmpty());
		}

		public function testAddCaseSensitive():void
		{
			var filter:Filter = new Filter(false);
			filter.add("shit");
			filter.add("Fuck");
			filter.add("Bitch");
			
			assertTrue(filter.contains("shit"));
			assertFalse(filter.contains("fuck"));
			assertFalse(filter.contains("bitch"));
		}

		public function testFilter():void
		{
			var filter:Filter = new Filter();
			filter.add("shit");
			filter.add("fuck");
			filter.add("bitch");
			
			var badLanguage:String = "Fuck that shit bitch";
			badLanguage = filter.filter(badLanguage);
			
			assertEquals(badLanguage, "**** that **** *****");
		}

		public function testFilterCaseSensitive():void
		{
			var filter:Filter = new Filter(false);
			filter.add("shit");
			filter.add("fuck");
			filter.add("bitch");
			
			var badLanguage:String = "Fuck that shit bitch";
			badLanguage = filter.filter(badLanguage);
			
			assertEquals(badLanguage, "Fuck that **** *****");
		}

		public function testFilterPunctuation():void
		{
			var filter:Filter = new Filter();
			filter.add("fuck");
			
			var badLanguage:String = "When things go wrong, people say: fuck!!!";
			badLanguage = filter.filter(badLanguage);
			
			assertEquals(badLanguage, "When things go wrong, people say: ****!!!");
		}

		public function testReplacementCharacter():void
		{
			var filter:Filter = new Filter();
			filter.add("shit");
			filter.add("fuck");
			filter.add("bitch");
			filter.setReplaceCharacter("x");
			
			var badLanguage:String = "Fuck that shit bitch";
			badLanguage = filter.filter(badLanguage);
			
			assertEquals(badLanguage, "xxxx that xxxx xxxxx");
		}
	}
}
