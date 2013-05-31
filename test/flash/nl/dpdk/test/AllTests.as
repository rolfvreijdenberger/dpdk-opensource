package nl.dpdk.test 
{
	import asunit.framework.TestSuite;

	import nl.dpdk.specifications.SpecificationTests;
	/**
	 * runs all the tests that are added here.
	 * this should run all of the testing methods of the nl.dpdk package
	 * once a test is completed of new functionality, add to the package and add to the main (this) testsuite
	 */
	public class AllTests extends TestSuite 
	{
		/**
		 * Constructor which adds all available tests to the list.
		 */
		public function AllTests() 
		{	
			trace("AllTests.AllTests()");
			
			addTest(new CollectionTests());
			addTest(new CommandsTests());
			addTest(new LoaderTests());
			addTest(new ServicesTest());
			addTest(new SpecificationTests());
			addTest(new UtilsTests());
		}
	}
}
