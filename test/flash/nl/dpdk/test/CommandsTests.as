package nl.dpdk.test 
{
	import nl.dpdk.commands.FrameDelayTaskTest;
	import asunit.framework.TestSuite;

	import nl.dpdk.commands.CallbackTaskTest;
	import nl.dpdk.commands.CommandTest;
	import nl.dpdk.commands.ErrorTaskTest;
	import nl.dpdk.commands.SequenceTest;
	import nl.dpdk.commands.TaskTest;

	public class CommandsTests extends TestSuite 
	{
		/**
		 * Constructor which adds all available tests to the list.
		 */
		public function CommandsTests() 
		{	
			trace("CommandsTests.CommandsTests()");
			
			addTest(new CommandTest());
			
			addTest(new TaskTest());
			addTest(new CallbackTaskTest());
			addTest(new ErrorTaskTest());
			addTest(new FrameDelayTaskTest());
			
//			addTest(new SequenceTest());
		}
	}
}