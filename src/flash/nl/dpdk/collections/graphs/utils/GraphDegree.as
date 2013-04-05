/*Copyright (c) 2008 De Pannekoek en De Kale B.V.,  www.dpdk.nlPermission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the "Software"), to dealin the Software without restriction, including without limitation the rightsto use, copy, modify, merge, publish, distribute, sublicense, and/or sellcopies of the Software, and to permit persons to whom the Software isfurnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included inall copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS ORIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THEAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHERLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS INTHE SOFTWARE. */package nl.dpdk.collections.graphs.utils {	import nl.dpdk.collections.graphs.Graph;	import nl.dpdk.collections.graphs.GraphNode;	import nl.dpdk.collections.iteration.IIterator;	import nl.dpdk.collections.lists.List;		/**	 * gets the degree (indegree + outdegree) for all nodes in both a directed and an undirected graph.	 * It can only be used on an unchanging graph. If the graph is changed during it's lifetime, the properties on this class might be invalidated.	 * The advantage of using this class is that is preprocesses the data in time O(N+E) but then lookup on ANY node will take O(1).	 * @author rolf vreijdenberger	 */	public class GraphDegree {		/**		 * holds the degrees in a GraphNode indexed array (also possible to use a dictionary (which is a hashmap, which is based on an array :))		 */		private var degree : Array;		/**		 * local reference to the graph		 */		private var graph : Graph;		/**		 * constructor preprocesses the graph in linear time O(N+E).		 * The degree can than be retrieved in constant time O(1).		 * @param graph the graph to examine		 */		public function GraphDegree(graph : Graph) {			this.graph = graph;			degree = new Array(graph.size());			var i : int = 0;			var adjacent : List;			var iterator : IIterator;			var node : GraphNode;			for(i = 0;i < graph.size();++i) {				//initialize array				degree[i] = 0;				}												for(i = 0;i < graph.size();++i) {				adjacent = graph.getAdjacencyList(graph.get(i));				iterator = adjacent.iterator();				while(iterator.hasNext()) {					//update outgoing count, on an undirected graph, every edge is both incoming and outgoing					++degree[i];					if(graph.isDirected()) {						node = iterator.next() as GraphNode;						//a directed graph, different number of incoming and outgoing edges						//update incoming count on node						++degree[graph.getNodeIndex(node)];					}else{						//don't forget the iterator update						iterator.next();						}				}			}		}				/**		 * retrieve the degree of a GraphNode in constant time: O(1).		 * both directed and undirected graphs.		 * This is not possible when done directly on a directed graph via it's api, where every node has to be examined at runtime (which takes O(E+N) time for each N, making it O(N^2) if we want the degree of each GraphNode).		 * By preprocessing this graph in linear time, we get a more optimized way of retrieving degrees of GraphNodes.		 */		public function getDegree(node : GraphNode) : int {			return 	degree[graph.getNodeIndex(node)];		}				/**		 * clears the instance		 */		public function destroy():void{			degree = null;			graph = null;			}	}}