/*
Copyright (c) 2009 De Pannekoek en De Kale B.V.,  www.dpdk.nl

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
package nl.dpdk.loader {
	import nl.dpdk.collections.lists.PriorityQueueNode;
	import nl.dpdk.collections.sorting.SortOrder;

	/**
	 * Custom comparator for the PriorityQueue in the LoaderManager.
	 * 
	 * <p>Checks which loader should have the highest priority.
	 * Active loaders are always favored over inactive loaders.
	 * It doesn't matter if the inactive loader has a higher priority. It's inactive, so not important.</p> 
	 * 
	 * @author Thomas Brekelmans
	 */
	final internal class Comparator 
	{
		/**
		 * Checks which loader should have the highest priority.
		 * Active loaders are always favored over inactive loaders.
		 * It doesn't matter if the inactive loader has a higher priority. It's inactive, so not important. 
		 */
		public static function compareLoaders(nodeA:PriorityQueueNode, nodeB:PriorityQueueNode):int
		{
			var loaderA:Loader = nodeA.getData();
			var loaderB:Loader = nodeB.getData();
			
			if (loaderA.getIsActive() == false && loaderB.getIsActive() == true)
			{
				return SortOrder.LESS;
			}
			else if (loaderA.getIsActive() == true && loaderB.getIsActive() == false)
			{
				return SortOrder.LARGER;
			}
			else if (loaderA.getIsActive() == false && loaderB.getIsActive() == false)
			{
				return SortOrder.EQUAL;
			}
			else
			{
				if (nodeA.getPriority() < nodeB.getPriority())
				{
					return SortOrder.LESS;
				}
				else if (nodeA.getPriority() > nodeB.getPriority())
				{
					return SortOrder.LARGER;
				}
				else
				{
					return SortOrder.EQUAL;
				}
			}
		}
	}
}
