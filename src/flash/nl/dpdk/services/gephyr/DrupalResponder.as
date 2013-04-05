package nl.dpdk.services.gephyr 
{
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.Timer;

	/**
	 * Holds data in the remote calls' asynchronous lifetime
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	internal class DrupalResponder extends Responder 
	{
		//the service/method pair name
		private var name:String;
		private var resultHandler:Function;
		private var statusHandler:Function;
		private var timer:Timer;
		private var timeOutHandler:Function;
		private var invalidated:Boolean;
		private var remoteCallId:String;


		/**
		 * @param name the service/method pair for unique id-ing
		 * @param remoteCallId the remoteCallId for uniquely identifying your call when you get back the result from A call
		 */
		public function DrupalResponder(name:String, resultHandler:Function, statusHandler:Function,  timeOutHandler:Function = null, timeOut:int = 0, remoteCallId: String = "") 
		{
			//call the constructor on super, with handlers that are defined in this class
			super(onResult, onStatus);
			//store additional information we need when the handlers are called.
			this.remoteCallId = remoteCallId;
			this.name = name;
			this.statusHandler = statusHandler;
			this.resultHandler = resultHandler;
			this.invalidated = false;
			//if there is a timeout set..
			if(timeOut != 0) 
			{
				this.timeOutHandler = timeOutHandler;
				this.timer = new Timer(timeOut, 1);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
				this.timer.start();
			}	
		}

		private function onTimeOut(event:TimerEvent):void 
		{
			invalidated = true;
			timeOutHandler(name, timer.delay, remoteCallId);
		}

		private function stopTimer():void 
		{
			if(timer) 
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
			}
		}

		private function onResult(data:*):void 
		{
			stopTimer();
			if(!invalidated) 
			{
				resultHandler(name, data, remoteCallId);	
			}
			destroy();
		}

		private function onStatus(data:*):void 
		{
			stopTimer();
			if(!invalidated) 
			{
				statusHandler(name, data, remoteCallId);	
			}
			
			destroy();
		}

		public function toString():String
		{
			return "DrupalResponder";
		}
		
		private function destroy(): void{
			if(timer){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
				timer = null;
			}
			statusHandler = null;
			resultHandler = null;
			timeOutHandler = null;
		}
	}
}
