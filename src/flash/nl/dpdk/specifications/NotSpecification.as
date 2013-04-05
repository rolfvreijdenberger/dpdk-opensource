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

	/**
	 * @author Rolf Vreijdenberger
	 * The NotSpecification allows a negation of a ISpecification
	 * It basically negates the specification provided
	 * It can be used standalone or throug the AbstractSpecification implementation
	 */
	public class NotSpecification extends Specification 
	{
		private var specification : ISpecification;

		
		public function NotSpecification(specification : ISpecification)
		{
			this.specification = specification;
		}

		
		public override function isSatisfiedBy(candidate : *) : Boolean
		{
			return !specification.isSatisfiedBy(candidate);	
		}

		
		/**
		 * toString implementation
		 */
		public override function toString() : String
		{
			return 'NotSpecification';	
		}
	}
}
