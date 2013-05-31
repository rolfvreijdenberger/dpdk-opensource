package nl.dpdk.test 
{
	import asunit.textui.ResultPrinter;
	import asunit.textui.TestRunner;
	/**
	 * @author Szenia Zadvornykh
	 */
	[SWF(width="550", height="400", backgroundColor="0x000000", frameRate="31")]
	public class ValidationTestRunner extends TestRunner 
	{
		public function ValidationTestRunner()
		{
			var myPrinter:ResultPrinter = new ResultPrinter();
			myPrinter.setShowStackTrace(true);
			
			setPrinter(myPrinter);
			
			start(ValidationTests, null, TestRunner.SHOW_TRACE);
		}
	}
}
