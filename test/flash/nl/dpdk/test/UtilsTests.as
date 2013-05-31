package nl.dpdk.test 
{
	import nl.dpdk.utils.MathUtilsTest;

	import asunit.framework.TestSuite;

	import nl.dpdk.utils.ArrayUtilsTest;
	import nl.dpdk.utils.CollectionUtilsTest;
	import nl.dpdk.utils.DateUtilsTest;
	import nl.dpdk.utils.DisplayUtilsTest;
	import nl.dpdk.utils.FilterTest;
	import nl.dpdk.utils.NumberUtilsTest;
	import nl.dpdk.utils.ResizeUtilsTest;
	import nl.dpdk.utils.StringUtilsTest;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class UtilsTests extends TestSuite 
	{
		public function UtilsTests()
		{
			addTest(new ArrayUtilsTest());
			addTest(new CollectionUtilsTest());
			addTest(new DateUtilsTest());
			addTest(new DisplayUtilsTest());
			addTest(new FilterTest());
			addTest(new MathUtilsTest());
			addTest(new NumberUtilsTest());
			addTest(new ResizeUtilsTest());
			addTest(new StringUtilsTest());
		}
	}
}
