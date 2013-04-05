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

package nl.dpdk.collections.core {
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.iteration.UnmodifiableIterator;	

	/**
	 * Wrapper around a collection to make the collection unmodifiable.
	 * This allows us to provide access to the collection and it's data without the possibility to make changes to the collection itself.
	 * Of course it will still be possible to alter  a primitive or an object to which we get a reference via the iterator, but this does not alter the collection itself.
	 * @author Rolf Vreijdenberger
	 */
	public class UnmodifiableCollection implements ICollection {
		private var collection : ICollection;
		
		/**
		 * @param collection the collection we want to make unmodifiable
		 */
		public function UnmodifiableCollection(collection: ICollection) {
			/*
			 * TODO, should we copy the whole collection in a List, or just keep the reference to the collection?
			 * in the case we keep the reference, it is still possible to alter the contents.
			 * in the case we keep a copy, it is a performance issue and it is still possible to alter the contents of objects we have references to in the list (which is unavoidable, unless we use a clone() method, which is totally unfeasible)
			 */
			
			this.collection = collection;
		}
		
		
		public function add(data : *) : void {
			return;
		}
		
		
		public function clear() : void {
			return;
			
		}
		
		
		public function contains(data : *) : Boolean {
			return this.collection.contains(data);
		}
		
		
		public function isEmpty() : Boolean {
			return this.collection.isEmpty();
		}
		
		
		public function remove(data : *) : Boolean {
			return false;
		}
		
		
		public function size() : int {
			return collection.size();
		}
		
		
		public function toArray() : Array {
			return collection.toArray();
		}
		
		
		public function toString() : String {
			return "UnmodifiableCollection: " + collection.toString();
		}
		
		
		public function iterator() : IIterator {
			return new UnmodifiableIterator(collection.iterator());
		}
	}
}
