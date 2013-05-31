package nl.dpdk.test 
{
	import asunit.framework.TestSuite;

	import nl.dpdk.services.fms.FMSServiceTest;
	public class ServicesTest extends TestSuite 
	{
		/**
		 * Constructor which adds all available test to the list.
		 */
		public function ServicesTest() 
		{	

//			addTest(new RemotingTest());
			addTest(new FMSServiceTest());
		}
	}
}
