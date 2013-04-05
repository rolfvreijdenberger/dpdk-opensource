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

package nl.dpdk.collections.lists {
	import flash.utils.Dictionary;
	
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.core.IPriorityQueue;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.PriorityQueueNode;
	import nl.dpdk.collections.sorting.SortOrder;

	/**
	 * PriorityQueue holds prioritized data and offers quick removal and finding of the maximum prioritized item.
	 * It works with PriorityQueueNode instances to manage the prioritized data.
	 * This allows us to quickly reprioritize the data and to remove data referenced by a PriorityQueueNode.
	 * These are extra features compared to a Heap and an orderedList, but come at the cost of extra space and the use of the PriorityQueueNode.
	 * <p><p>
	 * Since we're inheriting from heap, this will make stuff a little slower (overriden methods are slower etc...).
	 * <p><p>
	 * We're bending over backwards a little bit; The interface of PriorityQueue is a little different than Heap and they are not really interchangeable when we are using the IPriorityQueue interface.
	 * This is because of the iterator(), removeMaximum(), getMaximum(), remove() and add() all work with PriorityQueueNodes.
	 * Heap does not.
	 * Even though it doesn't generate runtime errors on the PQ instance itself, it might do so in client code if the client programs to an IPriorityQueue interface, because of the data type of the returned data.
	 * Having said this, we do not change the Interfaces and rely on the client to work out which implementation he needs.
	 * The Interface is provided for the basic functionality and to show the world what the possibilities are of the implementing classes. The client should know which implementation he is using and will use PQ only if he needs the added functionality of rePrioritize(node, priority) and remove(data).
	 * This is really one of those examples where we could really use a generics system like in java, which allows us to specify the allowed data type on a collection type object.
	 * As a side note, one should realize that is also possible to use a PriorityQueueNode on the Heap implementation, just use a comparator method that uses PQNodes on the Heap.
	 * We'll give the structure some thought, maybe we will remove IPriorityQueue from the OrderedList and Heap classes. 
	 * Maybe this is an unlucky inheritance structure, maybe not, time will tell, it just depends on your point of view (whew, the above sounded like a really large excuse :)).  
	 * @see Heap
	 * @see OrderedList
	 * @see PriorityQueueNode
	 * @author Rolf Vreijdenberger
	 */
	public class PriorityQueue extends Heap implements ICollection, IPriorityQueue 
	{
		/**
		 * to be able to do direct lookups on objects, we need a dictionary to lookup the object's index position in the heap.
		 */
		private var indexLookup : Dictionary;

		public function PriorityQueue(collection : ICollection = null) 
		{
			indexLookup = new Dictionary(true);
			super(comparePriorityQueueNode, collection);
		}

		
		/**
		 * the basic comparator method for the PQ.
		 */
		public static function comparePriorityQueueNode(a : PriorityQueueNode, b : PriorityQueueNode) : int
		{
			if(a.getPriority() < b.getPriority())
			{
				return SortOrder.LESS;	
			}
			if(a.getPriority() > b.getPriority())
			{
				return SortOrder.LARGER	;
			}
			return SortOrder.EQUAL;
		}

		
		/**
		 * adds a PriorityQueueNode.
		 * @param data a PriorityQueueNode. if the data is not a PriorityQueueNode, a new one is created with default priority containing the data. 
		 * Grrrrrr, we really need to have generics (like in java) in flash.
		 * @see PriorityQueueNode
		 */
		public override function add(data : *) : void 
		{
			var node : PriorityQueueNode;
			if(data is PriorityQueueNode)
			{
				node = data;
			}else
			{
				node = new PriorityQueueNode(PriorityQueueNode.PRIORITY_DEFAULT, data);
			}
			
			
			//add to the end of the heap, and swim upwards to get to the right sorted position.
			var index : int = collection.push(node) - 1;
			indexLookup[node] = index;
			swim(index);
		}

		
		/**
		 * exchange the array data positions, but also the index on the index lookup structure.
		 */
		override protected function exchange(a : int, b : int) : void
		{
			//also change the index lookup
			var tmp : * = indexLookup[collection[a]];
			indexLookup[collection[a]] = indexLookup[collection[b]];
			indexLookup[collection[b]] = tmp;
			super.exchange(a, b);
		}

		
		/**
		 * @inheritDoc
		 */
		public override function clear() : void 
		{
			super.clear();
			indexLookup = new Dictionary(true);
		}

		
		/**
		 * @param data a PriorityQueueNode. if the data is not a PriorityQueueNode, we check the data properties of all the PriorityQueueNodes against the data provided.
		 * @return true if the PQ contains the node or the data on the node, false otherwise
		 * @see PriorityQueueNode 
		 */
		public override function contains(data : *) : Boolean 
		{
			if(data is PriorityQueueNode)
			{
				trace("contains at position: " + indexLookup[data]);
				return indexLookup[data] != null;
			}
			var node : PriorityQueueNode;
			for(var i : int = 1;i < collection.length;++i)
			{
				node = collection[i] as PriorityQueueNode;
				if(node.getData() == data)
				{
					return true;	
				}	
			}
			return false;
		}

		
		/**
		 * reprioritize
		 */
		public function rePrioritize(node : PriorityQueueNode, priority : Number) : Boolean
		{
			var index : int = indexLookup[node];
			if(isNaN(index))
			{
				return false;
			}
			var oldPriority : Number = node.getPriority();
			var newPriority : Number = priority;
			if(oldPriority == newPriority)
			{
				return false;
			}
			node.setPriority(newPriority);
			if(oldPriority < newPriority)
			{
				swim(index);	
			}else
			{
				sink(index);
			}
			
			return true;
		}

		
		/**
		 * removes a PriorityQueueNode from the PriorityQueue.
		 * @param data an instance of PriorityQueueNode. If it is not an instance of PriorityQueueNode, the data item of all PriorityQueueNodes is compared to find and remove the data if possible.
		 * @return true if removal succeeded, false otherwise
		 */
		public override function remove(data : *) : Boolean 
		{
			if(data is PriorityQueueNode)
			{
				//trace("PQ indexLookup[data]: " + indexLookup[data]);
				var index : int = indexLookup[data];
				//trace("PQ index: " + index);
				if( isNaN(index) || index == 0)
				{
					return false;
					
				}
				removeAt(index);
				return true;
				
			}else
			{
				//no node, just remove normally
				var length : int = collection.length;
				var node : PriorityQueueNode;
				for(var i : int = 1;i < length;++i)
				{	
					node = collection[i] as PriorityQueueNode;
					if(node.getData() == data)
					{
						removeAt(i);
						return true;	
					}
				}
				return false;
			}
		}

		
		override protected function removeAt(i : int) : *
		{
			var data : PriorityQueueNode = collection[i];
			
			if(data == null)
			{
				return null;
			}
			
			//this check is needed because if size equals i,
			//we do not need to reprioritise the queue.
			if(i != size())
			{
				delete indexLookup[collection[size()]];
				delete indexLookup[data];
				
				collection[i] = collection.pop();
				indexLookup[collection[i]] = i;
				sink(i);
				
				return data;
			}
			else
			{
				delete indexLookup[collection[size()]];
				delete indexLookup[data];
			
				return collection.pop();
			}
		}

		override public function setComparator(comparator : Function) : void
		{
			try
			{
				//check if the comparator is on a PriorityQueueNode. this will throw an erro if it fails.
				comparator(new PriorityQueueNode(1), new PriorityQueueNode(2)) == SortOrder.LESS;
				//if so, allow it.
				super.setComparator(comparator);
			}catch(e : Error)
			{
			}
		}

		
		public override function toString() : String 
		{
			return "PriorityQueue of size " + size();
		}

		
		override public function iterator() : IIterator
		{
			return super.iterator();
			/**
			 * or maybe this, see the above comment about different interfaces.
			 * If we were to do this, we should also alter removeMaximum and getMaximum to return the data instead of the PQNode.
			 */
//			 var array: Array = toArray();
//			 var output: Array = new Array();
//			 for each(var node: PriorityQueueNode in array){
//					output.push(node.getData());
//			 }
//			 return new UnmodifiableIterator(new ArrayIterator(output));
			 
		}
	}
}
