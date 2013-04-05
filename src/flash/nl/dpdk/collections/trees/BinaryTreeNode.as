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
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.core.IQueue;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.lists.LinkedList;
	import nl.dpdk.collections.trees.BinaryTreeNode;	

	/**
	 * BinaryTreeNode,an abstraction for a Node in a binary tree.
	 * <p>
	 * a binary tree is a tree data structure in which each node has at most two children. 
	 * Typically the child nodes are called left and right. 
	 * Binary trees are commonly used to implement binary search trees, parse trees and binary heaps.
	 * <p>
	 * A tree will be manipulated either by directly manipulating the nodes itself, via calls to getLeft, getRight, getParent, getSiblings and getChildren,
	 * or it can be manipulated by the traversal mechanisms.
	 * <p>
	 * Be careful to not make cyclic references, as there are not enough checks to prevent this on the BinaryTreeNode itself. A cyclic reference will cause infinite loops on the traversals of the tree.
	 * <p>
	 * It is easy/advisable to use a builder pattern as a wrapper around this class to facilitate the tree building
	 * @see ICollection
	 * @see ITreeNode
	 * @author Rolf Vreijdenberger
	 */
	public class BinaryTreeNode implements ICollection, ITreeNode 
	{
		//the data of the node
		private var data : *;
		//the left node of this node
		private var left : BinaryTreeNode;
		//the right node of this node
		private var right : BinaryTreeNode;
		//the parent node of this node
		private var parent : BinaryTreeNode;

		/**
		 * constructor
		 * @param data the data element to set on the node, can be a null value, indicating a lack of data
		 * @param parent a BinaryTreeNode that will be the parent of the newly created node. 
		 * The parent node needs to have at least one leaf, otherwise the parent node cannot function as a parent.
		 * This is done because we do not want to make assumptions about where to place the child node (eg: left, right, or replace).
		 */
		public function BinaryTreeNode(data : * = null, parentNode : BinaryTreeNode = null) 
		{
			setData(data);
			setParentNodeAtConstruction(parentNode);
		}

		
		/**
		 * helper method for the constructor.
		 * @return void	this needs to be as fast as possible
		 */
		protected function setParentNodeAtConstruction(parentNode : BinaryTreeNode) : void 
		{
			if(parentNode && parentNode.getChildCount() != 2) 
			{
				/**
				 * mmhhhh, maybe I just don't get it, but left is a private property, 
				 * so we should not be able to get to the left node in this way...
				 * somehow it works. 
				 */
				if(parentNode.left == null) 
				{
					parentNode.setLeftNode(this);	
				}else 
				{
					parentNode.setRightNode(this);				
				}
			}
		}
		
		/**
		 * gets the left <em>node</em> in the tree.
		 * We want this method on the node so we can manually traverse the nodes.
		 * this is 1 of the 4 methods that actually returns nodes (getLeft, getRight, getParent, getRoot).
		 * @return the left node or null if none is present
		 */
		public final function getLeft() : BinaryTreeNode 
		{
			return left;
		}

		
		/**
		 * gets the right <em>node</em> in the tree.
		 * We want this method on the node so we can manually traverse the nodes.
		 * this is 1 of the 4 methods that actually returns nodes (getLeft, getRight, getParent, getRoot).
		 * @return the right node or null if none is present
		 */
		public final function getRight() : BinaryTreeNode 
		{
			return right;
		}

		
		/**
		 * gets the data from this node
		 * @return the data element or null if nothing is present
		 */
		public final function getData() : * 
		{
			return data;
		}

		
		/**
		 * gets the parent <em>node</em> in the tree.
		 * We want this method on the node so we can manually traverse the nodes.
		 * this is 1 of the 4 methods that actually returns nodes (getLeft, getRight, getParent, getRoot).
		 * @see ITreeNode
		 * @return the parent (ITreeNode) or null if none is present
		 */
		public final function getParent() : ITreeNode 
		{
			return parent;
		}

		
		/**
		 * @inheritDoc
		 */
		public final function getChildCount() : int 
		{
			return (left == null ? 0 : 1) + (right == null ? 0 : 1);
		}

		
		/**
		 * counts the siblings. in case of a binary tree either 0 or 1.
		 * @inheritDoc
		 */
		public final function getSiblingCount() : int 
		{
			if(getParent() == null) return 0;
			return getParent().getChildCount() - 1;
		}

		
		/**
		 * returns a list of BinaryTreeNodes with the direct children (so of size 0, 1 or 2 entries in the list)
		 * @return a list of BinaryTreeNodes
		 */
		public final function getChildren() : List 
		{
			var children : LinkedList = new LinkedList();
			if(getLeft()) children.add(getLeft());
			if(getRight()) children.add(getRight());
			return children;
		}

		
		/**
		 * returns a list of BinaryTreeNodes with our siblings (either of size 0 or 1)
		 * @return a list of BinaryTreeNodes
		 */
		public final function getSiblings() : List 
		{
			var siblings : LinkedList = new LinkedList();
			var sibling : BinaryTreeNode;
			if(isRight()) 
			{
				sibling = BinaryTreeNode(getParent()).getLeft();
			}
			
			if(isLeft()) 
			{
				sibling = BinaryTreeNode(getParent()).getRight();
			}
			
			//in case we are root or do not have a sibling
			if(sibling != null) 
			{
				siblings.add(sibling);
			}
			return siblings;
		}

		
		/**
		 * gets the level of the Node in the treestructure. level is zero based.
		 * The implementation is recursive, so be careful when processing lots of nodes. 
		 * on the other hand,  it is only dependent on the height, so for a bushy tree this operation should be quick: best case O(ln N), worst case O(N)
		 * @return the level of the node (0 for root, 1 for the left and right child of the root etc.)
		 */
		public final function getLevel() : int 
		{
			//base case
			if(isRoot()) return 0;
			//recursive call
			return 	getParent().getLevel() + 1;
		}

		
		/**
		 * gets the height of the tree starting from this node.
		 * this is a recursive implementation and finds the deepest point. 
		 * Therefore it must search every path from the search root: an expensive operation
		 * An overriden implementation might store the height per node
		 * @return the height, from 1 to ...
		 */
		public function getHeight() : int 
		{
			var leftHeight : int = 0, rightHeight : int = 0;
			if (getLeft()) 
			{
				leftHeight = getLeft().getHeight();
			}
			if (getRight()) 
			{
				rightHeight = getRight().getHeight();
			}
			return ((leftHeight > rightHeight ? leftHeight : rightHeight) + 1);
		}

		
		/**
		 * gets the root for this node. 
		 * gets the root <em>node</em> in the tree.
		 * We want this method on the node so we can manually traverse the nodes.
		 * this is 1 of the 4 methods that actually returns nodes (getLeft, getRight, getParent, getRoot). 
		 * @return the root of the tree
		 * @see ITreeNode
		 */
		public final function getRoot() : ITreeNode 
		{
			var root : ITreeNode = this;
			while (!root.isRoot()) 
			{
				root = root.getParent();	
			}
			return root;
		}

		
		/**
		 * clears the BinaryTree
		 * all references on the tree will be reset, going down from this node
		 */
		public function clear() : void 
		{
			//removes all links and data recursively
			if(getLeft()) 
			{
				getLeft().clear();	
			}
			
			if(getRight()) 
			{
				right.clear();
			}
			
			if(!isRoot()) 
			{
				if(isLeft()) 
				{
					BinaryTreeNode(getParent()).setLeft(null);	
				}
				if(isRight()) 
				{
					BinaryTreeNode(getParent()).setRight(null);	
				}	
			}
				
			setData(null);
			setLeft(null);
			setRight(null);
		}

		
		/**
		 * does the tree structure contain a specific data element. search in time proportional to O(N)
		 * @return true if the tree contains the element
		 */
		public function contains(data : *) : Boolean 
		{
			var queue : IQueue = new LinkedList();
			var node : BinaryTreeNode = this;
			queue.enqueue(node);
			while(!queue.isEmpty()) 
			{
				node = queue.dequeue() as BinaryTreeNode;
				if(node.getRight()) queue.enqueue(node.getRight());
				if(node.getLeft()) queue.enqueue(node.getLeft());
				if(node.getData() == data) 
				{
					return true;	
				}
			}
			return false;
		}

		
		/**
		 * is this an empty tree: a standalone BinaryTreeNode
		 * @return true if empty, false otherwise
		 */
		public final function isEmpty() : Boolean 
		{
			return getLeft() == null && getRight() == null;
		}

		
		/**
		 * removes a data item from the tree.
		 * if the data element is found, the whole subtree including the node containing the data item is removed.
		 * if a copy needs to be made of the tree from the node we want to remove, we first have to do a traversal of the tree and rebuild the tree from there.
		 * @return true if the data item was found, false otherwise
		 */
		public function remove(data : *) : Boolean 
		{
			var queue : IQueue = new LinkedList();
			var node : BinaryTreeNode = this;
			queue.enqueue(node);
			//level order traversal
			while(!queue.isEmpty()) 
			{
				node = queue.dequeue() as BinaryTreeNode;
				if(node.getRight()) queue.enqueue(node.getRight());
				if(node.getLeft())  queue.enqueue(node.getLeft());
				if(node.getData() == data) 
				{
					node.clear();
					return true;	
				}
			}
			return false;
		}

		
		/**
		 * what is the size of the tree, this is a recursive call, so be careful when processing lots of nodes: time proportional to O(N)
		 * The size is not eagerly stored, to keep the footprint a little lower when manipulating nodes.
		 * by subclassing it would be possible to implement an eager count by keeping a reference of the size on each node
		 * @return the size of the tree
		 */		
		public function size() : int 
		{
			var count : int = 1;
			//no method calls used. direct access makes for quicker calculation
			if(left) 
			{
				count += left.size();	
			}
			if(right) 
			{
				count += right.size();	
			}
			return count;
		}

		
		/**
		 * are we a left node for our parent
		 * @return true if we are, false otherwise
		 */
		public final function isLeft() : Boolean 
		{
			var parent : BinaryTreeNode = getParent() as BinaryTreeNode;
			if(parent) 
			{
				return parent.getLeft() == this;		
			}
			return false;
		}

		
		/**
		 * are we a right node for our parent
		 * @return true if we are, false otherwise
		 */
		public final function isRight() : Boolean 
		{
			var parent : BinaryTreeNode = getParent() as BinaryTreeNode;
			if(parent) 
			{
				return parent.getRight() == this;		
			}
			return false;
		}

		
		/**
		 * are we the root node
		 * @return true if we are, false otherwise
		 */
		public final function isRoot() : Boolean 
		{
			return getParent() == null;
		}

		
		/**
		 * adds a data item to a random, non occupied position in the tree.
		 * insertion should take time proportional to the height of the tree O(ln N)
		 * @param data the data element to add
		 */
		public function add(data : *) : void 
		{
			var node : BinaryTreeNode = this;
			var rand : int;
			while(node) 
			{
				rand = Math.floor(Math.random() * 2);
				if(rand == 0) 
				{
					if(node.getLeft()) 
					{
						node = node.getLeft();	
					}else 
					{
						node.setLeft(data);
						return;	
					}	
				}else 
				{
					if(node.getRight()) 
					{
						node = node.getRight();	
					}else 
					{
						node.setRight(data);
						return;	
					}
				}
			}
		}

		
		/**
		 * sets the data on the left node
		 * @param data the data element to set on the left node.It can also be a BinaryTreeNode, in which case it is set to the be the left node.
		 */
		public function setLeft(data : * = null) : Boolean 
		{
			
			if(data == null) 
			{
				return setLeftNode(null);
			}
			if(data is BinaryTreeNode) 
			{
				return setLeftNode(data);	
			}
			return setLeftNode(getBinaryTreeNode(data));
		}

		
		/**
		 * factory method for getting a new node.
		 * a hook for overriding this method by subclassing this class so that each instance of the subclass creates and uses instances of the subclas.
		 * This method is the only method that creates a node in this class.
		 */
		protected function getBinaryTreeNode(data : *) : BinaryTreeNode 
		{
			return new BinaryTreeNode(data);
		}

		
		/**
		 * helper method on the node.
		 * we don't make this public to stop a client from making recursive implementations.
		 * @access internal, for use in the BinarySearchTree. 
		 * @see BinarySearchTree
		 */
		internal function setLeftNode(node : BinaryTreeNode = null) : Boolean 
		{
			if(this == node) 
			{
				//self reference
				throw new Error("self reference for left node not allowed for " + this.getData());	
			}
			left = node;
			if(node) 
			{
				node.setParentNode(this);
				return true;
			}
			return false;
		}
		
		/**
		 * sets the data on the right node
		 * @param data the data element to set on the right node. It can also be a BinaryTreeNode, in which case it is set to the be the rigth node.
		 * @return true if the data that was passed was not null
		 */
		public function setRight(data : * = null) : Boolean 
		{
			if(data == null) 
			{
				return setRightNode(null);
			}
			if(data is BinaryTreeNode) 
			{
				return setRightNode(data);	
			}
			return setRightNode(getBinaryTreeNode(data));
		}

		
		/*
		 * we don't make this public to stop a client from making recursive implementations.
		 * @access internal, for use in the BinarySearchTree. 
		 * @see BinarySearchTree
		 */
		internal function setRightNode(node : BinaryTreeNode = null) : Boolean 
		{
			if(this == node) 
			{
				//self reference
				throw new Error("self reference for right node not allowed for " + this.getData());	
			}
			right = node;
			if(node) 
			{
				node.setParentNode(this);
				return true;
			}
			return false;
		}

		
		/**
		 * sets the parent node.
		 * we don't make this public to stop a client from making recursive implementations
		 * @access internal. we need to be able to access this method for BinarySearchTree manipulation. 
		 * @param node a binary tree node, can default to null (the node becomes root)
		 * @see BinarySearchTree
		 */
		internal function setParentNode(node : BinaryTreeNode = null) : Boolean 
		{
			if(this == node) 
			{
				//self reference
				throw new Error("self reference for parent node not allowed for " + this.getData());	
			}
			if(node == null) 
			{
				//kill references to us by the parent
				if(isLeft())
				{
					if(parent)
					{
						parent.setLeft();
					}	
				}
				if(isRight())
				{
					if(parent)
					{
						parent.setRight();
					}	
				}
				parent = null;
				
				return false;
			}
			//node not null
			parent = node;
			return true;
		}

		
		/**
		 * @inheritDoc
		 */
		public function setData(data : * = null) : void 
		{
			this.data = data;
		}

		
		/**
		 * the preorder traversal on the tree.
		 * preorder: visit, left, right
		 * @param node the node to start with (acts as the root of the tree to traverse)
		 * @param visitor the traversal handling IBinaryTreeNodeVisitor (which might be a composite handler to improve performance of traversals)
		 * @see IBinaryTreeNodeVisitor
		 */
		public static function preOrder(node : BinaryTreeNode, visitor : ITreeNodeVisitor) : void 
		{
			/*
			 * for preorder, we can use a stack that handles all the nodes.
			 * why a stack? because we can ;)
			 * 
			var stack : IStack = new LinkedList();
			stack.push(node);
			while(!stack.isEmpty()) {
			node = stack.pop() as BinaryTreeNode;
			if(node.getRight()) stack.push(node.getRight());
			if(node.getLeft()) stack.push(node.getLeft());
			visitor.visit(node);
			}
			return;
			 */
			if(node == null)
			{
				return;	
			}
			 
			visitor.visit(node);
			preOrder(node.getLeft(), visitor);
			preOrder(node.getRight(), visitor);
		}

		
		/**
		 * the postorder traversal on the tree.
		 * postorder: left, right, visit
		 * @param node the node to start with (acts as the root of the tree to traverse)
		 * @param visitor the traversal handling IBinaryTreeNodeVisitor (which might be a composite handler to improve performance of traversals)
		 * @see IBinaryTreeNodeVisitor
		 */
		public static function postOrder(node : BinaryTreeNode, visitor : ITreeNodeVisitor) : void 
		{
			//a recursive implementation is used, only preorder is easily done none recursively.		
			if(node == null)
			{
				return;	
			}
			
			postOrder(node.getLeft(), visitor);
			postOrder(node.getRight(), visitor);
			visitor.visit(node);					
		}

		
		/**
		 * the inorder traversal on the tree.
		 * inorder: left, visit, right
		 * @param node the node to start with (acts as the root of the tree to traverse)
		 * @param visitor the traversal handling IBinaryTreeNodeVisitor (which might be a composite handler to improve performance of traversals)
		 * @see IBinaryTreeNodeVisitor
		 */
		public static function inOrder(node : BinaryTreeNode, visitor : ITreeNodeVisitor) : void 
		{
			//a recursive implementation is used, only preorder is easily done none recursively.
			if(node == null)
			{
				return;	
			}		

			inOrder(node.getLeft(), visitor);
			visitor.visit(node);					
			inOrder(node.getRight(), visitor);
		}

		
		/**
		 * the levelorder traversal on the tree.
		 * levelorder: no recursive implementation, visit the nodes left to right, top to bottom
		 * @param node the node to start with (acts as the root of the tree to traverse)
		 * @param visitor the traversal handling IBinaryTreeNodeVisitor (which might be a composite handler to improve performance of traversals)
		 * @see IBinaryTreeNodeVisitor
		 */
		public static function levelOrder(node : BinaryTreeNode, visitor : ITreeNodeVisitor) : void 
		{
			var queue : IQueue = new LinkedList();
			queue.enqueue(node);
			while(!queue.isEmpty()) 
			{
				//TODO if(node == null) continue; //and just put the left and right on the queue 
				node = queue.dequeue() as BinaryTreeNode;
				visitor.visit(node);
				if(node.getLeft()) queue.enqueue(node.getLeft());
				if(node.getRight()) queue.enqueue(node.getRight());
			}
		}

		
		/**
		 * outputs the level order of the data items in the tree
		 * @inheritDoc
		 */
		public function toArray() : Array 
		{
			//level order as the default, a complete binary tree can be represented perfectly by an array (contiguous sequential representation, but array[0] should be empty)
			var node : ITreeNode = this;
			var array : Array = new Array();
			var queue : IQueue = new LinkedList();
			var iterator : IIterator;
			queue.enqueue(node);
			while(!queue.isEmpty()) 
			{
				node = queue.dequeue() as ITreeNode;
				if(node.getChildCount() != 0) 
				{
					iterator = node.getChildren().iterator();
					while(iterator.hasNext()) 
					{
						queue.enqueue(iterator.next());	
					}
				}
				array.push(node.getData());
			}
			return array;
		}

		
		/**
		 * It returns a level order iterator containing the data of the nodes.
		 * If you would like to directly handle the nodes, use BinaryTreeNode.preOrder, BinaryTreeNode.inOrder, BinaryTreeNode.postOrder or BinaryTreeNode.levelOrder instead
		 * The getting of the iterator is expensive, as a copy of the tree data is made.
		 * This also means that direct tree manipulation is not possible through the iterator, only manipulation of the data.
		 * To manipulate the tree, handle the Nodes itself.
		 * To get specific iterating behaviours (postorder, inorder, preorder) override this method.
		 * The iterator exists mainly to make it work with other ICollection instances.
		 * @inheritDoc
		 */
		public  function iterator() : IIterator 
		{
			/*
			 * create a copy in a linked list, and return the list's iterator
			 * this is a memory intensive process, as we actually create a new datastructure that duplicates the data/references
			 * Implemented as a static method.
			 */
			//			var node : BinaryTreeNode = this;
			//			var list : LinkedList = new LinkedList();
			//			var queue : IQueue = new LinkedList();
			//			queue.enqueue(node);
			//			while(!queue.isEmpty()) {
			//				node = queue.dequeue() as BinaryTreeNode;
			//				list.add(node.getData());
			//				if(node.getLeft())  queue.enqueue(node.getLeft());
			//				if(node.getRight()) queue.enqueue(node.getRight());
			//			}
			//			return list.iterator();
			var node : ITreeNode = this;
			var list : LinkedList = new LinkedList();
			var queue : IQueue = new LinkedList();
			var iterator : IIterator;
			queue.enqueue(node);
			while(!queue.isEmpty()) 
			{
				node = queue.dequeue() as ITreeNode;
				list.add(node.getData());
				if(node.getChildCount() != 0) 
				{
					iterator = node.getChildren().iterator();
					while(iterator.hasNext()) 
					{
						queue.enqueue(iterator.next());	
					}
				}
			}
			return list.iterator();
		}

		
		/**
		 * @inheritDoc
		 */
		public function toString() : String 
		{
			return "BinaryTreeNode with data: " + getData(); 
		}
	}
}
