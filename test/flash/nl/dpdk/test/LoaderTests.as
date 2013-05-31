package nl.dpdk.test 
{
	import asunit.framework.TestSuite;

	import nl.dpdk.loader.ComparatorTest;
	import nl.dpdk.loader.LoaderTest;
	import nl.dpdk.loader.MultiThreadedLoaderTest;
	public class LoaderTests extends TestSuite 
	{
		public function LoaderTests() 
		{	
			trace("LoaderTests.LoaderTests()");
			
			addTest(new ComparatorTest());	
			addTest(new MultiThreadedLoaderTest());	
//			addTest(new LoaderTest());	
		}
	}
}