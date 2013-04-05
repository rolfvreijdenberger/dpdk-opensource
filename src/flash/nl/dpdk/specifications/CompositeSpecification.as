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
package nl.dpdk.specifications {
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.LinkedList;		
	/**
	 * @author Rolf Vreijdenberger
	 * CompositeSpecification follows the Composite pattern.
	 * It enables the use of multiple specifications combined in one
	 * following the composite pattern, the leaf specifications can also be composites
	 * powerfull patterns can be formed by using an implementation of AbstractSpecification with the Composite
	 */
	public class CompositeSpecification extends Specification {
		private var specifications : LinkedList;

		public function CompositeSpecification() {
			specifications = new LinkedList();
		}

		
		/**
		 * adds a specification to the composite
		 * @param specification	a specification to add
		 */
		public function add(specification : ISpecification) : void {
			specifications.add(specification);
		}

		
		/**
		 * removes or tries to remove a specification from the composite
		 * @param specification	the specification to remove
		 * @return true if removal succeeded, false if specification does not exist
		 */
		public function remove(specification : ISpecification) : Boolean {
			return specifications.remove(specification);
		}

		public function contains(specification : ISpecification) : Boolean {
			return specifications.contains(specification);	
		}

		
		/**
		 * implementation of isSatisfiedBy that checks all the composites
		 */
		public override function isSatisfiedBy(candidate : *) : Boolean {

			var iterator : IIterator = specifications.iterator();
			var specification : ISpecification;
			while(iterator.hasNext()) {
				specification = iterator.next() as ISpecification;
				if(!specification.isSatisfiedBy(candidate)) {
					return false;
				}
			}
			return true;
		}

		
		/**
		 * toString implementation
		 */
		public override function toString() : String {
			return 'CompositeSpecification';	
		}
	}
}
