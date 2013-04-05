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
	import nl.dpdk.collections.core.ICollection;	

	/**
	 * a queue is a FIFO (First in First Out) structure.
	 * The first thing that gets put/enqueued on a queue is the first to come out.
	 * 
	 */	public interface IQueue extends ICollection {
		/**
		 * Lets the client take a look at what is next in the queue, without removing it from the queue
		 * very convenient for an asynchronous queue where we load stuff. take a peek, load the stuff, if result/error, update the object and dequeue, then continue in sequence
		 * @return the data or null if queue is empty
		 */
		function peek() : *;

		/**
		 * enqueue the data (put the data on the queue)
		 * @param data the data item we wish to put on the queue
		 */		function enqueue(data : *) : void;

		/**
		 * dequeue / remove the data from the queue.
		 * @return the data item that is next to come out of the queue, or null if queue is empty
		 */		function dequeue() : *;
	}
}
