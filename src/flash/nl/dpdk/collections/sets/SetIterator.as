package nl.dpdk.collections.sets {	import nl.dpdk.collections.iteration.IIterator;		internal class SetIterator implements IIterator {	private var set : Set;	private var position : int = -1;	private var array : Array;	public function SetIterator(set : Set) 	{		this.set = set;		this.array = set.toArray();	}		public function hasNext() : Boolean 	{		return position < array.length - 1;	}		public function next() : * 	{		return array[++position];	}		public function remove() : Boolean 	{		if(set.remove(array[position])) 		{			array.splice(position, 1);			position = Math.max(-1, --position);			return true;		}		return false;	}}}