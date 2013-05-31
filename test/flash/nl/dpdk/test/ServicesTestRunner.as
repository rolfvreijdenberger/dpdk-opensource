package nl.dpdk.test
{
	import asunit.textui.TestRunner;
	import asunit.textui.ResultPrinter;

	/**
	 * the dpdk testrunner, extends TestRunner so we can set some configuration in an easy way, 
	 * and we are added to the display list automatically since this class is the documentclass for flash
	 */
	
	// This SWF meta tag makes it possible to run this task from FDT and/or FlexBuilder.
	[SWF(width="550", height="400", backgroundColor="0x000000", frameRate="31")]
	public class ServicesTestRunner extends TestRunner 
	{
		public function ServicesTestRunner() 
		{
			var myPrinter:ResultPrinter = new ResultPrinter();
			myPrinter.setShowStackTrace(true);
			
			setPrinter(myPrinter);
			
			start(ServicesTest, null, TestRunner.SHOW_TRACE);
		}
	}
}
