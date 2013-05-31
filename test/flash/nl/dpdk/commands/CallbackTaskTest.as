package nl.dpdk.commands 
{
	import nl.dpdk.commands.tasks.CallbackTask;
	import asunit.framework.TestCase;

	/**
	 * @author Thomas Brekelmans
	 */
	public class CallbackTaskTest extends TestCase 
	{
		private var callBackTask:CallbackTask;
		
		public function CallbackTaskTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
			// cannot use setUp for instantiation since the instance has to 
			// be configured differently for each individual test in this TestCase
		}
		
		override protected function tearDown():void
		{
			callBackTask.destroy();
			callBackTask = null;
		}

		public function testACallBackTask():void
		{
			callBackTask = new CallbackTask(callbackTestHelper);
			assertTrue(callBackTask);
		}
		
		public function testBToString():void
		{
			callBackTask = new CallbackTask(callbackTestHelper);
			assertEquals(callBackTask.toString(), "CallBackTask");
		}
		
		public function testCExecute():void
		{
			callBackTask = new CallbackTask(addAsync(callbackTestHelper, 30));
			callBackTask.execute();
		}

		private function callbackTestHelper():void
		{
			trace("CallbackTaskTest.callbackTestHelper()");
		}
	}
}
