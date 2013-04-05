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

	/**
	 * An Edge / Arc is the term for a connection between Graph Nodes. 
	 * An Edge that is directed (has direction) is also referred to as an Arc in mathematical graph terminology.
	 * This is a directed edge that has a weight associated to it (a cost), which can be used for path and flow calculations.
	 * negative weights are disallowed.
	 * 
	 * A great trick: for vertex/node weighted calculations, just store the weight of the node on the vertex, to allow normal graph algorithms to do the work for you!!!
	 * @author Rolf Vreijdenberger
	 */
	public class GraphEdge {
		private var weight : Number;
		private var node : GraphNode;
		public static const  WEIGHT_NORMAL : Number = 1;

		public function GraphEdge(to : GraphNode, weight : Number = WEIGHT_NORMAL) {
			setNode(to);
			setWeight(weight);
		}

		/**
		 * gets the weight, or cost of the edge
		 */
		public function getWeight() : Number {
			return weight;
		}

		/**
		 * sets a positive weight on the edge
		 * @param weight the weight/cost of traversing this edge. also see the comments at the top of this class about node weighted implementations.
		 */
		public function setWeight(weight : Number) : void {
			if(weight < 0) weight = 0;
			this.weight = weight;
		}

		/**
		 * return the node the edge is pointed to.
		 */
		public function getNode() : GraphNode {
			return node;
		}

		
		private function setNode(to : GraphNode) : void {
			this.node = to;
		}

		
		public function toString() : String {
			return "GraphEdge to GraphNode: '" + node + "' with weight: " + getWeight();
		}
	}
}
