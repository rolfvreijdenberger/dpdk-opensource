package nl.dpdk.commands 
{
	import nl.dpdk.commands.tasks.SequenceEvent;
	import nl.dpdk.commands.tasks.CallbackTask;
	import asunit.framework.TestCase;

	import nl.dpdk.commands.tasks.Sequence;
	import nl.dpdk.commands.tasks.TimeDelayTask;

	/**
	 * @author Thomas Brekelmans
	 */
	public class SequenceTest extends TestCase
	{
		private var sequence:Sequence;
		
		private var firstTask:TimeDelayTask;
		private var secondTask:TimeDelayTask;
		private var thirdTask:TimeDelayTask;
		private var thirdCallBackCheck:CallbackTask;

		public function SequenceTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		override protected function setUp():void
		{
		}

		override protected function tearDown():void
		{
		}

		public function testASequence():void
		{
			sequence = new Sequence();
			assertTrue(sequence);
			
			sequence.destroy();
			sequence = null;
		}

		public function testBToString():void
		{
			sequence = new Sequence();
			assertEquals(sequence.toString(), "Sequence");
			
			sequence.destroy();
			sequence = null;
		}

		public function testCAddRemoveSizeContains():void
		{
			sequence = new Sequence();
			
			firstTask = new TimeDelayTask();
			secondTask = new TimeDelayTask();
			thirdTask = new TimeDelayTask();
			
			assertEquals(sequence.size(), 0);
			
			sequence.add(firstTask);
			sequence.add(secondTask);
			sequence.add(thirdTask);
			
			assertTrue(sequence.contains(secondTask));
			
			assertEquals(sequence.size(), 3);
			
			assertTrue(sequence.remove(firstTask));
			assertTrue(sequence.remove(secondTask));
			
			assertFalse(sequence.contains(secondTask));
			
			assertEquals(sequence.size(), 1);
			
			sequence.destroy();
			sequence = null;
		}
		
		public function testDGetTasks():void
		{
			sequence = new Sequence();
			
			firstTask = new TimeDelayTask();
			secondTask = new TimeDelayTask();
			thirdTask = new TimeDelayTask();
			
			var loneTask:TimeDelayTask = new TimeDelayTask();
			
			assertEquals(sequence.getTasks().size(), 0);
			
			sequence.add(firstTask);
			sequence.add(secondTask);
			sequence.add(thirdTask);
			
			assertEquals(sequence.getTasks().size(), 3);
			
			assertTrue(sequence.getTasks().contains(firstTask));
			assertFalse(sequence.getTasks().contains(loneTask));
			
			sequence.destroy();
			sequence = null;
		}
		
		public function testEExecute():void
		{
			sequence = new Sequence();
			
			assertFalse(sequence.isExecuting());
			
			firstTask = new TimeDelayTask(500);
			var firstCallBackCheck:CallbackTask = new CallbackTask(addAsync(firstCallBackCheckHelper, 530));
			secondTask = new TimeDelayTask(1000);
			var secondCallBackCheck:CallbackTask = new CallbackTask(addAsync(secondCallBackCheckHelper, 1560));
			thirdTask = new TimeDelayTask(1500);
			thirdCallBackCheck = new CallbackTask(addAsync(thirdCallBackCheckHelper, 3090));
			
			sequence.add(firstTask);
			sequence.add(firstCallBackCheck);
			sequence.add(secondTask);
			sequence.add(secondCallBackCheck);
			sequence.add(thirdTask);
			sequence.add(thirdCallBackCheck);
			
			sequence.addEventListener(SequenceEvent.START, addAsync(sequenceStartHandler, 50));
			sequence.addEventListener(SequenceEvent.NEXT, sequenceNextHandler);
			sequence.addEventListener(SequenceEvent.DONE, addAsync(sequenceDoneHandler, 2200));
			
			sequence.execute();
		}
		
		private function firstCallBackCheckHelper():void
		{
		}
		private function secondCallBackCheckHelper():void
		{
		}
		private function thirdCallBackCheckHelper():void
		{
		}
		
		private function sequenceStartHandler(event:SequenceEvent):void
		{
			assertEquals(sequence.getCurrent(), null);
			assertEquals(event.getTask(), null);
		}

		private function sequenceNextHandler(event:SequenceEvent):void
		{
		}
		private function sequenceDoneHandler(event:SequenceEvent):void
		{
			assertEquals(sequence.getCurrent(), thirdCallBackCheck);
			assertEquals(event.getTask(), null);
			
			sequence.destroy();
			sequence = null;
		}
	}
}
