package nl.dpdk.services 
{
	import nl.dpdk.services.gephyr.DrupalData;
	import nl.dpdk.services.gephyr.DrupalProxy;
	import nl.dpdk.services.gephyr.DrupalUtils;

	import flash.display.Sprite;

//		import mx.utils.ObjectUtil;


	/**
	 * This is not a unittest, it's just a custom test used to test some services manually in different configurations
	 * @author rolf
	 */
	[SWF(width="600", height="600", backgroundColor="0x2C3054", frameRate="31")]

	public class DrupalProxyTest extends Sprite 
	{
		private var service:DrupalProxy;

		/**
		 * constructor
		 */
		public function DrupalProxyTest() 
		{
			service = new DrupalProxy("http://development.dpdk.nl/projects/dpdk/dpdk_admin/services/amfphp", true);// "36080b1d746d5a2039614d73b6f5e260", "development.dpdk.nl");

			trace("DrupalProxyTest.DrupalProxyTest()");
			//the generic error event

			service.setErrorHandler(errorHandler);
			service.setTimeOut(5000, timeOutHandler);
			
			
			service.setHandler("system", "connect", onSysConnect, onSysConnectError);
			service.setHandler("node", "get", onNodeGet, onNodeGetStatus);
			service.setHandler("user", "get", onUserGet, onUserGetStatus);
			service.setHandler("user", "login", onUserLogin, onUserLoginStatus);
			service.setHandler("user", "logout", onUserLogout, onUserLogoutStatus);
			
			service.invoke("system", "connect");
//			service.invoke('views', "get", "faq", new Array("nid"));
		}

		
		
		
		public function errorHandler(data:DrupalData):void
		{
			trace("DrupalProxyTest.onUserLoginStatus(data)id : " + data.getRemoteCallId() + ": " + data.getMessage());
		}

		public function timeOutHandler(data:DrupalData):void
		{
			trace("DrupalProxyTest.onUserLoginStatus(data)id : " + data.getRemoteCallId() + ": " + data.getMessage());
		}

		public function onUserLoginStatus(data:DrupalData):void
		{
			trace("DrupalProxyTest.onUserLoginStatus(data)id : " + data.getRemoteCallId() + ": " + data.getMessage());
		}

		public function onUserGet(data:DrupalData):void
		{
			trace("DrupalProxyTest.onUserGet(data)id:  " + data.getRemoteCallId() + ': ' + data.getData());
		}

		
		public function onUserGetStatus(data:DrupalData):void
		{
			trace("DrupalProxyTest.onUserGetStatus(data)id : " + data.getRemoteCallId() + ": " + data.getMessage());
		}

		private function onSysConnectError(data:DrupalData):void 
		{
			trace("DrupalProxyTest.onSysConnectError(data): " + data.getMessage());
		}

		private function onSysConnect(data:DrupalData):void 
		{
			trace("DrupalProxyTest.onSysConnect(data)" + data.getData());
			trace("DupalProxyTest.onSysConnect sessionId: " + service.getSessionId());
			trace(service.getUser().user.userid);
			service.setRemoteCallId("user login rolf");
			service.invoke("user", "login", "rolf", "rolf");

			service.setRemoteCallId("node4Four");
			service.invoke("node", "get", 4, new Array("nid", "title"));
			
			
			service.setRemoteCallId("node5Five");
			service.invoke("node", "get", 5);
			service.setRemoteCallId("menuGetId");
			service.invoke("menu", "get", DrupalUtils.MENU_PRIMARY);
			
			service.setRemoteCallId("nonexistent thing called");
			service.invoke("service", "nonexistent", 1234, 5678);
			service.setRemoteCallId("get the user 1 ONE");
			service.invoke("user", "get", 1);
			
			service.setRemoteCallId("get the user 2 TWO");
			service.invoke("user", "get", 2);
			
			
			
			service.setRemoteCallId("ubercart getcart call");
			service.invoke("ubercart", "getCart");
			//OKE, it works, no need to test any further

			service.setRemoteCallId("crazy call");
			service.invoke("nonexistent", "methodWithLoadsOfParamsCHeckOutHTTPSniffer", 1, "two", false, new Array("1", "2"), Math.random());
		}

		private function onNodeGetStatus(data:DrupalData):void 
		{
			trace("DrupalProxyTest.onNodeGetStatus(data): " + data.getMessage());
		}

		
		
		
		
		
		private function onNodeGet(data:DrupalData):void 
		{
			switch(data.getRemoteCallId())
			{
				case "user":
					break;
				case "home":
					break;				
			}
			trace("DrupalTest.onNodeGet(data) callId: " + data.getRemoteCallId() + ": nid" + data.getData().nid + ", " + data.getData().title);
			
		}

		
		
		

		private function onUserLogout(data:DrupalData):void 
		{
			trace("DrupalProxyTest.onUserLogout(data):" + data.getData());
			trace("DrupalProxyTest.onUserLogout() sessionId: " + service.getSessionId());
		}

		private function onUserLogoutStatus(data:DrupalData):void 
		{
			trace("DrupalProxyTest.onUserLogoutStatus(data): " + data.getMessage());
		}
		
		
		
		
		
		
		public function onUserLogin(data:DrupalData):void
		{
			trace("DrupalProxyTest.onUserLogin(data)id:  " + data.getRemoteCallId() + ': ' + data.getData());

			service.setRemoteCallId("user logout rolf");
			service.invoke("user", "logout");
			
			//TODO: fix this, drupal gives an AMFPHP error atm
		}
	}
}
