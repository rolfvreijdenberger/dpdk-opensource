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

package nl.dpdk.commands 
{

	/**
	 * specifies an interface for a generic type of Command [GoF]
	 * Intent: Encapsulate a request as an object, thereby letting you parameterize clients with different requests, queue or log requests.
	 * @author rolf
	 */
	public interface ICommand 
	{
		/**
		 * The execute method which is executed somewhere at runtime when the command is invoked.
		 * Traditionally you should not provide any context to the execute method, as this implies knowledge of where the command is invoked. 
		 * Any context should be provided at command creation time, not execution time. The context provided might know how to get additional information at execution time from objects it knows about.
		 */
		function execute():void
	}
}
