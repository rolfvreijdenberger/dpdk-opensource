﻿package nl.dpdk.test {
	import asunit.framework.TestSuite;
	{
		/**
		 * Constructor which adds all available tests to the list.
		 */
		public function RemotingTests() 
		{	

			trace("RemotingTests.RemotingTests()");
			
			addTest(new RemotingTest());

		}
	}
}