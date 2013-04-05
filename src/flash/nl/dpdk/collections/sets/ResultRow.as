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

package nl.dpdk.collections.sets {

	/**
	 * A ResultRow is a dynamic class that holds properties that will be dynamically set.
	 * The ResultRow is used as a row in a ResultSet.
	 * <p>
	 * We don't have ResultRow extend proxy. this would make it slower to access and manipulate.
	 * It would give us more information about the ResultRow and would allow dynamic acces like 'getSomeDynamicProperty' to be redirected to 'someDynamicProperty' through naming convention.
	 * Since we have an explicit contract with the server and this still won't give us type safety, we just do not use proxy.
	 * @see ResultSet
	 * @author Rolf Vreijdenberger
	 */
	public dynamic class ResultRow extends Object {
		/**
		 * an id that can be used to keep the initial ordering in a ResultSet as it was created.
		 * When we decide to sort the resultset, we can sort it back again to it's original state by sorting on the __id in the resultrow.
		 * underscore prefixed variable names suck, but this is done to prevent conflicts with other peoples's naming schemes.
		 * If a clash occurs, your naming scheme sucks :) who uses _id anyway?
		 */
		private var __id:int;
		private static var _id: int = 0;
		
		/**
		 * The constructor.
		 */
		public function ResultRow() {
			__id = _id++;
		}
		
		/**
		 * the internal id for the resultrow.
		 * The id's increment for each and every ResultRow that is created.
		 * When a resultset is created from flash remoting, the resultset will always use incrementing id's.
		 * Therefore we can use the id to preserve the original (server side) order.
		 */
		public function getId():int{
			return __id;	
		}
	}
}
