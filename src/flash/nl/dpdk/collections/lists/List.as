package nl.dpdk.collections.lists {	import nl.dpdk.collections.core.IApplyable;	import nl.dpdk.collections.core.IApplyer;	import nl.dpdk.collections.core.ICollection;	import nl.dpdk.collections.core.IDeque;	import nl.dpdk.collections.core.IFoldable;	import nl.dpdk.collections.core.IFolder;	import nl.dpdk.collections.core.IMappable;	import nl.dpdk.collections.core.IMapper;	import nl.dpdk.collections.core.IQueue;	import nl.dpdk.collections.core.ISelectable;	import nl.dpdk.collections.core.ISortable;	import nl.dpdk.collections.core.IStack;	import nl.dpdk.collections.iteration.IIterator;	import nl.dpdk.collections.iteration.IIteratorExtended;	import nl.dpdk.collections.lists.IList;	import nl.dpdk.specifications.ISpecification;	/**	 * List serves as an abstract class which should be subclassed and not instantiated directly	 * @author rolf	 */	public class List implements ICollection, IList, IDeque, IQueue, IStack, ISortable, IFoldable, IMappable, ISelectable, IApplyable {		/**		 * the size of the list.		 */		internal var listSize : int = 0;		public function List() {		}						public function get(i : int) : * {			return null;
		}
		public function set(i : int, data : *) : void {		}
		public function removeAt(i : int) : Boolean {			return false;
		}
		public function insertAt(i : int, data : *) : void {		}
		public function indexOf(data : *) : int {			return 0;
		}
		public function lastIndexOf(data : *) : int {			return 0;
		}		protected function addCollection(collection : ICollection) : void {			if(collection) {				addAll(collection);				}		}
		/**		 * @inheritDoc		 */		public function addAll(collection : ICollection) : void {						var iterator : IIterator = collection.iterator();			while(iterator.hasNext()) {				add(iterator.next());			}		}
		public function subList(from : int, to : int) : List {			return null;
		}
		public function reverse() : void {		}
		public function iteratorExtended() : IIteratorExtended {			return null;
		}
		public function sort(comparator : Function, sortType : int = 0) : void {		}
		public function addFirst(data : *) : void {		}
		public function getFirst() : * {			return null;
		}
		/**		 * @inheritDoc		 */		public function addLast(data : *) : void {			add(data);		}
		public function getLast() : * {			return null;
		}
		public function removeFirst() : * {			return null;
		}
		public function removeLast() : * {			return null;
		}
		/**		 * @inheritDoc		 */		public function peek() : * {			return getFirst();		}
		public function enqueue(data : *) : void {		}
		public function dequeue() : * {			return null;
		}
		public function pop() : * {			return null;
		}
		public function push(data : *) : void {		}
		public function add(data : *) : void {		}
		public function clear() : void {		}
		public function contains(data : *) : Boolean {			return false;
		}
		/**		 * @inheritDoc		 */		public function isEmpty() : Boolean {			return listSize == 0;		}
		public function remove(data : *) : Boolean {			return false;
		}
		/**		 * @inheritDoc		 */		public function size() : int {			return listSize;		}
		public function toArray() : Array {			return null;
		}
		public function toString() : String {			return null;
		}
		public function iterator() : IIterator {			return null;
		}
		/**		 * @inheritDoc		 */		public function fold(folder : IFolder) : * {			var iterator : IIterator = iterator();			while(iterator.hasNext()) {				folder.fold(iterator.next());				}			return folder.get();			}		/**		 * @inheritDoc		 */		public function map(mapper : IMapper) : List {			return null;		}
		public function selectBy(specification : ISpecification) : List {			return null;
		}
		/**		 * @inheritDoc		 */		public function apply(applyer : IApplyer) : void {			var iterator : IIterator = iterator();			while(iterator.hasNext()) {				applyer.execute(iterator.next());				}		}
	}}