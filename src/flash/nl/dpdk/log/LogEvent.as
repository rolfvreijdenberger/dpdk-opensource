/*
Copyright (c) 2008 De Pannekoek en De Kale B.V.,  www.dpdk.nl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
package nl.dpdk.log 
{
    import flash.events.Event;    
    
    /**
     * A LogEvent is dispatched by the Log class and contains the output that
     * has been logged by Log.
     * Register to this event through Log's public statc addListener method.
     * 
     * @see Log.addListener()
     * 
     * @author Thomas Brekelmans
     */
    final public class LogEvent extends Event
    {
        public static const LOG:String = "LogEvent_LOG";
        
		private var time:int;
		private var level:int;
		private var levelName:String;
		private var message:String;
		private var sender:String;

		/**
         * Creates a new LogEvent.
         * @param type The type of event that is created.
         * @param time The milliseconds that have been elapsed since the 
         * currently running application was started when this event was 
         * dispatched. 
         * @param level The level (severity) of the log.
         * @param levelName The name of the level (severity) of the log.
         * @param message The human readable message that was logged.
         * @param sender Metadata about the origin of the log (usually contains
         * the class name and method name in which the log was done).
         * @param bubbles Indicates whether or not this event bubbles.
         * @param cancelable Indicates whether or not the behavior associated 
         * with this event can be prevented.
         */
        public function LogEvent(type:String, time:int, level:int, levelName:String, 
      							                  message:String, sender:String, 
      					    bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
            
			this.time = time;
			this.level = level;
			this.levelName = levelName;
			this.message = message;
			this.sender = sender;
        }
        
        /**
         * Returns the milliseconds that have been elapsed since the 
         * currently running application was started when this event was 
         * dispatched.
         */
        public function getTime():int
		{
			return time;
		}
		
		/**
         * Returns the level (severity) of the log.
         */
		public function getLevel():int
		{
			return level;
		}
		
		/**
         * Returns the name of the level (severity) of the log.
         */
		public function getLevelName():String
		{
			return levelName;
		}
		
		/**
         * Returns the human readable message that was logged.
         */
		public function getMessage():String
		{
			return message;
		}
		
		/**
         * Returns metadata about the origin of the log (usually contains the 
         * class name and method name in which the log was done).
         */
		public function getSender():String
		{
			return sender;
		}
        
        /**
         * This function is needed for event-bubbling, it clones itself.
         */
        override public function clone():Event
        {
            return new LogEvent(type, time, level, levelName, message, sender, 
            					bubbles, cancelable);
        }

        /**
         * Returns a String representation of this class.
         */
        override public function toString():String
        {
            return formatToString("LogEvent", "type", "bubbles", "cancelable", 
            "eventPhase");
		}
	}
}