package nl.dpdk.collections {
	import nl.dpdk.collections.CollectionTest;
	import nl.dpdk.collections.dictionary.HashMap;
	import nl.dpdk.debug.RunTimer;
	
	import flash.utils.Dictionary;		

	/**
	 * @author Rolf Vreijdenberger
	 */
	public class HashMapTest extends CollectionTest {
		private var instance : HashMap;

		public function HashMapTest(testMethod : String = null) {
			super(testMethod);
		}

		/**
		 * this method sets up all stuff we need before we run the test
		 */
		protected override function setUp() : void {
			instance = new HashMap();
		}

		public function testBenchmark() : void {
			trace("HashMapTest.testBenchmark() result: objects are about 3 times faster on insertion, lookup and removal. Dictionary about the same as Object, only slightly faster for insertion. Associative array about the same as object and dictionary");
			var i : int;
			var j : int;
			var word : String;
			var key : String
			var index : int;
			var l : int;
			var o : Object;
			var d: Dictionary;
			var a: Array;
			
			l = 50000;
			instance = new HashMap(100);
			o = new Object();
			d = new Dictionary();
			a = new Array();
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				instance.insert(key, word);
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.insert", true);
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				o[key] = word;
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an o[key] = value", true);
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				d[key] = word;
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an d[key] = value", true);
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				a[key] = word;
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an a[key] = value", true);


			
			
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				instance.search(key);
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.search", true);
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				o[key];
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an o[key]", true);
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				d[key];
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an d[key]", true);
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				a[key];
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an a[key]", true);
			
			
			
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				instance.remove(key);
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.remove", true);
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				o[key] = null;
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an o[key] = null", true);
				RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				d[key] = null;
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an d[key] = null", true);
				RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				a[key] = null;
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an a[key] = null", true);

		}

		public function testInsertRemove() : void {
			trace("HashMapTest.testInsertRemove()");
			var i : int;
			var j : int;
			var word : String;
			var key : String
			var index : int;
			var l : int;
			
			l = 1000;
			instance = new HashMap(100);
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				assertTrue("inserting: " + key, instance.insert(key, word));
				assertTrue(instance.contains(word));
				assertEquals(instance.search(key), word);
				assertEquals('test for size and expansion', instance.size(), i + 1);
			}
			assertTrue(!instance.isEmpty());
			assertEquals(instance.size(), l);
			
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				assertTrue('still contains ' + word, instance.contains(word));
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.contains", true);
			
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				assertTrue('still finds ' + key, instance.search(key));
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.search", true);
			
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				assertTrue('removing: ' + key, instance.remove(key));
				assertFalse('still contains ' + word, instance.contains(word));
				assertEquals('still finds ' + key, instance.search(key), null);
			}
			assertTrue('empty after removing all', instance.isEmpty());
			assertEquals('size 0 after removing all', instance.size(), 0);
			
			
			
			
			
			
			
			
			
			l = 500;
			RunTimer.start();
			instance = new HashMap(100);
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				assertTrue("inserting: " + key, instance.insert(key, word));
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.insert", true);
			assertTrue(!instance.isEmpty());
			assertEquals(instance.size(), l);
			
			
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				assertTrue('still finds ' + key, instance.search(key));
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.search", true);
			
			RunTimer.start();
			for(i = 0;i < l;++i) {
				key = alphabet + i;
				word = key + "_" + i;
				assertTrue('removing: ' + key, instance.remove(key));
			}
			RunTimer.traceRunTime("after " + l + " loops and doing an instance.remove", true);
			assertTrue('empty after removing all', instance.isEmpty());
			assertEquals('size 0 after removing all', instance.size(), 0);
		}

		public function testSizeClearContainsSearch() : void {
			trace("HashMapTest.testSizeClearContainsSearch()");
			instance = new HashMap(5);	
			assertEquals(instance.size(), 0);
			instance.insert("a", "aa");
			assertEquals(instance.size(), 1);
			assertTrue(instance.contains("aa"));
			assertFalse(instance.contains("a"));
			instance.clear();
			assertEquals(instance.size(), 0);
			assertFalse(instance.contains("a"));
			assertFalse(instance.contains("aa"));
			
			instance.clear();
			instance.insert("a", "b");
			assertEquals(instance.size(), 1);
			assertTrue(instance.contains("b"));
			assertFalse(instance.contains("c"));
			instance.insert("a", "c");
			assertEquals(instance.size(), 1);
			assertTrue(instance.contains("c"));
			assertFalse(instance.contains("b"));
			instance.insert("b", "b");
			assertTrue(instance.contains("c"));
			assertTrue(instance.contains("b"));
			assertEquals(instance.size(), 2);
			instance.remove("b");
			assertTrue(instance.contains("c"));
			assertFalse(instance.contains("b"));
			assertEquals(instance.size(), 1);
			instance.insert("b", "b");
			assertTrue(instance.contains("c"));
			assertTrue(instance.contains("b"));
			assertEquals(instance.size(), 2);
			
			assertEquals(instance.search("b"), "b");
			assertEquals(instance.search("a"), "c");
			
			instance.insert("x", "xyz");
			assertEquals(instance.search("b"), "b");
			assertEquals(instance.search("a"), "c");
			assertEquals(instance.search("x"), "xyz");
			assertEquals(instance.size(), 3);
			instance.insert("xy", "xyzy");
			assertEquals(instance.search("b"), "b");
			assertEquals(instance.search("a"), "c");
			assertEquals(instance.search("x"), "xyz");
			assertEquals(instance.search("xy"), "xyzy");
			assertEquals(instance.size(), 4);
			assertTrue(instance.contains("c"));
			assertTrue(instance.contains("b"));
			assertTrue(instance.contains("xyz"));
			assertTrue(instance.contains("xyzy"));
			
			assertTrue(instance.remove("x"));
			assertEquals(instance.size(), 3);
			assertTrue(instance.contains("c"));
			assertTrue(instance.contains("b"));
			assertFalse(instance.contains("xyz"));
			assertTrue(instance.contains("xyzy"));
			
			assertTrue(instance.remove("xy"));
			assertEquals(instance.size(), 2);
			assertTrue(instance.contains("c"));
			assertTrue(instance.contains("b"));
			assertFalse(instance.contains("xyz"));
			assertFalse(instance.contains("xyzy"));	
			
			assertTrue(instance.remove("a"));
			assertEquals(instance.size(), 1);
			assertFalse(instance.contains("c"));
			assertTrue(instance.contains("b"));
			assertFalse(instance.contains("xyz"));
			assertFalse(instance.contains("xyzy"));
			
			assertTrue(instance.remove("b"));
			assertEquals(instance.size(), 0);
			assertFalse(instance.contains("c"));
			assertFalse(instance.contains("b"));
			assertFalse(instance.contains("xyz"));
			assertFalse(instance.contains("xyzy"));
		}

		public function testHashMethod() : void {
			trace("HashMapTest.testHashMethod()");
			
			var i : int;
			var j : int;
			var word : String;
			var index : int;
			var l : int;
			
			l = 10;
			instance = new HashMap(l);
			for(i = 0;i < 1000;++i) {
				word = "";
				for(j = 0;j < 20;++j ) {
					word += alphabet.charAt(Math.floor(Math.random() * alphabetLength)); 
				}
				index = instance.hash(word, l);
				//trace("word: " + word + ", index: " + index);
				assertTrue(index >= 0 && index < l);
			}
			//trace("%%%%%%%%%%%%%%%%%%%%");
			//trace("$$$$$$$$$$$$$$$$$$$$");
			//trace("%%%%%%%%%%%%%%%%%%%%");

			
			
			l = 100;
			instance = new HashMap(l);
			for(i = 0;i < 1000;++i) {
				word = "";
				for(j = 0;j < 20;++j ) {
					word += alphabet.charAt(Math.floor(Math.random() * alphabetLength)); 
				}
				index = instance.hash(word, l);
				//trace("word: " + word + ", index: " + index);
				assertTrue(index >= 0 && index < l);
			}
			
			//trace("%%%%%%%%%%%%%%%%%%%%");
			//trace("$$$$$$$$$$$$$$$$$$$$");
			//trace("%%%%%%%%%%%%%%%%%%%%");

			l = 1000;
			instance = new HashMap(l);
			for(i = 0;i < 1000;++i) {
				word = "";
				for(j = 0;j < 20;++j ) {
					word += alphabet.charAt(Math.floor(Math.random() * alphabetLength)); 
				}
				index = instance.hash(word, l);
				//trace("word: " + word + ", index: " + index);
				assertTrue(index >= 0 && index < l);
			}
		}

		
		/**
		 *	use to remove all stuff not needed after this test
		 */
		protected override function tearDown() : void {
			instance = null;
		}

		public function testInstantiated() : void {
			trace("HashMapTest.testInstantiated()");
		}
	}
}
