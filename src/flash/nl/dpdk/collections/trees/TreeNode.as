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
	import nl.dpdk.collections.core.IQueue;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.lists.LinkedList;
	import nl.dpdk.collections.trees.ITreeNode;	

	/**
	 * A TreeNode gives us a building block to build rooted trees.
	 * It allows us to traverse, add, remove and alter TreeNodes on a tree via the ICollection, ITreeNode and List interfaces.
	 * <p>
	 * A tree will be manipulated either by directly manipulating the nodes itself, via calls to getParent, getSiblings and getChildren,
	 * or it can be manipulated by the traversal mechanisms.
	 * IList manipulation on the children or siblings takes place via either the List or it's iterators.
	 * <p>
	 * Be careful to not make cyclic references, as there is no check on the TreeNode itself. A cyclic reference will cause infinite loops on the traversals of the tree.
	 * <p>
	 * It is easy/advisable to use a builder pattern as a wrapper around this class to facilitate the tree building.
	 * 
	 * @see List
	 * @see ICollection
	 * @see ITreeNode
	 * @author Rolf Vreijdenberger
	 */
	public class TreeNode implements ITreeNode {
		private var data : *;
		private var parent : TreeNode;
		private var children : List;

		/**
		 * Construct a TreeNode consisting of data and an optional reference to a parent TreeNode
		 * @param data	the data item to store in the TreeNode
		 * @param parentNode	an optional reference to a parent node. we will become it's rightmost child when created in this way.
		 */
		public function TreeNode(data : * = null, parentNode : TreeNode = null) {
			setData(data);
			setParentNodeAtConstruction(parentNode);
		}

		
		/**
		 * helper method for the constructor
		 * @return void	this needs to be as fast as possible
		 */
		private function setParentNodeAtConstruction(parentNode : TreeNode) : void {
			if(parentNode != null) {
				parentNode.addNode(this);
			}
		}

		
		/**
		 * factory method for getting a new node.
		 * a hook for overriding by subclassing this class so that each instance of the subclass creates and uses instances of the subclas.
		 * This method is the only method that creates a node in this class.
		 */
		protected function getTreeNode(data : * = null) : TreeNode {
			return new TreeNode(data);
		}

		
		/**
		 * one of the node handlers, also updates the parent reference.
		 * @param node the TreeNode to add as a child.
		 */
		internal function addNode(node : TreeNode) : void {
			getChildren().add(node);
			node.setParentNode(this);
		}

		
		/**
		 * @inheritDoc
		 */
		public final function getData() : * {
			return data;
		}

		
		/**
		 * @inheritDoc
		 */
		public final function getParent() : ITreeNode {
			return parent;
		}

		
		/**
		 * @inheritDoc
		 */
		public final function getRoot() : ITreeNode {
			var root : ITreeNode = this;
			while (!root.isRoot()) {
				root = root.getParent();	
			}
			return root;
		}

		
		/**
		 * @inheritDoc
		 */
		public final function isRoot() : Boolean {
			return getParent() == null;
		}

		
		/**
		 * @inheritDoc
		 */
		public function getChildCount() : int {
			/**
			 * this method is used throughout the code, to make sure we use lazy instantiation for the childlist.
			 * we only want to create an instance of the List of the children when it is necessary.
			 */
			if(children == null) {
				return 0;
			}
			return getChildren().size();
		}

		
		/**
		 * @inheritDoc
		 */
		public final function getSiblingCount() : int {
			if(getParent() == null) {
				return 0;	
			} 
			return parent.getChildCount() - 1;	
		}

		
		/**
		 * Note: when using this method, a new list is always created when it is does not yet exist on this node.
		 * This might be memory intensive when there are lots of nodes.
		 * By using <code>getChildCount() != 0</code> first, a client can make sure there are children, without creating a list if there are nor children.
		 * @inheritDoc
		 */
		public final function getChildren() : List {
			/*
			 * We do not want to make this unmodifiable. 
			 * We want to be able to manipulate this List from the client and insert, remove and alter the nodes directly.
			 * The tradeoff is exposure of the tree structure via the List by the client versus a larger interface and more code for the TreeNode
			 */
			if(children == null) {
				/*
				 * memory optimizer for creating the childlist only when necessary.
				 */
				createChildren(); 	
			}
			return children;
		}

		
		/**
		 * @inheritDoc
		 * gets the highest path in the tree
		 */
		public function getHeight() : int {
			var height : int = 1;
			var maxSubTreeHeight : int = 0;
			if(getChildCount() != 0) {
				var tempHeight : int = 0;
				var node : ITreeNode;
				var iterator : IIterator = getChildren().iterator();
				while(iterator.hasNext()) {
					node = iterator.next();
					//recursion
					tempHeight = node.getHeight();
					if(tempHeight > maxSubTreeHeight) {
						maxSubTreeHeight = tempHeight;	
					}
				}
			}
			return height + maxSubTreeHeight;
		}

		
		/**
		 * @inheritDoc
		 */
		public final function getLevel() : int {
			if(isRoot()) return 0;
			//recursion
			return 	getParent().getLevel() + 1;
		}

		
		/**
		 * Add data as the rightmost child of the current TreeNode
		 * @param data the data item to add as a child of the current TreeNode. 
		 */
		public function add(data : *) : void {
			addNode(getTreeNode(data));
		}

		
		/**
		 * sets the parent node. Also handles the pointer from  the parent to us
		 * we don't make this public to stop a client from making recursive implementations in an easy way.
		 * @param node a tree node, can default to null (the node becomes a root for it's subtree).
		 * @return true if succeeded, false otherwise (mainly for null pointers)
		 */
		internal function setParentNode(node : TreeNode = null) : Boolean {
			if(this == node) {
				//self reference
				throw new Error("self reference for parent node not allowed for " + this.getData());	
			}
			//if there currently is a parent, remove us from our parent's childlist, to remove our parent's reference to us
			if(parent) {
				parent.getChildren().remove(this);	
			}
			
			//set the new parent (or null pointer)
			parent = node;

			if(node == null) {
				return false;
			}
			return true;
		}

		
		/**
		 * recursively clears the TreeNode and it's subtree and removes all internal references and data references.
		 * @inheritDoc
		 */
		public function clear() : void {
			if(getChildCount() != 0) {
				var iterator : IIterator = getChildren().iterator();
				var node : ITreeNode;
				while(iterator.hasNext()) {
					node = iterator.next() as ITreeNode;
					node.clear();
				}	
			//clear our data, and references to us
			}
			createChildren();
			setParentNode(null);
			setData(null);
		}

		
		/**
		 * helper method. only used to define the type of List we use internally.
		 * This might be useful in subclassing/extending the TreeNode.
		 */
		protected function createChildren() : void {
			/**
			 * Throughout the code, you will find (memory) optimizations by making sure we use lazy creation on the child list.
			 */
			children = new LinkedList();
		}

		
		/**
		 * @inheritDoc
		 */
		public function contains(data : *) : Boolean {
			/**
			 * check the whole tree in level order
			 */
			var node : ITreeNode = this;
			var queue : IQueue = new LinkedList();
			var iterator : IIterator;
			queue.enqueue(node);
			while(!queue.isEmpty()) {
				node = queue.dequeue() as ITreeNode;
				//check if the data is what we are looking for
				if(node.getData() == data) {
					return true;
				}
				if(node.getChildCount() != 0) {
					iterator = node.getChildren().iterator();
					while(iterator.hasNext()) {
						queue.enqueue(iterator.next());	
					}
				}
			}
			return false;
		}

		
		/**
		 * @inheritDoc
		 * any children?
		 */
		public function isEmpty() : Boolean {
			return children.size() == 0;
		}

		
		/**
		 * @inheritDoc
		 * also removes the subtree of the node containing the data.
		 */
		public function remove(data : *) : Boolean {
			var node : ITreeNode = this;
			var queue : IQueue = new LinkedList();
			var iterator : IIterator;
			queue.enqueue(node);
			while(!queue.isEmpty()) {
				node = queue.dequeue() as ITreeNode;
				//does this node contain the data we are looking for?
				if(node.getData() == data) {
					node.clear();
					return true;
				}
				if(node.getChildCount() != 0) {
					iterator = node.getChildren().iterator();
					while(iterator.hasNext()) {
						queue.enqueue(iterator.next());	
					}
				}
			}
			return false;
		}

		
		/**
		 * @inheritDoc
		 */
		public function size() : int {
			/**
			 * lazy count, watch out...
			 * this is a recursive call
			 */
			if(getChildCount() == 0) {
				return 1;
			}
			var iterator : IIterator = getChildren().iterator();
			var count : int = 1;
			var node : ITreeNode;
			while(iterator.hasNext()) {
				node = iterator.next() as ITreeNode;
				count += node.size();	
			}
			return count;
		}

		
		/**
		 * @inheritDoc
		 * creates a copy of the <em>data</em> of the tree, that cannot be used to manipulate the tree.
		 * The copy is created in levelOrder.
		 * mainly for use with other collections or for doing a simple traversal over the data.
		 */
		public function iterator() : IIterator {
			var node : ITreeNode = this;
			var list : LinkedList = new LinkedList();
			var queue : IQueue = new LinkedList();
			var iterator : IIterator;
			queue.enqueue(node);
			//loop throug all nodes in level order
			while(!queue.isEmpty()) {
				node = queue.dequeue() as ITreeNode;
				list.add(node.getData());
				if(node.getChildCount() != 0) {
					iterator = node.getChildren().iterator();
					while(iterator.hasNext()) {
						queue.enqueue(iterator.next());	
					}
				}
			}
			return list.iterator();
		}

		
		public final function setData(data : * = null) : void {
			this.data = data;
		}

		
		/**
		 * @inheritDoc
		 */
		public function getSiblings() : List {
			var siblings : List = new LinkedList();
			if(getParent() != null) {
				var iterator : IIterator = getParent().getChildren().iterator();
				var node : ITreeNode;
				while(iterator.hasNext()) {
					node = iterator.next() as ITreeNode;
					if(node != this) {
						//all the nodes except me
						siblings.add(node);	
					}
				}
			}
			return siblings;
		}

		
		/**
		 * depthfirst is a tree traversal algorithm that is analogous to a postorder traversal on a binary tree.
		 * @param node the ITreeNode from  which we want to start our traversal.
		 * @param visitor the concrete visitor that will be used to handle the visting of an ITreeNode
		 * @see ITreeNodeVisitor
		 */
		public static function depthFirst(node : ITreeNode, visitor : ITreeNodeVisitor) : void {
			if(node.getChildCount() != 0) {
				var iterator : IIterator = node.getChildren().iterator();
				var nextNode : ITreeNode;
				while(iterator.hasNext()) {
					nextNode = iterator.next() as ITreeNode;
					//recursion
					depthFirst(nextNode, visitor);	
				}
			}
			visitor.visit(node);
		}

		
		/**
		 * breadthfirst is a tree traversal algorithm that is analogous to a preorder traversal on a binary tree.
		 * @param node the ITreeNode from  which we want to start our traversal.
		 * @param visitor the concrete visitor that will be used to handle the visting of an ITreeNode
		 * @see ITreeNodeVisitor
		 */
		public static function breadthFirst(node : ITreeNode, visitor : ITreeNodeVisitor) : void {
			//TODO, change to preOrder
			visitor.visit(node);
			if(node.getChildCount() != 0) {
				var iterator : IIterator = node.getChildren().iterator();
				var nextNode : ITreeNode;
				while(iterator.hasNext()) {
					nextNode = iterator.next() as ITreeNode;
					//recursion
					breadthFirst(nextNode, visitor);	
				}
			}
		}

		
		/**
		 * levelOrder is a tree traversal algorithm that traverses the tree level by level.
		 * From top to bottom, left to right.
		 * @param node the ITreeNode from  which we want to start our traversal.
		 * @param visitor the concrete visitor that will be used to handle the visting of an ITreeNode
		 * @see ITreeNodeVisitor
		 */
		public static function levelOrder(node : ITreeNode, visitor : ITreeNodeVisitor) : void {
			var queue : IQueue = new LinkedList();
			queue.enqueue(node);
			while(!queue.isEmpty()) {
				node = queue.dequeue() as ITreeNode;
				visitor.visit(node);
				if(node.getChildCount() != 0) {
					var iterator : IIterator = node.getChildren().iterator();
					while(iterator.hasNext()) {
						queue.enqueue(iterator.next());	
					}
				}
			}
		}

		

		
		/**
		 * @inheritDoc
		 */
		public function toArray() : Array {
			//do a traversal and return the array representation
			var node : ITreeNode = this;
			var array : Array = new Array();
			var queue : IQueue = new LinkedList();
			queue.enqueue(node);
			while(!queue.isEmpty()) {
				node = queue.dequeue() as ITreeNode;
				array.push(node.getData());
				/**
				 * the next check makes it less fast for large structures, but saves us the creation of an iterator when the node does not have children.
				 * This means it is mainly a memory optimizer, and also a  speed optimizer for childless nodes.
				 * this is also the case for methods like size() etc.
				 * this is a possible optimizer depending on the type of application.
				 */
				if(node.getChildCount() != 0) {
					var iterator : IIterator = node.getChildren().iterator();
					while(iterator.hasNext()) {
						queue.enqueue(iterator.next());	
					}
				}
			}
			return array;
		}

		
		/**
		 * @inheritDoc
		 */
		public function toString() : String {
			return "TreeNode with data: " + getData();
		}
	}
}
