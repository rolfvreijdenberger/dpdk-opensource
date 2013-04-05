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
	 * Interface for specifications, used to check if an object satisfies a criterium.
	 * A specification encapsulates bussiness logic for validation or selection in a seperate object from the domain object.
	 * Keeping the domain object uncluttered, and providing a general way to select/search/validate throughout the application, keeping the bussiness logic seperate in the specifications instead of scattered through code.
	 * see www.martinfowler.com for the specification pattern.
	 * 
	 * ISpecification constructors can be enhanced with parameters to be able to make more dynamically adjustable specification
	 * The isSatisfiedBy() method can contain any logic we might wish to implement.
	 * The only functionality should be to check whether or not a certain object meets a certain criterium.
	 * The criterium is implemented in the ISpecification.
	 * @author Rolf Vreijdenberger
	 */
	public interface ISpecification {
		/**
		 * is the specifications satisfied by a candidate object?
		 * this method is implemented by the implementor of the interface to return if a candidate meets the criteria in the method body
		 * @param candidate an object/primitive of any type
		 * @return true if candidate meets the criteria
		 */
		function isSatisfiedBy(candidate : *) : Boolean
		
		/**
		 * chains different specifications with an "and" construction
		 * Both the current specification AND the newly provided specification have to be met in order to be true
		 * @param specification the other specification
		 * @return a new ISpecification object containing both the original and the new specification
		 */		function and(specification : ISpecification) : ISpecification
		
		/**
		 * chains different specifications with an "or" construction
		 * Both the current specification OR the newly provided specification have to be met in order to be true
		 * @param specification the other specification
		 * @return a new ISpecification object containing both the original and the new specification
		 */		function or(specification : ISpecification) : ISpecification
		
		/**
		 * negates isSatisfiedBy()
		 * chains the current specifications with a "not" construction
		 * @return a new ISpecification object containing the negated version of the original
		 */		function not() : ISpecification
	}
}
