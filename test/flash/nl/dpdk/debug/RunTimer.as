package nl.dpdk.debug {
	import flash.utils.getTimer;		
	/**
	 * testing class to get simple benchmark times.
	 * @author Rolf Vreijdenberger
	 */
	public class RunTimer {
		private static var runtimeStart:int;
		private static var runtimeStop:int;
		
		/**
		 * call for beginning the timer
		 */
		public static function start():void{
				runtimeStart = getTimer();
		}
		
		/**
		 * stop the timer
		 */
		public static function stop():void{
				runtimeStop = getTimer() ;
		}
		
		/**
		 * gets the r
		 */
		public static function getRunTime(doStop:Boolean = true):int{
			if(doStop) stop();
			return 	runtimeStop - runtimeStart;
		}
		
		//call to output the runtime in a trace
		public static function traceRunTime(message: String = "", doStop:Boolean = true):void{
			trace("[Runtime: " + getRunTime(doStop) + ' ms] '+ message );
		}
	}
}
