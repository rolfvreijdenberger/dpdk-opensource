/*
Copyright (c) 2009 De Pannekoek en De Kale B.V.,  www.dpdk.nl

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
package nl.dpdk.loader.specifications {
	import nl.dpdk.loader.ExtensionToDataType;
	import nl.dpdk.specifications.Specification;

	/**
	 * Checks if the given ExtensionToDataType exists in the collection.<br/>
	 * This is usually done by passing a reference to the desired ExtensionToDataType to the specification.
	 * 
	 * @see ExtensionToDataType
	 * 
	 * @author Thomas Brekelmans
	 */
	final public class ExtensionToDataTypeExistsSpecification extends Specification
	{
		private var extensionToDataType:ExtensionToDataType;
		
		public function ExtensionToDataTypeExistsSpecification(extensionToDataType:ExtensionToDataType) 
		{
			this.extensionToDataType = extensionToDataType;
		}

		override public function isSatisfiedBy(candidate:*):Boolean
		{
			var l:ExtensionToDataType = candidate as ExtensionToDataType;
			
			return extensionToDataType.dataType == l.dataType && extensionToDataType.extension == l.extension; 
		}
	}
}
