package nl.dpdk.collections.utils 
{
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.iteration.ArrayIterator;
	import nl.dpdk.collections.iteration.IIterable;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.IList;
	import nl.dpdk.collections.lists.List;
	/**
	 * Some functions to get even more out of the collections package
	 * 
	 * @author Thomas Brekelmans, Szenia Zadvornykh, Peter Schmidt
	 */
	public class CollectionUtils 
	{
		/**
		 * Exchange the items at the two given indices. Returns false if either index 
		 * is out of bounds, or if the list is null.
		 * @param list	the list to exchange the indices from
		 * @param indexA	the first index
		 * @param indexB	the second index
		 */
		public static function exchange(list:IList, indexA:uint, indexB:uint):Boolean 
		{
			if(indexA >= list.size() || indexB >= list.size() || list == null)
			{
				return false;
			}
			var tmp:* = list.get(indexA);
			list.set(indexA, list.get(indexB));
			list.set(indexB, tmp);
			return true;
		}

		/**
		 * calls a specified method on every item in a list. Useful for lists containing commands.
		 * @param collection any collection that implements the IIterable interface
		 * @param methodName name of the method you wish to call on every item in the list
		 */
		public static function callMethod(collection:IIterable, methodName:String, ...args):void
		{
			if (collection)
			{
				var iterator:IIterator = collection.iterator();
				while(iterator.hasNext()) 
				{
					iterator.next()[methodName].apply(null, args);	
				}
			}
		}

		/**
		 * Adds an item to a given collection, but only if the item and the collection are not null
		 */
		public static function addIfNotNull(collection:ICollection, item:*):Boolean
		{
			if(collection && item)
			{
				collection.add(item);
				return true;
			}
			return false;
		}

		/**
		 * Returns a new collection which is a + b
		 * Items appearing in collection a as well as collection b are contained only once, not twice.
		 * This can also be used as a duplication, by merging an existing collection with a newly created one.
		 */
		public static function merge(a:ICollection, b:ICollection):ICollection
		{
			var merged:List = new ArrayList();
			
			merged.addAll(a);
			
			var iterator:IIterator = b.iterator();
			while(iterator.hasNext())
			{
				merged.remove(iterator.next());			
			}
			
			merged.addAll(b);
			
			return merged;
		}

		/**
		 * Add every item from a given array to a given collection
		 */
		public static function addArrayToCollection(array:Array, collection:ICollection):void
		{
			var iterator:IIterator = new ArrayIterator(array);
			while (iterator.hasNext())
			{
				collection.add(iterator.next());
			}
		}

		/**
		 * Remove every item in a given array from a given collection.
		 * Duplicate items in collection will only be removed once.
		 */
		public static function removeArrayFromCollection(array:Array, collection:ICollection):void
		{
			var iterator:IIterator = new ArrayIterator(array);
			while (iterator.hasNext())
			{
				collection.remove(iterator.next());
			}
		}

		/**
		 * Removes all items found in a given collection from another collection
		 * @param remove	the collection to loop through for removable items
		 * @param from		the collection to remove the items from
		 */
		public static function removeAll(remove:ICollection, from:ICollection):void
		{
			var iterator:IIterator = remove.iterator();
			while (iterator.hasNext())
			{
				from.remove(iterator.next());
			}
		}

		/**
		 * returns the number of occurences of data in collection
		 */
		public static function cardinality(data:*, collection:ICollection):int 
		{
			var counter:int = 0;
			var iterator:IIterator = collection.iterator();
			while (iterator.hasNext())
			{
				if(iterator.next() == data)
				{
					counter++;
				}
			}
			return counter;
		}

		/**
		 * returns a new collection containing a - b 
		 */
		public static function substract(a:ICollection, b:ICollection):ICollection
		{
			var duplicateB:ICollection = new ArrayList(b);
			
			var list:ArrayList = new ArrayList();
			var iterator:IIterator = a.iterator();
			while (iterator.hasNext())
			{
				var data:* = iterator.next();
				if(!duplicateB.contains(data))
				{
					list.push(data);
				}
				else
				{
					duplicateB.remove(data);
				}
			}
			return list;
		}

		/**
		 * returns a new collection of items which are both in collection and retain
		 * If an item appears twice in collection and once in retain, the returned
		 * collection will contain that item twice.
		 */
		public static function retainAll(collection:ICollection, retain:ICollection):ICollection 
		{
			var list:ArrayList = new ArrayList();
			var iterator:IIterator = collection.iterator();
			while (iterator.hasNext())
			{
				var data:* = iterator.next();
				if(retain.contains(data))
				{
					list.push(data);
				}
			}
			return list;
		}

		/**
		 * Test if the given two collections contain exactly the same items, with the same cardinalities.
		 * The ordering of the collections doesn't matter, index is not considered.
		 */
		public static function equals(a:ICollection, b:ICollection):Boolean
		{
			if(a.size() != b.size())
			{
				return false;
			}
			var aIterator:IIterator = a.iterator();
			while (aIterator.hasNext())
			{
				if(!b.contains(aIterator.next()))
				{
					return false;
				}
			}
			return true;
		}
	}
}