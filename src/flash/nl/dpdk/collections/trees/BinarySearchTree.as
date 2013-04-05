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

package nl.dpdk.collections.trees {
	import nl.dpdk.collections.core.ICollection;	import nl.dpdk.collections.core.ISearchable;	import nl.dpdk.collections.iteration.IIterator;	import nl.dpdk.collections.sorting.SortOrder;	import nl.dpdk.collections.trees.BinaryTreeNode;	
	/**
	 * A Binary Search Tree (BST)is a datastructure that exists for fast searching. It is a binary tree that has a key associated with each of its internal nodes,
	 * with the additional property that the key in any node is larger than (or equal to) the keys in all nodes in that node's left subtree 
	 * and smaller than (or equal to) the keys in all nodes in that node's right subtree.
	 * <p><p>
	 * A BST will be kept ordered during insertion and removal operations.
	 * In best case (for a perfectly balanced, or bushy tree) the search and add operations will be proportional to time O(log N).
	 * In worst case (for a degenerate tree, left or right hanging) these operations could be proportional to time O(N) which is lineair time and the same as in LinkedList and ArrayList.
	 * <p><p>
	 * To create an efficient BST the data should be added in a more or less random fashion. Ordered addition of data leads to a degenerate tree with O(N^2) insertion time and O(N) search time.
	 * <p><p>
	 * Other implementations of a BST that handle the balancing of the tree during addition and removal are possible. This implementation is a standard one.
	 * @author Rolf Vreijdenberger
	 */
	public class BinarySearchTree implements ISearchable {
		/**
		 * the reference to the tree we store in this datastructure.
		 * @access protected, so we can override this implementation while keeping a reference to the tree.
		 */
		protected var tree : BinaryTreeNode;
		/**
		 * the comparator function.
		 * @access protected, so we can override this implementation.
		 * @see Comparators
		 */
		protected var comparator : Function;
		/**
		 * the size of the tree.
		 * while we could easily get that from the tree nodes themselves, this is a costly operation, therefore we store the size here (eager count instead of lazy count).
		 */
		protected var treeSize : int = 0;

		/**
		 * @param comparator the comparision function to use as the key sorter on the elements in the collection. The client is explicitely forced to think about the specific comparator to use.
		 * @param collection an ICollection instance to prefill the BST (optional). make sure the collection is not ordered as this leads to unoptimized search and insertions.
		 * @see Comparators
		 */
		public function BinarySearchTree(comparator : Function, collection : ICollection = null) {
			this.comparator = comparator;
			addCollection(collection);
		}

		
		/**
		 * fills the tree with the data in a collection
		 * @param collection the collection to prefill the tree with
		 */
		private function addCollection(collection : ICollection = null) : void {
			if(collection == null) return;
			var iterator : IIterator = collection.iterator();
			while(iterator.hasNext()) {
				add(iterator.next());	
			}
		}

		
		/**
		 * searches for a specific data item (by using the comparator method passed at construction time)
		 * @param data the data element to search for by the comparator
		 * @return the first data element that matches the comparison, otherwise null is returned
		 */
		public final function search(data : *) : * {
			
			var node : BinaryTreeNode = findNodeByData(data);
			if(node) {
				return node.getData();
			}
			return null;
		}

		
		/**
		 * helper method to get a node that contains a specific piece of data.
		 * this actually contains the binarytree search method
		 * @return a BinaryTreeNode or null if not found
		 */
		private function findNodeByData(data : *) : BinaryTreeNode {
			var node : BinaryTreeNode = tree;
			var order : int;
			while(node != null) {
				order = comparator(data, node.getData());
				if(order == SortOrder.EQUAL) {
					return node;
				}
				node = (order == SortOrder.LESS) ? node.getLeft() : node.getRight();
			}
			return null;
		}

		
		/**
		 * factory method to be able to return any kind of BinaryTreeNode in an overriden implementation.
		 * a usage of this might be a BinaryTreeNode with another iterator implementation, or with extended or altered behaviour.
		 * This method is the only method in this class that actually creates a node.
		 * Just override this method, and return a subclass of BinaryTreeNode (The subclass should also be overriding BinaryTreeNode.getBinaryTreeNode and other methods)
		 * @param data the data element to fill the BinaryTreeNode with
		 * @return the BinaryTreeNode or a subclass
		 */
		protected function getBinaryTreeNode(data : *) : BinaryTreeNode {
			return new BinaryTreeNode(data);	
		}

		
		/**
		 * add a data element to the collection in sorted position, overwrites the data if already present.
		 * This means that there will be no duplicates in this implementation.
		 * This also means that we can override the behaviour to allow duplicates or to disallow overwrites.
		 * Of course, the notion of 'duplicates' is determined by the comparator function.
		 * @param data the data element to add
		 */
		public function add(data : *) : void {
			if(tree == null) {
				tree = getBinaryTreeNode(data);
				treeSize++;
				return;	
			}
			var node : BinaryTreeNode = tree;
			var order : int;
			while(node) {
				order = comparator(data, node.getData());
				if(order == SortOrder.EQUAL) {
					node.setData(data);
					return;
				}
				if(order == SortOrder.LESS) {
					if(node.getLeft()) {
						node = node.getLeft();	
					}else {
						node.setLeft(data);
						treeSize++;
						return;
					}
				}else {
					if(node.getRight()) {
						node = node.getRight();	
					}else {
						node.setRight(data);
						treeSize++;
						return;
					}
				}
			}
			return;
		}

		
		/**
		 * clears the whole tree
		 */
		public function clear() : void {
			if(tree != null) {
				tree.clear();
				tree = null;
				treeSize = 0;
			}
		}

		
		/**
		 * check if we have a certain piece of data
		 * @param data the data element we want to find
		 * @return true if the data element was found, false otherwise
		 */
		public final function contains(data : *) : Boolean {
			return search(data) != null;
		}

		
		/**
		 * @return true if the tree is empty, false otherwise
		 */
		public final function isEmpty() : Boolean {
			return tree == null;
		}

		
		/**
		 * removes a data element if present, specified by the comparator passed at construction time.
		 * @param data the data element to remove
		 * @return true if succesfully removed, false if not found.
		 */
		public final function remove(data : *) : Boolean {
			var node : BinaryTreeNode = findNodeByData(data);
			if(node != null) {
				return removeNode(node);
			}
			return false;
		}

		
		/**
		 * removes a node from the tree and rearranges the other nodes
		 */
		private function removeNode(node : BinaryTreeNode) : Boolean {
			if(node.getChildCount() == 0) {
				return removeNodeWithNoChildren(node);	
			}
			
			if(node.getChildCount() == 1) {
				return removeNodeWithOneChild(node);
			}
			
			if(node.getChildCount() == 2) {
				return removeNodeWithTwoChildren(node);
			}
			return false;
		}

		
		protected function removeNodeWithTwoChildren(node : BinaryTreeNode) : Boolean {
			//trace("BinarySearchTree.removeNodeWithTwoChildren(" + node.getData() + ")");
			
			//get the right subtree
			var leftMostNode : BinaryTreeNode = node.getRight();
			//and get it's smallest element, the leftmost element
			while(leftMostNode.getLeft()) {
				leftMostNode = leftMostNode.getLeft();
			}
			
			//if it's a node that's not the subtree node itself
			if(leftMostNode != node.getRight()) {
				//trace('not same, leftMost: ' + leftMostNode.getData() + ", node.getRight(): " + node.getRight().getData());
				//check if it has a dangling right node, cause we have to reposition it
				if(leftMostNode.getRight()) {
					//we have it, now connect to leftmost's parent as left node (take letftmosts' place
					BinaryTreeNode(leftMostNode.getParent()).setLeftNode(leftMostNode.getRight());	
				}
				
				
					//kill the reference to the parent
					leftMostNode.setParentNode();
					//set the right subtree of the node to remove as our right subtree
					leftMostNode.setRightNode(node.getRight());
					//set the left subtree of the node to remove as our left subtree
					leftMostNode.setLeftNode(node.getLeft());
				
			}else {
				//trace('same, leftMost: ' + leftMostNode.getData() + ", node.getRight(): " + node.getRight().getData());
				//this node is actually the smallest item of the right subtree
				leftMostNode.setParentNode();
				//set the left subtree of the node to be removed to be the right subtree's left subtree
				leftMostNode.setLeftNode(node.getLeft());	
			}
				
			//FIX: an infinite loop was fixed  by asking this question:   maybe a node can become root, while it's left or right reference is not cleared from another node?
			//answer: in BinaryTreeNode, when a parent reference was reset by a call to setParentNode(null), the child references on parent were not cleared.
			if(node.isRoot()) {
				//trace("the node is root");
				//since the node to be removed is the root, make us the new root
				tree = leftMostNode;	
			}
			if(node.isLeft()) {
				//trace('is left node of ' + node.getParent().getData());
				//since the node is the left node, make it's parent have us as it's left node
				BinaryTreeNode(node.getParent()).setLeftNode(leftMostNode);	
			}
			if(node.isRight()) {
				//trace('is right node of ' + node.getParent().getData());
				//since the node is the right node, make it's parent have us as it's right node
				BinaryTreeNode(node.getParent()).setRightNode(leftMostNode);	
			}
			//all done, decrease the size of the tree
			treeSize--;
			//and say the shit went down properly
			return true;
		}

		
		protected function removeNodeWithOneChild(node : BinaryTreeNode) : Boolean {
			//trace("BinarySearchTree.removeNodeWithOneChild(" + node.getData() + ")");
			var newRootNode : BinaryTreeNode;
			if(node.getLeft()) {
				newRootNode = node.getLeft();	
			}
			if(node.getRight()) {
				newRootNode = node.getRight();	
			}
			if(node.isRoot()) {
				//trace('root');
				tree = newRootNode;	
				newRootNode.setParentNode(null);
			}
			if(node.isLeft()) {
				//trace('left');
				BinaryTreeNode(node.getParent()).setLeftNode(newRootNode);
			}
			if(node.isRight()) {
				//trace('right');
				BinaryTreeNode(node.getParent()).setRightNode(newRootNode);
			}
			treeSize--;
			return true;
		}

		
		protected function removeNodeWithNoChildren(node : BinaryTreeNode) : Boolean {
		//	trace("BinarySearchTree.removeNodeWithNoChildren(" + node.getData() + ")");
			if(node.isRoot()) {
			//	trace('root');
				clear();
				return true;	
			}
			if(node.isLeft()) {
				//trace('left');
				BinaryTreeNode(node.getParent()).setLeftNode();
			}
			if(node.isRight()) {
				//trace('right');
				BinaryTreeNode(node.getParent()).setRightNode();
			}	
			treeSize--;
			return true;
		}

		
		/**
		 * @return the size of the tree
		 */
		public final function size() : int {
			//an eager operation, as we do not get the size from the tree (tree.size() can be very expensive as it is a recursive call);
			return treeSize;
		}

		
		/**
		 * @return an array representation of the data elements in inOrder
		 */
		public function toArray() : Array {
			if(tree == null) return new Array();
			/**
			 * a copy of the tree is created
			 */
			var visitor : BSTVisitorArrayConverter = new BSTVisitorArrayConverter();
			BinaryTreeNode.inOrder(tree, visitor);
			return visitor.getArray();
		}

		
		/**
		 * @return a string representation of the bst
		 */
		public function toString() : String {
			return "BinarySearchTree of size: " + size();
		}

		
		/**
		 * returns an iterator that iterates in inOrder, which is the ordered representation of the BST.
		 * The iterator actually returns an iterator of a copy of the data of the tree. the copying process takes time.
		 * Therefore, there is no way to manipulate the tree itself via the iterator, only the data contained in the treenodes, when the data is a reference to an object.
		 * To handle the nodes of the tree, use the traversal mechanisms provided by the static methods of BST.
		 * The iterator is provided to be able to pass the BST around as an ICollection to be implemented in the various data structures in the collections package.
		 * For specific behaviour, override.
		 * @return IIterator that iterates in inOrder
		 */
		public function iterator() : IIterator {
			/**
			 * a copy of the tree is created on a list, whose iterator is returned
			 */
			var visitor : BSTVisitor = new BSTVisitor();
			BinaryTreeNode.inOrder(tree, visitor);
			return visitor.getList().iterator();
			
			/* 
			if(tree != null) {
				//level order iterator as default on the BinaryTreeNode
				return tree.iterator();
			}
			return new NullIterator();
			 */
		}

		
		/**
		 * the preorder traversal of the BST.
		 * @param bst the BinarySearchTree we would like to traverse.
		 * @param visitor	the IBinaryTreeNodeVisitor that handles the processing of the BinaryTreeNode
		 */
		public static function preOrder(bst : BinarySearchTree, visitor : ITreeNodeVisitor) : void {
			BinaryTreeNode.preOrder(bst.tree, visitor);
		}

		
		/**
		 * the inorder traversal of the BST. This traverses the tree in an ordered way (from smallest element to largest element).
		 * @param bst the BinarySearchTree we would like to traverse.
		 * @param visitor	the IBinaryTreeNodeVisitor that handles the processing of the BinaryTreeNode
		 */
		public static function inOrder(bst : BinarySearchTree, visitor : ITreeNodeVisitor) : void {
			BinaryTreeNode.inOrder(bst.tree, visitor);
		}

		
		/**
		 * the postorder traversal of the BST.
		 * @param bst the BinarySearchTree we would like to traverse.
		 * @param visitor	the IBinaryTreeNodeVisitor that handles the processing of the BinaryTreeNode
		 */
		public static function postOrder(bst : BinarySearchTree, visitor : ITreeNodeVisitor) : void {
			BinaryTreeNode.postOrder(bst.tree, visitor);
		}

		
		/**
		 * the levelorder traversal of the BST.
		 * @param bst the BinarySearchTree we would like to traverse.
		 * @param visitor	the IBinaryTreeNodeVisitor that handles the processing of the BinaryTreeNode
		 */
		public static function levelOrder(bst : BinarySearchTree, visitor : ITreeNodeVisitor) : void {
			BinaryTreeNode.levelOrder(bst.tree, visitor);
		}
	}
}