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
	import nl.dpdk.collections.lists.List;	

	/**
	 * An interface for rooted tree related stuff.
	 * @author Rolf Vreijdenberger
	 */
	public interface ITreeNode extends ICollection {
		/**
		 * gets the data from the node.
		 * @return the data element of any type
		 */
		function getData() : *;

		
		/**
		 * sets the data on the node.
		 * @param data a data element to set, of any type.
		 */
		function setData(data : * = null) : void

		
		/**
		 * gets the parent of the ITreeNode
		 * @return	the ITreeNode that is the parent, else null.
		 */		
		function getParent() : ITreeNode;

		
		/**
		 * gets the root ITreeNode of the tree.
		 * @return the ITreeNode that is the root of the tree structure.
		 */
		function getRoot() : ITreeNode;

		
		/**
		 * is this ITreeNode the root of the tree?
		 * @return true if the ITreeNode is the root, false otherwise.
		 */
		function isRoot() : Boolean;

		
		/**
		 * @return the number of <em>direct</em> children this ITreeNode has.
		 */
		function getChildCount() : int;

		
		/**
		 * returns the count of siblings an ITreeNode has.
		 * This is the same as the number of children of the parent minus the current ITreeNode.
		 * @return the number of brothers and sisters of our current ITreeNode.
		 */
		function getSiblingCount() : int;

		
		/**
		 * returns a List of ITreeNode instances that represent the children of the ITreeNode
		 * @return a List of ITreeNode instances.
		 */
		function getChildren() : List;

		
		/**
		 * returns a List of ITreeNode instances that represent the siblings of the ITreeNode
		 * @return a List of ITreeNode instances.
		 */
		function getSiblings() : List;

		
		/**
		 * returns the height of a tree, from the current ITreeNode
		 * @return the height of the tree, from 1 to ....
		 */
		function getHeight() : int;

		
		/**
		 * returns the level of an ITreeNode. A tree starts from level 0.
		 * @return the level of the current ITreeNode.
		 */
		function getLevel() : int;
	}
}
