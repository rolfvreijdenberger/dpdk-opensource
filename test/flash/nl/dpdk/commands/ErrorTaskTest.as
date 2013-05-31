package nl.dpdk.commands 
{
	import nl.dpdk.commands.tasks.TaskEvent;
	import asunit.framework.TestCase;

	import nl.dpdk.commands.tasks.ErrorTask;

	/**
	 * @author Thomas Brekelmans
	 */
	public class ErrorTaskTest extends TestCase 
	{
		private var errorTask:ErrorTask;
		
		public function ErrorTaskTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
			errorTask = new ErrorTask();
		}
		
		override protected function tearDown():void
		{
			errorTask.destroy();
			errorTask = null;
		}

		public function testAErrorTask():void
		{
			assertTrue(errorTask);
		}
		
		public function testBToString():void
		{
			assertEquals(errorTask.toString(), "ErrorTask");
		}
		
		public function testCExecute():void
		{
			errorTask.addEventListener(TaskEvent.ERROR, addAsync(errorHandler, 30));
			errorTask.execute();
		}

		private function errorHandler(e:TaskEvent):void
		{
			assertTrue(e.getTask() == errorTask)
		}
	}
}
