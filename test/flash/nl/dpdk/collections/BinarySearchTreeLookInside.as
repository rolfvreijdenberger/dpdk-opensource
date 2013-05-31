package nl.dpdk.collections {
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.trees.BinaryTreeNode;
	import nl.dpdk.collections.trees.BinarySearchTree;		/**
	 * subclassed to get a look at the structure of the tree itself, to confirm it does what it should do
	 * @author Rolf Vreijdenberger
	 */
	public class BinarySearchTreeLookInside extends BinarySearchTree {
		public function BinarySearchTreeLookInside(comparator : Function, collection : ICollection = null) {
			super(comparator, collection);
		}
		
		public function getRoot(): BinaryTreeNode{
			return tree;	
		}	}
}
