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
	import nl.dpdk.collections.core.ICollection;	import nl.dpdk.collections.iteration.IIterator;		import flash.utils.Dictionary;	
	/**
	 * A collection that contains no duplicate elements.
	 * No order is implied on a Set.
	 * @author Rolf Vreijdenberger
	 */
	public class Set 
	{
		/**
		 * dictionary implementation, a hashmap
		 */
		private var dictionary : Dictionary;
		/**
		 * size of the collection
		 */
		private var theSize : int;

		public function Set(collection : ICollection = null) 
		{
			clear();
			addCollection(collection);
		}

		
		private function addCollection(collection : ICollection) : void 
		{
			if(collection) 
			{
				var iterator : IIterator = collection.iterator();
				var data : *;
				while(iterator.hasNext()) 
				{
					data = iterator.next();
					add(data);
				}	
			}
		}

		
		/**
		 * null not allowed.
		 * @inheritDoc
		 */
		public function add(data : *) : void 
		{
			if(data == null || dictionary[data] == true) 
			{
				return;
			}
			dictionary[data] = true;
			theSize++;	
		}

		
		/**
		 * @inheritDoc
		 */
		public function clear() : void 
		{
			dictionary = new Dictionary(false);
			theSize = 0;
		}

		
		/**
		 * @inheritDoc
		 */
		public function contains(data : *) : Boolean 
		{
			return dictionary[data] == true;
		}

		
		/**
		 * @inheritDoc
		 */
		public function isEmpty() : Boolean 
		{
			return theSize == 0;
		}

		
		/**
		 * @inheritDoc
		 */		
		public function remove(data : *) : Boolean 
		{
			if(dictionary[data] != true) 
			{
				return false;
			}
			delete dictionary[data];
			theSize--;
			return true;	
		}

		
		/**
		 * @inheritDoc
		 */
		public function size() : int 
		{
			return theSize;
		}

		
		/**
		 * @inheritDoc
		 */
		public function toArray() : Array 
		{
			var array : Array = new Array();
			var i : *;
			for (i in dictionary) 
			{
				array.push(i);	
			}
			return array;
		}

		
		/**
		 * @inheritDoc
		 */
		public function toString() : String 
		{
			return "Set of size " + size();
		}

		
		/**
		 * time proportional to O(N).
		 * @inheritDoc
		 */
		public function iterator() : IIterator 
		{
			return new SetIterator(this);
		}
	}
}