package nl.dpdk.test 
{
	import asunit.textui.ResultPrinter;
	import asunit.textui.TestRunner;
	
	// This SWF meta tag makes it possible to run this task from FDT and/or FlexBuilder.
	[SWF(width="550", height="400", backgroundColor="0x000000", frameRate="31")]
	public class LoaderTestRunner extends TestRunner 
	{
		public function LoaderTestRunner() 
		{
			var myPrinter:ResultPrinter = new ResultPrinter();
			myPrinter.setShowStackTrace(true);
			
			setPrinter(myPrinter);
			
			start(LoaderTests, null, TestRunner.SHOW_TRACE);
		}
	}
}
