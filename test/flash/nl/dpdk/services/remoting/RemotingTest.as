package nl.dpdk.services.remoting {	import asunit.framework.TestCase;
	import nl.dpdk.collections.lists.LinkedList;	import nl.dpdk.collections.sets.ResultRow;	import nl.dpdk.collections.sets.ResultSet;	
	/**	 * all asynchronous test methods are now in place. 	 * more info on asynchronous testing:	 * http://www.asserttrue.com/articles/2008/01/22/developing-visual-components-with-asunit	 */	public class RemotingTest extends TestCase {		private var instance : RemotingProxy;		private var triggeredTimeOut: Function;		/**		 * constructor		 */		public function RemotingTest(testMethod : String = null) {			super(testMethod);			trace("RemotingTest.RemotingTest(testMethod)");			instance = new RemotingProxy("http://playground.dpdk.nl/projects/osdpdk/amfphp/gateway.php", "Test");			instance.addEventListener(RemotingEvent.ERROR_ASYNC, onErrorAsync);			instance.addEventListener(RemotingEvent.ERROR_IO, onErrorIO);			instance.addEventListener(RemotingEvent.ERROR_NETSTATUS, onErrorNetStatus);			instance.addEventListener(RemotingEvent.ERROR_SECURITY, onErrorSecurity);			instance.addEventListener(RemotingEvent.ERROR_TIMEOUT, onTimeOut);			//instance.addHeader("myLogin", false, {name: "username", password: 'password'});		}				private function onTimeOut(event : RemotingEvent) : void {			trace("RemotingTest.onTimeOut(event): expected timeout");			trace(event.getMessage());			//we test this by calling the return value of the addAsync method.			triggeredTimeOut();		}						public function testTimeOutInsideTimeOut(): void {			trace("RemotingTest.testTimeOutInsideTimeOut()");			//set it on the instance, after 2,5 seconds, we make the call timeout after 3 seconds, but the async error will get called after 5 seconds.			//in other words, the timeout will be called, onTimeOut() will be called, and we have to call timeOutActivated to prevent an async error. If this happens, everything works as expected			instance.setTimeOut(2500);			instance.addHandler('testTimeOut', onTimeOutResult, onTimeOutStatus);			//call the remote method (timeout after 3 seconds, which is longer than 2.5 seconds, the return value should not be retrieved but discarded)			//timeout handler will ca called			instance.testTimeOut(3);			//reset the timeout thinngie			instance.setTimeOut(0);			//make sure this method gets called within 5 seconds, to prevent failure. capture the return value of the addasync to call later.			triggeredTimeOut = addAsync(timeOutActivated, 5000);			}				private function onTimeOutStatus(status: StatusData) : void {			trace("RemotingTest.onTimeOutStatus(status)");			fail('timeoutstatus should not get called, the timeout should have taken place for this test');		}		private function onTimeOutResult(result: ResultData) : void {			trace("RemotingTest.onTimeOutResult(result)");			fail('timeoutstatus should not get called, the timeout should have taken place for this test');					}		private function timeOutActivated() : void {			trace("RemotingTest.timeOutActivated()");		}						public function testNumber() : void {			trace("testNumber");			instance.testNumber(666);			instance.addHandler("testNumber", addAsync(onNumber, 2000), onNumberStatus);		}
		public function testBoolean() : void {			trace('testBoolean');							instance.addHandler("testBoolean", addAsync(onBoolean, 2000), onBooleanStatus);			instance.testBoolean(true);		}
		public function testString() : void {			trace('testString');			instance.addHandler("testString", addAsync(onString, 2000), onStringStatus);			instance.testString("a", "b", {id: 3, name: 'lala'});		}
		public function testObject() : void {						trace('testObject()');			instance.addHandler("testObject", addAsync(onObject), onObjectStatus);			instance.testObject({id:12, name: 'osdpdk'});		}
		public function testResultSet() : void {			trace('testResultSet()');			instance.addHandler("testGetResultSet", addAsync(onGetResultSet), onGetResultSetStatus);			instance.testGetResultSet();		}
		public function testFloat() : void {			trace('testFloat()');			instance.addHandler("testFloat", addAsync(onFloat), onFloatStatus);			instance.testFloat(1.23);		}
		public function testNonExistent() : void {			trace('testNonExistent()');			//no callback defined			instance.testNonExistent();		}
		public function testError() : void {			trace('testError()');			instance.addHandler("testError",onError,  addAsync(onErrorStatus));			instance.testError();			}		
		
		
		private function onErrorStatus(status : StatusData) : void {			trace("RemotingTest.onErrorStatus(status): expected error");			assertEquals(status.getLevel(), 'Unknown error type');//			trace(status.getDescription());//			trace(status.getCode());//			trace(status.getDetails());//			//check the level//			trace(status.getLevel());//			trace(status.getLine());		}
		
		private function onError(result : ResultData) : void {			trace("RemotingTest.onError(result)");			fail('should not be here, an error is always returned');		}		
		private function onFloatStatus(status : StatusData) : void {
			trace("RemotingTest.onFloatStatus(status)");			trace(status.getDescription());			trace(status.getCode());			trace(status.getDetails());			trace(status.getLevel());			trace(status.getLine());		}		
		private function onFloat(result : ResultData) : void {
			trace("RemotingTest.onFloat(result)");			assertFalse(result.isResultSet());			assertEquals('twice the input value', result.getResult(), 2.46);		}
		
		private function onGetResultSetStatus(status : StatusData) : void {			trace("RemotingTest.onGetResultSetStatus(status)");			fail(status.getDescription());		}
		
		private function onGetResultSet(result : ResultData) : void {			trace("RemotingTest.onGetResultSet(result)");			assertTrue(result.isResultSet());			var rs : ResultSet = result.getResult();			//trace("columns: " + rs.getColumns().toString());			//trace("rows: " + rs.getRows().toArray().toString());			assertEquals(rs.getColumns().size(), 4);			assertEquals(rs.getRows().size(), 5);			var row : ResultRow;			for(var i : int = 0;i < rs.size();++i) {//use iterator alternatively				row = rs.getRowAt(i);				assertEquals('row ' + i +' is i + 1', row.test_id, (i+1));				assertEquals('row.getId() is i for this one resultset, if not, check that no other ResultRows have been created elsewhere in the testsuite', row.getId(), i);				//trace(row.getId() + ": " + row.test_id + ", " + row.test_name + ", " + row.test_data + ", " + row.test_double);			}		}
		
		private function onStringStatus(status : StatusData) : void {			trace("RemotingTest.onStringStatus(status)");			//tested, done			trace(status.getDescription());			trace(status.getCode());			trace(status.getDetails());			trace(status.getLevel());			trace(status.getLine());			fail(status.getDescription());
		}
		
		private function onString(result : ResultData) : void {			trace("RemotingTest.onString(result)");			//done			assertFalse(result.isResultSet());			trace(result.getResult());			assertTrue('result is string', result.getResult() is String);
		}
		
		private function onObjectStatus(status : StatusData) : void {			trace("RemotingTest.onObjectStatus(status)");						trace(status.getDescription());			trace(status.getCode());			trace(status.getDetails());			trace(status.getLevel());			trace(status.getLine());			fail(status.getDescription());
		}
		
		private function onObject(result : ResultData) : void {			trace("RemotingTest.onObject(result)");			assertFalse(result.isResultSet());			assertEquals('id property twice the original', result.getResult().id, 24);
			assertEquals('name property concatenated with "remoting"', result.getResult().name, "osdpdk remoting");
		}
		
		private function onBooleanStatus(status : StatusData) : void {			trace("RemotingTest.onBooleanStatus(status)");			trace(status.getDescription());			trace(status.getCode());			trace(status.getDetails());			trace(status.getLevel());			trace(status.getLine());			fail(status.getDescription());
		}
		
		private function onBoolean(result : ResultData) : void {			trace("RemotingTest.onBoolean(result)");			assertFalse(result.isResultSet());			assertFalse("Inverted Boolean result" ,result.getResult());
		}
		
		private function onNumberStatus(status : StatusData) : void {			trace("RemotingTest.onNumberStatus(status)");			trace(status.getDescription());			trace(status.getCode());			trace(status.getDetails());			trace(status.getLevel());			trace(status.getLine());			fail(status.getDescription());
		}
		
		private function onNumber(result : ResultData) : void {			trace("RemotingTest.onNumber(result)");			assertFalse(result.isResultSet());			assertEquals("Number diveded by 2", result.getResult(), 333);			
		}
		
		private function onErrorSecurity(event : RemotingEvent) : void {			trace("RemotingTest.onErrorSecurity(event)");			fail(event.getMessage());		}
		
		private function onErrorNetStatus(event : RemotingEvent) : void {			trace("RemotingTest.onErrorNetStatus(event)");			fail(event.getMessage());		}
		
		private function onErrorIO(event : RemotingEvent) : void {			trace("RemotingTest.onErrorIO(event)");			fail(event.getMessage());		}
		
		private function onErrorAsync(event : RemotingEvent) : void {			trace("RemotingTest.onErrorAsync(event)");			fail(event.getMessage());		}
		
		/**		 * test some properties of resultdata		 */
		public function testResultData() : void {			trace("RemotingTest.testResultData()");			var rs : ResultSet = new ResultSet(new LinkedList());			var data : ResultData = new  ResultData(rs);			assertTrue(data.isResultSet());						data = new ResultData('test');			assertFalse(data.isResultSet());			data = new ResultData(1);			assertFalse(data.isResultSet());			data = new ResultData(new Array());			assertFalse(data.isResultSet());			data = new ResultData(new Object());			assertFalse(data.isResultSet());			data = new ResultData(true);			assertFalse(data.isResultSet());		}	}}