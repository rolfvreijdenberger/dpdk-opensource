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
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.LinkedList;
	import nl.dpdk.collections.lists.List;	

	/**
	 * GraphNode (or vertex) is an entity in Graph related stuff.
	 * It can contain data, and in this linked representation it also keeps a reference to it's edges.
	 * A node can be manipulated by the Graph is it contained in. Edges can be added and removed etc.
	 * 
	 * Most methods are internal (not public) to encapsulate GraphNode manipulation via the Graph class.
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class GraphNode {
		/**
		 * the data item on the node
		 */
		private var data : *;
		/**
		 * a list of outgoing GraphEdges.
		 * TODO, maybe refactor to a more lightweight list implementation?
		 */
		private var edges : List;

		
		
		/**
		 * the constructor
		 * @param data	the data element of any type that we want to store on the GraphNode.
		 */
		public function GraphNode(data : * = null) {
			setData(data);
		}			
		/**
		 * get the data that this node contains.
		 */
		public function getData() : * {
			return data;
		}

		/**
		 * set the data on this node.
		 */
		public function setData(data : *) : void {
			this.data = data;
		}

		/**
		 * by checking for the existence of edges, we basically have a memory optimizer.
		 * an edgelist does not have to be created, but is only created on demand (lazy initialization)
		 */
		public function hasEdges():Boolean{
			return edges == null ? false : true;	
		}
		
		/**
		 * gets all the edges on this node.
		 * When being interested in knowing if a node has edges, use hasEdges() first.
		 * @return a List of GraphEdges
		 * @see hasEdges
		 * @see GraphEdge
		 * @see List
		 */
		internal function getEdgeList() : List {
			/**
			 * should we make this unmodifiable so a client cannot add edges directly?
			 * not necessary so, cause a client can still fuck up the references in the list, which we cannot prevent.
			 * therefore, the overhead is not justified (and at present we only have an UnmodifiableCollection which would lead to a different return type)
			 */
			if(!hasEdges()){
			 	edges = new LinkedList();
			 }
			return edges;
		}

		
		/**
		 * gets all the adjacent nodes for this node. 
		 * An adjacent node is a node we are directly connected to via an edge.
		 * The nodes are the ones this node is pointing to (outdegree)
		 * @return a List of GraphNodes
		 * @see GraphNode
		 * @see List
		 */
		internal function getAdjacencyList() : List {
			var list : List = new LinkedList();
			if(!hasEdges()){
				//no edges
				return list;	
			}
			var iterator : IIterator = getEdgeList().iterator();
			var edge : GraphEdge;
			while(iterator.hasNext()) {
				edge = iterator.next() as GraphEdge;
				list.add(edge.getNode());
			}
			return list;
		}

		
		/**
		 * adds a GraphEdge to this node. If there is already an edge pointing to the node, we just alter the weight to the new weight.
		 * @param to the GraphNode the edge should point to.
		 * @param weight the weight of the GraphEdge to be created.
		 */
		internal function addEdge(to : GraphNode, weight : Number) : void {
			//no self cycles
			if(to == this){
				return;	
			}
			if(getEdgeList().size() != 0) {
				var iterator : IIterator = getEdgeList().iterator();
				var edge : GraphEdge;
				while(iterator.hasNext()) {
					edge = iterator.next() as GraphEdge;
					if(edge.getNode() == to) {
						//same edge, just alter the weight
						edge.setWeight(weight);
						return;
					}
				}
			}
			getEdgeList().add(createEdge(to, weight));
		}

		
		/**
		 * factory method.
		 * useful for subclassing with a new kind of edge, which could have extra functionalities.
		 */
		protected function createEdge(node : GraphNode, weight : Number) : GraphEdge {
			return new GraphEdge(node, weight);
		}

		/**
		 * removes a GraphEdge to a certain node.
		 * @param to the GraphNode the edge should point to.
		 * @return true if removal was succesful, false otherwise.
		 */
		internal function removeEdge(to : GraphNode) : Boolean {
			//don't remove if there is no edgelist at all
			if(!hasEdges() || to == null){
				return false;	
			}
			//don't create iterators and stuff if it is not necessary
			if(getEdgeList().size() != 0) {
				var iterator : IIterator = getEdgeList().iterator();
				var edge : GraphEdge;
				while(iterator.hasNext()) {
					edge = iterator.next() as GraphEdge;	
					if(edge.getNode() == to) {
						return iterator.remove();	
					}
				}
			}
			return false;
		}

		/**
		 * gets a GraphEdge to a certain node.
		 * @param to the GraphNode the edge should point to.
		 * @return a GraphEdge if it exists, null otherwise.
		 */
		internal function getEdge(to : GraphNode) : GraphEdge {
			//don't remove if there is no edgelist at all
			if(!hasEdges()){
				return null;	
			}
			//don't create iterators and stuff if it is not necessary
			if(getEdgeList().size() != 0) {
				var iterator : IIterator = getEdgeList().iterator();
				var edge : GraphEdge;
				while(iterator.hasNext()) {
					edge = iterator.next() as GraphEdge;
					if(edge.getNode() == to) {
						return edge;	
					}	
				}
				return null;
			}
			return null;
		}

		/**
		 * clears the node from edges and data.
		 */
		public function clear() : void {
			edges = null;
			setData(null);
		}

	

		
		/**
		 * returns the outdegree of the node, the number of edges to other nodes.
		 */
		public function getOutDegree() : int {
			return hasEdges()  ? edges.size() : 0;
		}

		
		
		
		/**
		 * String representation of the GraphNode.
		 */
		public function toString() : String {
			return "GraphNode with data: '" + data + "' and outdegree: " + getOutDegree();
		}
	}
}
