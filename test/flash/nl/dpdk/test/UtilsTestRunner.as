package nl.dpdk.test 
{
	import asunit.textui.ResultPrinter;
	import asunit.textui.TestRunner;
	/**
	 * @author Szenia Zadvornykh
	 */
	[SWF(width="550", height="400", backgroundColor="0x000000", frameRate="31")]
	public class UtilsTestRunner extends TestRunner 
	{
		public function UtilsTestRunner()
		{
			var myPrinter:ResultPrinter = new ResultPrinter();
			myPrinter.setShowStackTrace(true);
			
			setPrinter(myPrinter);
			
			start(UtilsTests, null, TestRunner.SHOW_TRACE);
		}
	}
}
