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
package nl.dpdk.loader 
{

	/**
	 * This class defines five levels of priority that can be assigned to a loader.
	 * Assigning is done via the Loader constructor or via it's setPriority method at runtime.
	 * 
	 * <p>Priorities are used internally by the LoaderManager class to determine which task
	 * of which Loader is going to load next. This is determined each time a task finishes.</p>
	 * 
	 * The intended use of / some guidelines for these priorities is / are:
	 * 1) Do not modify the priority of a loader unless you really have to. Having each Loader
	 * at the HIGHEST priority still defeats the purpose.
	 * 2) Only set the priority via the constructor to a higher value than NORMAL if your 
	 * absolutely sure it's a critical process on which other parts of your system depend.
	 * 3) Change the priority of a Loader to a higher priority at runtime when for example a user 
	 * enters a new screen and it's assets haven't been loaded yet. Change it back to a lower 
	 * (than NORMAL) priority when the user leaves that screen again. 
	 * 4) Communicate with your team members about decisions ove priorities, you do not want a
	 * user loading in loads of background images / music when he should be loading the news
	 * feed in the view that's actually in front of him first.
	 * 5) If two Loader's with the same priority exist, the LoaderManager will bias towards the
	 * currently loading Loader. If no Loader is active (when the first task is chosen in the
	 * queue, it will pick the Loader that is executed (and therefor registered) first. 
	 * NOTE: Actually, the loading starts as soon as the first Loader is executed, so watch
	 * the Order of Execution in you program.
	 * 
	 * <p>Be a good citizen when using priorities.</p>
	 * 
	 * <p>The default priority of a Loader is NORMAL.</p> 
	 * 
	 * @see Loader
	 * @see LoaderComparator
	 * 
	 * @author Thomas Brekelmans
	 */
	public class Priorities 
	{
		public static const HIGHEST:uint = 5;
		public static const HIGH:uint = 4;
		public static const NORMAL:uint = 3;
		public static const LOW:uint = 2;
		public static const LOWEST:uint = 1;
	}
}
