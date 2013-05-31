package nl.dpdk.loader 
{
	import asunit.framework.TestCase;

	import nl.dpdk.collections.dictionary.HashMap;
	import nl.dpdk.collections.lists.LinkedList;
	import nl.dpdk.commands.CallbackCommand;
	import nl.dpdk.loader.events.LoaderEvent;
	import nl.dpdk.loader.events.LoaderItemEvent;
	import nl.dpdk.loader.events.LoaderProgressEvent;
	import nl.dpdk.utils.CollectionUtils;
	/**
	 * @author Szenia Zadvornykh
	 * 
	 * because the old loader test did not support the new multithreaded design, this new test was written
	 * it covers the same base as the old test
	 */
	public class MultiThreadedLoaderTest extends TestCase 
	{
		private var loaderA:Loader;
		private var asynchAssertions:LinkedList;
		private var loaderB:Loader;
		private var asyncHandlerStore:Function;
		private var urlToDataMap:HashMap;

		public function MultiThreadedLoaderTest(testMethod:String = null)
		{
			super(testMethod);
		}
		
		override protected function setUp():void
		{
			loaderA = new Loader();
			
			loaderA.add("http://www.dpdk.nl/opensource/files/images/dpdk_header.jpg", {name: "first header image"});
			loaderA.add("http://www.dpdk.nl/opensource/files/images/dpdk_header.png", {name: "second header image"});
			loaderA.add("http://www.dpdk.nl/opensource/files/images/background.gif", {name: "large background"});
			loaderA.add("http://www.dpdk.nl/opensource/files/movieclip/dpdk_header.swf", {name: "header, swf style"});
			loaderA.add("http://www.dpdk.nl/opensource/files/sound/blank.mp3", {name: "listen, it's just silent"});
			loaderA.add("http://www.dpdk.nl/opensource/files/text/test.txt", {name: "simple text file"});
			loaderA.add("http://www.dpdk.nl/opensource/files/video/dpdk_header.flv", {name: "header flv"});
			loaderA.add("http://www.dpdk.nl/opensource/files/xml/test.xml", {name: "something random"});
		}
		
		override protected function tearDown():void
		{
			loaderA.destroy();
			loaderA = null;
		}
		
		public function testAddSizeContains():void
		{
			loaderA = new Loader();
			
			assertEquals(loaderA.size(), 0);
			
			loaderA.add("http://www.fake.nl/test.swf");
			loaderA.add("http://www.fake.nl/test.mp3");
			loaderA.add("http://www.fake.nl/test.jpg");
			
			assertEquals(loaderA.size(), 3);
			assertTrue(loaderA.contains("http://www.fake.nl/test.jpg"));
			assertFalse(loaderA.contains("http://www.fake.nl/doesntexist.jpg"));
		}

		public function testDefaultValues():void
		{
			loaderA = new Loader();
			
			assertFalse("loader getIsActive() default setting is false", loaderA.getIsActive());
			assertFalse("loader getIsPaused() default setting is false", loaderA.getIsPaused());
			assertEquals("contentsize is zero", loaderA.getContentSize(), 0);
			assertEquals("priority is Priorities.NORMAL (3)", loaderA.getPriority(), Priorities.NORMAL);
			assertTrue("progress is NaN", isNaN(loaderA.getProgress()));
		}

		public function testDataBinding():void
		{
			urlToDataMap = new HashMap();
			asynchAssertions = new LinkedList();

			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/images/dpdk_header.jpg", {name: "first header image"});
			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/images/dpdk_header.png", {name: "second header image"});
			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/images/background.gif", {name: "large background"});
			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/movieclip/dpdk_header.swf", {name: "header, swf style"});
			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/sound/blank.mp3", {name: "listen, it's just silent"});
			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/text/test.txt", {name: "simple text file"});
			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/video/dpdk_header.flv", {name: "header flv"});
			urlToDataMap.insert("http://www.dpdk.nl/opensource/files/xml/test.xml", {name: "something random"});
			
			loaderA.addEventListener(LoaderItemEvent.DONE, dataBindingLoaderItemDoneHandler);

			asyncHandlerStore = addAsync(dataBindingLoaderDoneHandler, 5000);
			loaderA.addEventListener(LoaderEvent.DONE, asyncHandlerStore);
			
			loaderA.execute();
			loaderA.pause();
			loaderA.resume();
		}
		
		private function dataBindingLoaderItemDoneHandler(event:LoaderItemEvent):void
		{
			//if an assertion fails outside a test function, it is not caught by the framework and causes a runtime error
			//by creating a callback command here, and executing it in the asych handler for the test, this behaviour is circumvented,
			//and any errors are printed in the result screen as normal. woohoo.
			asynchAssertions.add(new CallbackCommand(assertEquals, "loaded asset has the proper name", urlToDataMap.search(event.getUrl()).name, event.getData().name));
		}

		private function dataBindingLoaderDoneHandler(event:LoaderEvent):void
		{
			loaderA.removeEventListener(LoaderEvent.DONE, asyncHandlerStore);
			loaderA.removeEventListener(LoaderItemEvent.DONE, dataBindingLoaderItemDoneHandler);
			
			//all assertions are made here, see dataBindingLoaderItemDoneHandler
			CollectionUtils.callMethod(asynchAssertions, "execute");
			assertEquals("loader is empty when done", loaderA.size(), 0);
			
			asynchAssertions.clear();
			asynchAssertions = null;
		}
		
		public function testLoadingDone():void
		{
			asyncHandlerStore = addAsync(loadingDoneLoaderDoneHandler, 2000);
			loaderA.addEventListener(LoaderEvent.DONE, asyncHandlerStore);
			
			loaderA.execute();
		}

		private function loadingDoneLoaderDoneHandler(event:LoaderEvent):void 
		{
			loaderA.removeEventListener(LoaderEvent.DONE, asyncHandlerStore);
			
			assertFalse(loaderA.getIsActive());
			assertEquals(0, loaderA.size());
		}
		
		public function testPauseResume():void
		{
			loaderA.execute();
			
			assertFalse(loaderA.getIsPaused());
			assertTrue(loaderA.getIsActive());
			
			loaderA.pause();
			
			assertTrue(loaderA.getIsPaused());
			assertFalse(loaderA.getIsActive());
			
			loaderA.resume();
			
			assertFalse(loaderA.getIsPaused());
			assertTrue(loaderA.getIsActive());
		}

		public function testPriority():void
		{
			loaderB = new Loader(Priorities.HIGH);
			asynchAssertions = new LinkedList();
			
			loaderB.add("http://www.dpdk.nl/opensource/files/images/dpdk_header.jpg", {name: "first header image"});
			loaderB.add("http://www.dpdk.nl/opensource/files/images/dpdk_header.png", {name: "second header image"});
			loaderB.add("http://www.dpdk.nl/opensource/files/images/background.gif", {name: "large background"});
			loaderB.add("http://www.dpdk.nl/opensource/files/movieclip/dpdk_header.swf", {name: "header, swf style"});
			loaderB.add("http://www.dpdk.nl/opensource/files/sound/blank.mp3", {name: "listen, it's just silent"});
			loaderB.add("http://www.dpdk.nl/opensource/files/text/test.txt", {name: "simple text file"});
			loaderB.add("http://www.dpdk.nl/opensource/files/video/dpdk_header.flv", {name: "header flv"});
			loaderB.add("http://www.dpdk.nl/opensource/files/xml/test.xml", {name: "something random"});
			
			loaderB.addEventListener(LoaderEvent.DONE, priorityLoaderBDoneHandler);

			asyncHandlerStore = addAsync(priorityLoaderADoneHandler, 5000);
			loaderA.addEventListener(LoaderEvent.DONE, asyncHandlerStore);
			
			loaderA.execute();
			loaderB.execute();
		}
		
		private function priorityLoaderBDoneHandler(event:LoaderEvent):void
		{
			//the number of files loaded by the low prio loader at this point depends on number of threads
			asynchAssertions.add(new CallbackCommand(assertEquals, loaderA.size(), 8 - loaderA.getTotalFilesLoaded()));
			asynchAssertions.add(new CallbackCommand(assertEquals, loaderB.size(), 0));
			asynchAssertions.add(new CallbackCommand(assertTrue, loaderA.getIsActive()));
			asynchAssertions.add(new CallbackCommand(assertFalse, loaderB.getIsActive()));
		}

		private function priorityLoaderADoneHandler(event:LoaderEvent):void
		{
			CollectionUtils.callMethod(asynchAssertions, "execute");
			
			assertEquals(loaderA.size(), 0);
			assertEquals(loaderB.size(), 0);
			
			assertFalse(loaderA.getIsActive());
			assertFalse(loaderA.getIsActive());
		}

		public function testProgress():void
		{
			//total size of files in the loader is 823178 + 160913 + 19021 + 111294 + 19021 + 6433 + 11591 + 127 + 273 = 1151851;
			loaderA.setContentSize(1151851);
			loaderA.addEventListener(LoaderProgressEvent.PROGRESS, progressLoaderProgressHandler);
			
			asyncHandlerStore = addAsync(progressLoaderDoneHandler, 2000);
			loaderA.addEventListener(LoaderEvent.DONE, asyncHandlerStore);
			
			loaderA.execute();
		}
		
		private function progressLoaderProgressHandler(event:LoaderProgressEvent):void
		{
			//i dont see any way to make assertions about progress, so it is just traced here.
			trace(event.getProgress());
		}

		private function progressLoaderDoneHandler(event:LoaderEvent):void
		{
			assertEquals(loaderA.getProgressOfFiles(), 1);
		}
	}
}
