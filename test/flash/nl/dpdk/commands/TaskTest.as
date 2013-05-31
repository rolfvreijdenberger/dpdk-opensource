package nl.dpdk.commands 
{
	import asunit.framework.TestCase;

	import nl.dpdk.commands.tasks.Task;

	/**
	 * @author Thomas Brekelmans
	 */
	public class TaskTest extends TestCase
	{
		private var task:Task;

		public function TaskTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
			task = new Task();
		}

		override protected function tearDown():void
		{
			task.destroy();
			task = null;
		}

		public function testATask():void
		{
			assertTrue(task);
		}
		
		public function testBTaskToString():void
		{
			assertEquals(task.toString(), "Task");
		}
	}
}
