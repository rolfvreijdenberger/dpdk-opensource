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
    import flash.events.EventDispatcher;
    import flash.utils.getTimer;    

    /**
     * Log is a mainly static class which is used to provide the developer 
     * and/or the user of your application with information about the state
     * in which the application resides.
     * Log provides six different levels to indicate the severity and nature of
     * the logged information. Log can be configured to execute only logs with
     * a level equal to or higher than the configured level.
     * Log should be used as a replacement to the default trace statement.
     * Log can be configured to execute or not to execute trace statements and
     * to filter logs with a certain level.
     * 
     * @author Thomas Brekelmans, Rolf Vreijdenberger
     */
    public class Log extends EventDispatcher 
    {
        public static const LEVEL_DEBUG:int = 1;
        public static const LEVEL_INFO:int = 2;
        public static const LEVEL_STATUS:int = 3;
        public static const LEVEL_WARN:int = 4;
        public static const LEVEL_ERROR:int = 5;
        public static const LEVEL_FATAL:int = 6;
        
        /**
         * This holds the unique instance of Log which is used under the hood.
         */
        private static var instance:Log;
        
        // This names need to correspond with the LEVEL_* constants.
        // "debug" should be resolvable to LEVEL_DEBUG, etc.
        private static const LEVEL_DEBUG_NAME:String = "debug";        private static const LEVEL_INFO_NAME:String = "info";        private static const LEVEL_STATUS_NAME:String = "status";        private static const LEVEL_WARN_NAME:String = "warn";        private static const LEVEL_ERROR_NAME:String = "error";
        private static const LEVEL_FATAL_NAME:String = "fatal";
        private var level:int = Log.LEVEL_DEBUG;        private var isTraceEnabled:Boolean = true;        private var isTimeDisplayed:Boolean = true;

        /**
         * Creates a new Log.
         * This class shouldn't be instantiated directly.
         * @param preventOutsideInstantiation This constructor has a required
         * argument of type Enforcer (which is an internal class inside Log's
         * class file) to prevent it from being instantiated outside the class
         * file.
         */
        public function Log(preventOutsideInstantiation:Enforcer) 
        {	
        }

        
        private static function getInstance():Log 
        {
            if (instance == null) 
            {
                instance = new Log(new Enforcer());	
            }	
            return instance;
        }

        
        /**
         * Returns the current minimum output level that a log should have 
         * before it is outputted. The default value is Log.LEVEL_DEBUG (i.e. 
         * all logs are executed).
         * @see Log.LEVEL_* constants.
         */
        public static function getLevel():int 
        {
            return Log.getInstance().level; 
        }

        
        /**
         * Sets the minimum output level to a given int. The default value is
         * Log.LEVEL_DEBUG (i.e. all logs are executed).
         * @param level The minimum output level that a log should have before
         * it is outputted. Use the Log.LEVEL_* constants. 
         */
        public static function setLevel(level:int):void 
        {
            Log.getInstance().level = level; 
        }

        
        /**
         * Returns whether or not each log that is above or equal to the log 
         * level is traced. The default value is true.
         */
        public static function getIsTraceEnabled():Boolean 
        {
            return Log.getInstance().isTraceEnabled; 
        }

        
        /**
         * Sets whether or not each log that is above or equal to the log level
         * is traced. The default value is true.
         * @param isTraceEnabled Whether or not trace is invoked in a log.
         */
        public static function setIsTraceEnabled(isTraceEnabled:Boolean):void 
        {
            Log.getInstance().isTraceEnabled = isTraceEnabled; 
        }

        
        /**
         * Returns whether or not to prepend each log output with the 
         * milliseconds that have been elapsed since the currently running 
         * application was started. The default value is true.
         */
        public static function getIsTimeDisplayed():Boolean 
        {
            return Log.getInstance().isTimeDisplayed; 
        }

        
        /**
         * Sets whether or not to prepend each log output with the milliseconds
         * that have been elapsed since the currently running application was 
         * started. The default value is true.
         * @param isTimeDisplayed Whether or not the time is prepended in a log.
         */
        public static function setIsTimeDisplayed(isTimeDisplayed:Boolean):void 
        {
            Log.getInstance().isTimeDisplayed = isTimeDisplayed; 
        }

        
        /**
         * Adds an event listener for the LogEvent.LOG event that is dispatched
         * during each log that is above or equal to the log level.
         * @param listener The method that is invoked when the LogEvent.LOG is
         * dispatched/
         */
        public static function addListener(listener:Function):void 
        {
            Log.getInstance().addEventListener(LogEvent.LOG, listener);
        }

        
        /**
         * Removes the event listener for the given listener.
         * @param listener The method whose event listener should be removed.
         */
        public static function removeListener(listener:Function):void 
        {
            Log.getInstance().removeEventListener(LogEvent.LOG, listener);
        }

        
        /**
         * Log a message from a given sender with the debug log level.
         * @param message A human readable message that is outputted.
         * @param sender Metadata about the origin of the log (usually contains
         * the class name and method name in which the log was done).
         */
        public static function debug(message:String, sender:String):void 
        {
            Log.output(Log.LEVEL_DEBUG_NAME, message, sender);	
        }

        
        /**
         * Log a message from a given sender with the info log level.
         * @param message A human readable message that is outputted.
         * @param sender Metadata about the origin of the log (usually contains the class name and method name in which the log was done).
         */
        public static function info(message:String, sender:String):void 
        {
            Log.output(Log.LEVEL_INFO_NAME, message, sender);
        }

        
        /**
         * Log a message from a given sender with the status log level.
         * @param message A human readable message that is outputted.
         * @param sender Metadata about the origin of the log (usually contains
         * the class name and method name in which the log was done).
         */
        public static function status(message:String, sender:String):void 
        {
            Log.output(Log.LEVEL_STATUS_NAME, message, sender);   
        }

        
        /**
         * Log a message from a given sender with the warn log level.
         * @param message A human readable message that is outputted.
         * @param sender Metadata about the origin of the log (usually contains
         * the class name and method name in which the log was done).
         */
        public static function warn(message:String, sender:String):void 
        {
            Log.output(Log.LEVEL_WARN_NAME, message, sender);   
        }

        
        /**
         * Log a message from a given sender with the error log level.
         * @param message A human readable message that is outputted.
         * @param sender Metadata about the origin of the log (usually contains
         * the class name and method name in which the log was done).
         */
        public static function error(message:String, sender:String):void 
        {
            Log.output(Log.LEVEL_ERROR_NAME, message, sender);
        }

        
        /**
         * Log a message from a given sender with the fatal log level.
         * @param message A human readable message that is outputted.
         * @param sender Metadata about the origin of the log (usually contains
         * the class name and method name in which the log was done).
         */
        public static function fatal(message:String, sender:String):void 
        {
            Log.output(Log.LEVEL_FATAL_NAME, message, sender);
        }

        
        private static function output(levelName:String, message:String, 
                                       sender:String):void 
        {
            var targetLevel:int = Log["LEVEL_" + levelName.toUpperCase()];
            if (targetLevel >= Log.getInstance().level) 
            {
                if (Log.getInstance().isTraceEnabled == true) 
                {
                    var output:String = "";
					
                    if (Log.getInstance().isTimeDisplayed == true) 
                    {
                        output += "[" + getTimer() + "] ";
                    }
                    output += "(" + levelName + ") ";
                
                    output += sender + " " + message;
                
                    trace(output);
                }
        		
                var logEvent:LogEvent = new LogEvent(LogEvent.LOG, getTimer(), 
                                                    targetLevel, levelName, message, sender);
                Log.getInstance().dispatchEvent(logEvent);
            }
        }
    }
}

internal class Enforcer 
{
}