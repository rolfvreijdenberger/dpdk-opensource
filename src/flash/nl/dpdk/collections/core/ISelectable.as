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

package nl.dpdk.collections.core {
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.specifications.ISpecification;	
	
	/**
	 * An interface that explicitely says we can select stuff from the instance by using specifications.
	 * @see ISpecification
	 * @see List
	 * @author Rolf Vreijdenberger
	 */
	public interface ISelectable {
		
		/**
		 * This method lets a client select a new list containing the items that were retrieved from the current list by the specification.
		 * Specification follows the specification pattern, and is used to encapsulate business logic in an object, making it more maintainable and explicit throughout the code.
		 * The items in the List should be casted by the client to the right type.
		 * Searching will probably take time proportional to O(N), lineair time, for most implementations.
		 * @see ISpecification
		 * @param specification a concrete specification.
		 * @return a new List with the data that was satisfied by the specification.
		 */
		function selectBy(specification : ISpecification) : List
	}
}
