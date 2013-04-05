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

package nl.dpdk.collections.graphs {
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.core.IQueue;
	import nl.dpdk.collections.core.ISelectable;
	import nl.dpdk.collections.core.IStack;
	import nl.dpdk.collections.core.UnmodifiableCollection;
	import nl.dpdk.collections.graphs.utils.EdgeByDestinationSpecification;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.iteration.UnmodifiableIterator;
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.LinkedList;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.specifications.ISpecification;
	
	import flash.utils.Dictionary;	
	/**
	 * this Graph class represents a weighted, directed or undirected, not neccesarily connected, potentially cyclic graph that is ideal for sparse Graphs as it is based on the adjacency list implementation.
	 * It disallows parrallel edges and self cycles. The Graph can be used for both dynamic and static graphs, but lots of the utilities provided in this package can be invalidated when used on changing graphs (this is normal in graph algorithms)
	 * 
	 * 
	 * This implementation is not based on integer value access of nodes but on reference based access.
	 * It's internal implementation uses a dictionary for quick lookup of GraphNodes.
	 * This gives some memory overhead for the dictionary storage and the removal procedure must make an extra pass over all Nodes to update indices.
	 * Since integer based positions in a graph do not really have a useful meaning in Graph algorithms (maybe for positions in embedded graphs, but that data should be stored in the GraphNodes itself),
	 * and graphs in flash cannot be very large because of cpu processing, the reference based access is justified and very convenient.
	 * Removal generally is not a process that will be done much on a graph, only in very dynamic processing. Consider an alternative if that is the case.
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class Graph implements ICollection, ISelectable {
		//the id of the graph class
		private var id : String;
		/**
		 * the list of nodes in the graph
		 */
		private var nodes : List;
		/**
		 * allows for a quick index lookup, at the cost of more memory usage, this is a tradeoff justified in flash,
		 * where we cannot process too much nodes because of a lack of cpu power, but we will use (relatively small) graphs and want to process them.
		 * Also, it allows for an api which is not based on integer values (which we would have in an adjacency matrix implementation)
		 */
		private var nodeIndex : Dictionary;
		/**
		 * is this graph directed or undirected?
		 * In this implementation, two edges will be added for two nodes to specify the undirected connection.
		 */		private var directed : Boolean;

		/**
		 * The constructor
		 * @param id an id to identify a graph
		 * @param directed some algorithms can only be meaningfully executed on a directed graph, others only on undirected graphs. This graph structure is optimized for undirected graphs, but we allow a directed implementation.
		 */
		public function Graph(id : String = "graph@dpdk.nl", directed : Boolean = true) {
			//store the id			this.id = id;
			//directed graph or not
			this.directed = directed;
			//arraylist allows for constant time lookup
			nodes = new ArrayList();
			//dictionary provides a mapping from a GraphNode to the arraylist position
			nodeIndex = new Dictionary(true);
		}

		
		/**
		 * adds data to the Graph. The data can be a GraphNode or data of any type, which will be converted to a GraphNode
		 * time proportional to O(1).
		 * @param data this can be either a GraphNode, or data of any type, which will be converted to a GraphNode.
		 */
		public function add(data : *) : void {
			var node : GraphNode;
			if(data is GraphNode) {
				node = data;
				/*
				//if the graph is directed, we need to set some incoming edges as well
				//currently not necessary, as we can only add edges via the Graph interface, and not via the GraphNode interface
				//therefore we know we do not have any edges on this node
				if(directed) {
					if(node.hasEdges()) {
						var iterator : IIterator = node.getEdgeList().iterator();
						var edge : GraphEdge;
						while(iterator.hasNext()) {
							edge = iterator.next() as GraphEdge;
							//add the same edge back to the node we're adding
							edge.getNode().addEdge(node, edge.getWeight());
						}
					}
				}
				 */
			}else {
				//by using a factory method, we allow subclassing of node types in the Graph structure
				node = createNode(data);
			}
			nodes.add(node);
			//store position of node in nodes list in the the dictionary
			nodeIndex[node] = nodes.size() - 1;
		}

		
		/**
		 * factory method.
		 * hook for subclassing.
		 * Override to create a different type of GraphNode, for example a TileNode in a tile based game.
		 */
		public function createNode(data : *) : GraphNode {
			return new GraphNode(data);
		}

		
		/**
		 * get a node at a certain index. 
		 * This method will be used in a more formal sense and for some external algorithms, as Graph processing often takes place based on an integer based naming scheme for nodes.
		 * time proportional to O(1).
		 * @param i the index to get the node from.
		 * @return a GraphNode or null if there is no node or the index is invalid.
		 */
		public function get(i : int) : GraphNode {
			return nodes.get(i);	
		}

		
		/**
		 * sets a node at a certain index.  This overwrites the data already there.
		 * if the index is invalid, the node is added.
		 * If the node is already in the graph, nothing happens.
		 * time proportional to O(1) when the node is added. worst case time O(E+N) when a node is overwritten and all references need to be cleared.
		 * @param data this can be either a GraphNode, or data of any type, which will be converted to a GraphNode.
		 */
		public function set(i : int, data : *) : void {
			var current : GraphNode = nodes.get(i);
			if(data is GraphNode) {
				if(data == current || contains(data)) {
					//no overwriting of same data (useless) and no moving of nodes allowed
					return;	
				}
				//check if we are out of bounds
				if(i >= nodes.size()) {
					nodes.add(data);
					nodeIndex[data] = nodes.size() - 1;
					return;
				}
				//ok, so it's a new node we're setting, overwrite the data
				removeEdgesTo(current);
				delete nodeIndex[current];
				nodes.set(i, data);
				nodeIndex[data] = i;
			}else {
				//data is not a GraphNode, normal data
				if(current == null) {
					//out of bounds or null data
					current = createNode(data);
					if(i >= nodes.size()) {
						//out of bounds	
						nodes.add(current);
						nodeIndex[current] = nodes.size() - 1;
						return;
					}
					//normal flow, not out of bounds, overwrite the data
					nodes.set(i, current);
					nodeIndex[current] = i;
					return;
				}	
				
				//existing node, overwrite
				removeEdgesTo(current);
				delete nodeIndex[current];
				current = createNode(data);
				nodes.set(i, current);
				nodeIndex[current] = i;
			}
		}

		/**
		 * clear the whole graph of its contents
		 */
		public function clear() : void {
			nodes = new ArrayList();
			nodeIndex = new Dictionary(true);
		}

		
		/**
		 * Check whether the graph contains a certain piece of data.
		 * time proportional to O(N) for non GraphNode data. for grahpnode data it is constant time
		 * @param data This can be either a GraphNode to look for, or if it is not a GraphNode, the data in the GraphNode.
		 */
		public function contains(data : *) : Boolean {
			if(data is GraphNode) {
				return nodeIndex[data] != null;
			}else {
				var iterator : IIterator = nodes.iterator();
				var check : GraphNode;
				while(iterator.hasNext()) {
					check = iterator.next() as GraphNode;
					if(check.getData() == data) {
						return true;
					}
				}	
			}
			return false;
		}
		
		/**
		 * Check if there are any GraphNodes in this Graph.
		 * time proportional to O(1).
		 * @inheritDoc
		 */
		public function isEmpty() : Boolean {
			return nodes.size() == 0;
		}
		
		/**
		 * removes data from the Graph. The data can be a GraphNode or untyped data.
		 * All edge references to the node will also be removed from the nodes pointing to this node by their edge.
		 * time proportional to O(E+N).
		 * this is a know penalty for any implementation of removal of a node for an adjacency list implementation of a graph
		 * @param data this can be either a GraphNode, or data of any type, which will be searched for on GraphNode.
		 * @return true if the removal was succesful, false otherwise
		 */
		public function remove(data : *) : Boolean {
			if(data is GraphNode) {
				updateIndexesForRemoval(data);
				return removeEdgesToAndRemove(data);
			}else {
				var iterator : IIterator = nodes.iterator();
				var current : GraphNode;
				while(iterator.hasNext()) {
					current = iterator.next() as GraphNode;
					if(current.getData() == data) {
						removeEdgesTo(current);
						updateIndexesForRemoval(current);
						return iterator.remove();
					}
				}	
			}
			return false;
		}

		/**
		 * because we use an internal dictionary to keep track of the index position in the nodes list,
		 * it's necessary to update references whenever we remove a GraphNode from the graph.
		 * This takes linear time
		 */
		private function updateIndexesForRemoval(node : GraphNode) : void {
			var iterator : IIterator = nodes.iterator();
			var current : GraphNode;
			var found : Boolean = false;
			while(iterator.hasNext()) {
				current = iterator.next() as GraphNode;
				if(found) {
					nodeIndex[current] = nodeIndex[current] - 1;	
				}
				if(node == current) {
					//we found the node we're removing, flag it so we can update all indexes of nodes that follow
					found = true;	
					nodeIndex[node] = null;
				}
			}
		}

		
		
		
		/**
		 * adds an edge from a certain node to another node, with an optional weight.
		 * For directed graphs, the edge will be made from the 'to' node to the 'from' node as well, with the same weight.
		 * disallows duplicate edges.
		 * time proportional to O(1).
		 */
		public function addEdge(from : GraphNode, to : GraphNode, weight : Number = 1) : void {
			from.addEdge(to, weight);	
			if(!directed) {
				//add an incoming edge too
				to.addEdge(from, weight);	
			}
		}

		
		
		
		/**
		 * gets the number of edges to this node.
		 * time proportional to O(N+E), for directed graphs, time proportional to O(1)
		 * @param to the node we want to have the incoming edges for
		 * @return the number of edges that have this node as their sink.
		 */
		public function getInDegree(to : GraphNode) : int {
			if(!directed){
				//trace('to.getOutDegree: ' + to.getOutDegree());
				return to.getOutDegree();	
			}
			var iterator : IIterator = nodes.iterator();
			var node : GraphNode;
			var count : int = 0;
			while(iterator.hasNext()) {
				node = iterator.next() as GraphNode;
				if(node.getEdge(to) != null) {
					++count;	
				}
			}
			return count;
		}

		
		
		
		/**
		 * gets the outdegree for a certain node, the number of edges that have this node as their source.
		 * time proportional to O(1).
		 * @return	the number of edges that have this node as their source.
		 */
		public function getOutDegree(from : GraphNode) : int {
			return from.getOutDegree();
		}
		
		/**
		 * gets the degree for a specific graphNode.
		 * For undirected graphs, this is an expensive operation as all the edges and nodes have to be checked: O(N+E).
		 * for directed graphs, time proportional to O(1).
		 * Be sure to interpret this in the right way for undirected graphs as the outdegree is the same as the indegree is the same as the degree. (see the implementation notes).
		 * @param from the node we are interested in
		 * @return the number of edges coming in and going out of this node
		 */
		public function getDegree(from: GraphNode): int {
			if(!directed){
				return from.getOutDegree();	
			}
			return from.getOutDegree() + getInDegree(from);	
		}

		
		
		
		/**
		 * Get the incoming edges to a specific node.
		 * time proportional to O(N+E).
		 * @param to the GraphNode all edges should point to
		 * @return a list containg the nodes that have an outgoing edge to the specified node
		 */
		public function getEdgesTo(to : GraphNode) : List {
			var iterator : IIterator = nodes.iterator();
			var node : GraphNode;
			var edge : GraphEdge;
			var list : List = new LinkedList();
			while(iterator.hasNext()) {
				node = iterator.next() as GraphNode;
				edge = node.getEdge(to);
				if(edge != null) {
					list.add(edge);
				}
			}
			return list;
		}

		
		
		/**
		 * Get the outgoing edges from a specific node.
		 * direct lookup on a Node.
		 * time proportional to O(1).
		 * @param node the node we want to have the outgoing edges from
		 * @return a list containing the outgoing edges
		 */
		public function getEdgesFrom(node : GraphNode) : List {
			return node.getEdgeList();	
		}

		
		
		
		/**
		 * removes an edge from a certain node to another node.
		 * For directed graphs, both the incoming and outgoing edge are removed
		 * @param from the source node
		 * @param to the destination node
		 * @return true if the edge removal was succesful, false otherwise
		 */
		public function removeEdge(from : GraphNode, to : GraphNode) : Boolean {
			if(from == null || to == null) {
				return false;	
			}
			if(!directed) {
				return from.removeEdge(to) && to.removeEdge(from);	
			}
			return from.removeEdge(to);	
		}

		
		
		/**
		 * Get the edge from one node to another
		 * @param from the graphNode we want to get the edge from.
		 * @param to the graphNode we want the edge to point to
		 * @return the GraphEdge if found, null otherwise.
		 */
		public function getEdge(from : GraphNode, to : GraphNode) : GraphEdge {
			if(from == null || to == null) {
				return null;	
			}
			return from.getEdgeList().selectBy(new EdgeByDestinationSpecification(to)).get(0);
		}

		
		/**
		 * returns the index of a GraphNode in the internal representation.
		 * Whenever the graph is updated, this value might be invalidated for a client.
		 * @return the index of the GraphNode if present, -1 otherwise
		 */
		public function getNodeIndex(node : GraphNode) : int {
			return nodeIndex[node] == null ? -1 : nodeIndex[node];	
		}

		
		
		
		/**
		 * breadthFirst and DepthFirst are traversal algorithms for a Graph.
		 * The implementation is non recursive.
		 * As the Graph need not be connected, the starting node may or may not have a path to all other nodes.
		 * When wanting to traverse all other nodes, use one of the utility classes provided or use the iterator.
		 * time proportional to O(N+E) for connected components.
		 * The traversal can be stopped by returning false from the visitor's visit() method.
		 * @see nl.dpdk.collection.trees.graphs.utils.BreadtFirstSearch
		 * @param node the GraphNode to start from
		 * @param visitor an IGraphNodeVisitor that handles each node that is touched.
		 */
		public function breadthFirst(node : GraphNode, visitor : IGraphNodeVisitor) : void {
			if(node == null) {
				return;	
			}
			var queue : IQueue = new LinkedList();
			queue.enqueue(node);
			var targetNode : GraphNode;
			var marked : Dictionary = new Dictionary(true);
			var iterator : IIterator;
			marked[node] = true;
			while(!queue.isEmpty()) {
				node = queue.dequeue() as GraphNode;	
				if(!visitor.visit(node)) {
					//the visitor indicated he does not want to be visited anymore
					return;	
				}
				if(node.getOutDegree() == 0) {
					continue;	
				}
				iterator = node.getAdjacencyList().iterator();
				while(iterator.hasNext()) {
					targetNode = iterator.next() as GraphNode;
					if(marked[targetNode] != true) {
						marked[targetNode] = true;
						queue.enqueue(targetNode);
					}
				}
			}
		}

		
		/**
		 * breadthFirst and DepthFirst are traversal algorithms for a Graph.
		 * The implementation is non recursive.
		 * As the Graph need not be connected, the starting node may or may not have a path to all other nodes.
		 * time proportional to O(N+E) for connected components.
		 * The traversal can be stopped by returning false from the visitor's visit() method.
		 * @param node the GraphNode to start from
		 * @param visitor an IGraphNodeVisitor that handles each node that is touched.
		 */
		public function depthFirst(node : GraphNode, visitor : IGraphNodeVisitor) : void {
			if(node == null) {
				return;	
			}
			var stack : IStack = new LinkedList();
			var marked : Dictionary = new Dictionary(true);
			stack.push(node);
			var targetNode : GraphNode;
			var iterator : IIterator;
			marked[node] = true;
			while(!stack.isEmpty()) {
				node = stack.pop() as GraphNode;
				if(!visitor.visit(node)) {
					//the visitor indicated he does not want to be visited anymore
					return;	
				}
				if(node.getOutDegree() == 0) {
					continue;	
				}
				iterator = node.getAdjacencyList().iterator();
				while(iterator.hasNext()) {
					targetNode = iterator.next() as GraphNode;
					if(marked[targetNode] != true) {
						marked[targetNode] = true;
						stack.push(targetNode);
					}
				}
			}
		}

		
		/**
		 * helper method
		 */
		private function removeEdgesToAndRemove(node : GraphNode) : Boolean {
			if(node == null) {
				return false;	
			}
			var iterator : IIterator = nodes.iterator();
			var currentNode : GraphNode;
			var removed : Boolean = false;
			while(iterator.hasNext()) {
				currentNode = iterator.next() as GraphNode;
				currentNode.removeEdge(node);
				if(currentNode == node) {
					removed = iterator.remove();
					//node.clear();//have the client do this	
					nodeIndex[node] == null;
				}
			}
			return removed;
		}

		
		/**
		 * time proportional to O(E+N).
		 */
		private function removeEdgesTo(node : GraphNode) : void {
			if(node == null) {
				return;	
			}
			var iterator : IIterator = nodes.iterator();
			var currentNode : GraphNode;
			while(iterator.hasNext()) {
				currentNode = iterator.next() as GraphNode;
				currentNode.removeEdge(node);
			}
		}

		
		
		/**
		 * select GraphNodes based on a certain rule.
		 * time proportional to O(N). This will go over all Nodes even if there are disconnected components.
		 * @inheritDoc
		 */
		public function selectBy(specification : ISpecification) : List {
			return nodes.selectBy(specification);
		}
		/**
		 * returns the adjacency list for a specific graphnode
		 * @param node the graphnode we want the adjacancy list from
		 * @return the list of adjacent nodes (from an outgoing edge)
		 */
		public function getAdjacencyList(node : GraphNode ) : List {
			return node.getAdjacencyList();	
		}

		/**
		 * the number of all the nodes in the graph.
		 * time proportional to O(1).
		 * @inheritDoc
		 */
		public function size() : int {
			return nodes.size();
		}
		
		
				/**		 * time proportional to O(N)
		 * @inheritDoc
		 */
		public function toArray() : Array {
			return nodes.toArray();
		}

		
		/**
		 * returns an unmodifiable Iterator that contains all the GraphNodes in this Graph.
		 * we only want nodes to be removed through the graph interface, not by the iterator.
		 * Use the iterator to find nodes (but preferably use the depthFirst or breadthFirst algorithms) and then remove the nodes.
		 * The iterator is perfect for wanting to visit all the nodes in the graph. The other traversal algorithms will only visit the nodes in one forest / connected component. 
		 * @inheritDoc
		 * @see getNodes()
		 */
		public function iterator() : IIterator {
			return new UnmodifiableIterator(nodes.iterator());		}

		/**
		 * gets an unmodifiable collection of all the nodes.
		 * @see iterator()
		 */
		public function getNodes(): ICollection {
			return new UnmodifiableCollection(nodes);	
		}
		
		/**
		 * @inheritDoc
		 */		public function toString() : String {
			return "Graph:  '" + id + "' of size: " + nodes.size();		}

		/**
		 * check if this graph is directed or not.
		 * Some algorithms only run meaningfully on directed graphs, others only on undirected graphs
		 */
		public function isDirected() : Boolean {
			return directed;
		}	}
}
