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

package nl.dpdk.collections.lists 
{

	/**
	 * PriorityQueueNode acts as a wrapper for data that needs to have a Priority on it.
	 * As such it holds a reference to the data that it prioritizes.
	 * It can be used with a PriorityQueue.
	 * An interface was not chosen to work with a PriorityQueue, as we do not want to clutter the domain object with priority based code, which would happen if we need to implement an interface on a domain object. 
	 * This means a client needs to work with PriorityQueueNode instances, but this gives us all kinds of pleasant things like:
	 * <ul>
	 * <li>direct access to a Node to remove in constant time, instead of a linear lookup on a Heap</li>
	 * <li>changing of priorities at runtime where we can reprioritize the node, instead of the whole heap.</li>
	 * </ul>
	 * <p><p>
	 * An alternative, if you do not want to work with PriorityQueueNode, is to just directly use Heap as a PriorityQueue.
	 * The tradeoff is that this will give you a little less behaviour.
	 * @see PriorityQueue
	 * @see Heap
	 * @author Rolf Vreijdenberger
	 */
	public class PriorityQueueNode
	{
		private var data : *;
		private var priority : Number;
		public static const PRIORITY_DEFAULT : Number = 1;

		/**
		 * 
		 */
		public function PriorityQueueNode(priority : Number, data : * = null)
		{
			setData(data);
			setPriority(priority);
		}

		
		public function getPriority() : Number
		{
			return priority;
		}

		
		public function setPriority(priority : Number) : void
		{
			this.priority = priority;
		}

		
		public function getData() : *
		{
			return data;
		}

		
		public function setData(data : *) : void
		{
			this.data = data;
		}

		
		public function toString() : String
		{
			return "PriorityQueueNode with priority " + getPriority() + " and data " + getData();	
		}
	}
}
