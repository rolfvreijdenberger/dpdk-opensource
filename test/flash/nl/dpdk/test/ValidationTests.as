package nl.dpdk.test 
{
	import asunit.framework.TestSuite;

	import nl.dpdk.validation.ValidationTest;

	/**
	 * @author Szenia Zadvornykh
	 */
	public class ValidationTests extends TestSuite 
	{
		public function ValidationTests()
		{
			addTest(new ValidationTest());

		}
	}
}