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
	import nl.dpdk.loader.tasks.LoadTask;
	import nl.dpdk.specifications.Specification;

	/**
	 * Selects the LoadTask with the given URL from the collection.
	 * 
	 * @see LoadTask
	 * 
	 * @author Thomas Brekelmans
	 */
	final public class LoadTaskByURLSpecification extends Specification
	{
		private var url:String;
		
		public function LoadTaskByURLSpecification(url:String) 
		{
			this.url = url;
		}
		
		override public function isSatisfiedBy(candidate:*):Boolean
		{
			var loadTask:LoadTask = candidate as LoadTask;
					
			return loadTask.getUrl() == this.url;
		}
	}
}
