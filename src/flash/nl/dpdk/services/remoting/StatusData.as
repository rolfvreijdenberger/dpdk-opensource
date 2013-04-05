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
package nl.dpdk.services.remoting 
{

	/**
	 * Holds the status data from a remote call that failed for some reason.
	 * 
	 * 
	 * @author Thomas Brekelmans, Rolf Vreijdenberger
	 */
	public class StatusData 
	{
		private var description:String;
		private var details:String;
		private var level:String;
		private var line:Number;
		private var code:String;

		public function StatusData(description:String, details:String, level:String, line:Number, code:String) 
		{
			this.description = description;
			this.details = details;
			this.level = level;
			this.line = line;
			this.code = code;
		}

		public function getDescription():String 
		{
			return description;
		}

		public function getDetails():String 
		{
			return details;
		}

		/**
		 * this is the thing that we can really use to create custom error handling, or take alternative action on.
		 * THis is dependent on the type of amf backend implementation (eg: asp.NET, php etc.)
		 * Depending on the level (which is customizable on the server) we can handle this differently for each case (for instance, make another call to the server to find out more).
		 * In PHP: 
		 * <ul>
		 * <li>E_USER_ERROR (256)</li>
		 * <li>E_USER_WARNING (512)</li>
		 * <li>E_USER_NOTICE (1024)</li>
		 * </ul>
		 * TODO: do some research, at the moment this always seems to generate an AMFPHP_RUNTIME_ERROR for amfphp, which is probably baked in that framework.
		 */
		public function getLevel():String 
		{
			return level;
		}

		public function getLine():Number 
		{
			return line;
		}

		public function getCode():String 
		{
			return code;
		}

		public function toString():String 
		{
			return "StatusData [" + getCode() + "] level: " + getLevel() + " description: " + getDescription() + " " + getDetails() + " at line: " + getLine();
		}
	}
}