/*
Copyright (c) 2008 De Pannekoek en De Kale B.V.,  www.dpdk.nl

Permission is hereby granted, free of charge, to any person obtainnl.dpdk.collections.trees.graphs.ConnectedComponentsfiles (the "Software"), to deal
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

package nl.dpdk.collections.graphs.utils {
	import nl.dpdk.collections.graphs.Graph;
	import nl.dpdk.collections.graphs.GraphNode;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.IList;
	
	import flash.utils.Dictionary;		
	/**
	 * Util class that checks whether there are any connected components in an undirected graph.
	 * undirected graph only!! For a directed graph use strongly connected components algorithm.
	 * It can only be used on an unchanging graph. If the graph is changed during it's lifetime, the properties on this class might be invalidated.
	 * Calculation takes place during the construction of an instance of this class in linear time O(N+E).
	 * The other methods will then take constant time.
	 * @author Rolf Vreijdenberger
	 */
	public class ConnectedComponents {
		private var graph : Graph;
		private var connectedComponent : int = 0;
		private var connections : Dictionary = new Dictionary(true);
		private static const SENTINEL : int = -1;
				/**
		 * The constructor calculates the connectivity stuff of the Graph.
		 * time proportional to O(E+N).
		 * @param graph the undirected graph to calculate the properties of.
		 */
		public function ConnectedComponents(graph : Graph) {
			if(!graph.isDirected()) {
			
				this.graph = graph;
				var size : int = graph.size();
				var node : GraphNode;
				//set all nodes in the dictionary to a sentinel value
				for(var i : int = 0;i < size;++i) {
					node = graph.get(i);
					connections[node] = SENTINEL;	
				}
			
				//now check them and update
				for(i = 0;i < size;++i) {
					node = graph.get(i);
					if(connections[node] == SENTINEL) {
						countConnections(node);
						++connectedComponent;	
					}	
				}
			}else {
				trace("ConnectedComponents constructor called with a directed graph. processing not done.");	
			}
		}
		/**
		 * helper method to count the connections
		 */
		private function countConnections(node : GraphNode) : void {
			connections[node] = connectedComponent;
			var adjacent : IList = graph.getAdjacencyList(node);
			var iterator : IIterator = adjacent.iterator();
			var target : GraphNode;
			while(iterator.hasNext()) {
				target = iterator.next() as GraphNode;
				if(connections[target] == SENTINEL) {
					countConnections(target);	
				}
			}
		}
		/**
		 * gets the number of connected components in an udnirected Graph
		 * @return the number of connected components. 0 when the graph is directed
		 */
		public function getConnectionCount() : int {
			return connectedComponent;	
		}
		/**
		 * checks if two GraphNodes are connected on an undirected Graph.
		 * They have to be in the same Graph of course, else the result will not make sense.
		 */
		public function getConnected(a : GraphNode, b : GraphNode) : Boolean {
			if(a == null || b == null) {
				return false;
			}
			return connections[a] == connections[b];
		}
		/**
		 * clears the instance, destroy references
		 */
		public function destroy() : void {
			connections = null;
			graph = null;
			connectedComponent = 0;	
		}
	}
}
