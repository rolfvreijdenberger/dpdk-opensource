package nl.dpdk.services.remoting {
	import nl.dpdk.collections.lists.LinkedList;
	/**
		public function testBoolean() : void {
		public function testString() : void {
		public function testObject() : void {
		public function testResultSet() : void {
		public function testFloat() : void {
		public function testNonExistent() : void {
		public function testError() : void {
		
		
		private function onErrorStatus(status : StatusData) : void {
		
		private function onError(result : ResultData) : void {
		private function onFloatStatus(status : StatusData) : void {
			trace("RemotingTest.onFloatStatus(status)");
		private function onFloat(result : ResultData) : void {
			trace("RemotingTest.onFloat(result)");
		
		private function onGetResultSetStatus(status : StatusData) : void {
		
		private function onGetResultSet(result : ResultData) : void {
		
		private function onStringStatus(status : StatusData) : void {
		}
		
		private function onString(result : ResultData) : void {
		}
		
		private function onObjectStatus(status : StatusData) : void {
		}
		
		private function onObject(result : ResultData) : void {
			assertEquals('name property concatenated with "remoting"', result.getResult().name, "osdpdk remoting");
		}
		
		private function onBooleanStatus(status : StatusData) : void {
		}
		
		private function onBoolean(result : ResultData) : void {
		}
		
		private function onNumberStatus(status : StatusData) : void {
		}
		
		private function onNumber(result : ResultData) : void {
		}
		
		private function onErrorSecurity(event : RemotingEvent) : void {
		
		private function onErrorNetStatus(event : RemotingEvent) : void {
		
		private function onErrorIO(event : RemotingEvent) : void {
		
		private function onErrorAsync(event : RemotingEvent) : void {
		
		/**
		public function testResultData() : void {