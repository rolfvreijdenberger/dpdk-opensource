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
	import nl.dpdk.collections.sets.ResultSet;	

	/**
	 * Holds the result from a succesful remoting call.
	 * The data is untyped, so be sure you know what you will get when making calls to a server via flash remoting. (check the remote interface)
	 * <p><p>
	 * Ideally, a Factory should convert/map the data from the remote service into a domain object used in flash.
	 * <p>
	 * <code>
	 * //result is a ResultData object
	 * var user: User = UserFactory.create(result.getData());
	 * dispatchEvent(new UserEvent(UserEvent.NEW, user));
	 * </code>
	 * 
	 * @author Thomas Brekelmans, Rolf Vreijdenberger
	 */
	public class ResultData
	{
		private var data : *;

		public function ResultData(data : *)
		{
			this.data = data;
		}

		
		/**
		 * Get the result.
		 * 
		 * @return A primitive type, Array, Object or a ResultSet.
		 */
		public function getResult() : *
		{
			return data;
		} 

		
		/**
		 * Check whether or not we have a resultset as the result.
		 */
		public function isResultSet() : Boolean
		{
			return data is ResultSet;
		}

		
		public function toString() : String
		{
			return "ResultData";
		}
	}
}