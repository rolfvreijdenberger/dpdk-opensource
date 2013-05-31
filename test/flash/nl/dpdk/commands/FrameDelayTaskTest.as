package nl.dpdk.commands 
{
	import asunit.framework.TestCase;

	import nl.dpdk.commands.tasks.FrameDelayTask;
	import nl.dpdk.commands.tasks.TaskEvent;

	/**
	 * @author Thomas Brekelmans
	 */
	public class FrameDelayTaskTest extends TestCase 
	{
		private var frameDelayTask:FrameDelayTask;
		
		private var framesToDelay:uint;

		public function FrameDelayTaskTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
			framesToDelay = 3;
			
			frameDelayTask = new FrameDelayTask(framesToDelay);
		}
		
		override protected function tearDown():void
		{
			frameDelayTask.destroy();
			frameDelayTask = null;
		}

		public function testAFrameDelayTask():void
		{
			assertTrue(frameDelayTask);
		}
		
		public function testBToString():void
		{
			assertEquals(frameDelayTask.toString(), "FrameDelayTask");
		}
		
		public function testCExecute():void
		{
			// frameRate == 31 > ms/frame == 1000/31
			// tiemout duration =  ms/frame * frames to delay
			var timeout:int = (1000 / 31) * framesToDelay;
			// + buffer
			timeout += 50;
			frameDelayTask.addEventListener(TaskEvent.DONE, addAsync(doneHandler, timeout));
			frameDelayTask.execute();
		}

		private function doneHandler(e:TaskEvent):void
		{
			assertTrue(e.getTask() == frameDelayTask);
		}
	}
}
