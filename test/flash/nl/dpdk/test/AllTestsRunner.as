package nl.dpdk.test {
	import asunit.textui.ResultPrinter;
	import asunit.textui.TestRunner;	

	/**
	 * the dpdk testrunner, extends TestRunner so we can set some configuration in an easy way, 
	 * and we are added to the display list automatically since this class is the documentclass for flash
	 */
	 
	// This SWF meta tag makes it possible to run this task from FDT and/or FlexBuilder.
	[SWF(width="550", height="400", backgroundColor="0x000000", frameRate="31")]
	public class AllTestsRunner extends TestRunner 
	{
		public function AllTestsRunner() 
		{
			var myPrinter:ResultPrinter = new ResultPrinter();
			myPrinter.setShowStackTrace(true);
			
			setPrinter(myPrinter);
			
			start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}
}
