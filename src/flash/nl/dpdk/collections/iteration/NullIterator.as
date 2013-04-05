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

package nl.dpdk.collections.iteration {
	import nl.dpdk.collections.iteration.IIteratorExtended;				

	/**
	 * A default iterator that has no functionality for something that really has no normal iterator implementation
	 * @author Rolf Vreijdenberger
	 */
	public class NullIterator implements IIteratorExtended {
		public function hasNext() : Boolean {
			return false;
		}

		
		public function next() : * {
			return null;
		}

		
		public function remove() : Boolean {
			return false;
		}

		
		public function insert(data : *) : void {
		}

		
		public function begin() : void {
		}

		
		public function end() : void {
		}

		
		public function hasPrevious() : Boolean {
			return false;
		}

		
		public function previous() : * {
			return null;
		}

		
		public function set(data : *) : Boolean {
			return false;			
		}
	}
}
