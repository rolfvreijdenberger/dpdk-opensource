package nl.dpdk.services.gephyr {
	import nl.dpdk.collections.dictionary.HashMap;
	import nl.dpdk.utils.StringUtils;

	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;

	/**
	 * DrupalProxy is an amf remoting wrapper for all basic and custom drupal services and the standard for connecting with a drupal based backend
	 * http://drupal.org/node/109782
	 * 
	 * Make sure your services modules are configured correctly with the right permissions, keys etc.
	 * permissions allowing anonymous or logged in users to connect to services and do actions on content, based on their roles etc.
	 *  
	 * D6 Authentication keys are a security risk in flash, as flash can be decompiled and hardcoding an authentication key will mean anyone can view the key.
	 * authentication info: http://drupal.org/node/394224
	 * For flash, security can also be had by creating multiple users with different roles in drupal, thereby giving them different security clearances.
	 * authentication keys are used so 1 specific call cannot be duplicated, even if it is intercepted by a man in the middle attack.
	 * But since the key can be read from flash by decompiling it, a hacker can then write a client that could potentially do malicious stuff to the site.
	 * This is where the domain name is important, as it specifies a domain for which the key is valid.
	 * DrupalProxy has a dependency on the com.hurlant.crypto package, which is licensed under BSD.
	 * 
	 * 
	 * D7 session authentication is the standard D7 session authentication mechanism. It is different from the D6 implementation.
	 * 
	 * For the specifics of what to send to the drupal services, see documentation on drupal.org
	 * For the specifics on what to receive from drupal services, see documentatation on drupal.org and use an http sniffer.
	 * It is very easy to get data from drupal to flash, especially so with the cck module, check it out.

	 * 
	 * More information can be found on 
	 * - www.drupal.org/project/services
	 * - www.drupal.org/project/amfserver (D7)
	 * - www.drupal.org/project/amfphp (D6)
	 * 
	 * 
	 * @see nl.dpdk.services.gephyr.DrupalEvent
	 * @see nl.dpdk.services.gephyr.DrupalData
	 * TODO: use security object as Interface to be passed in constructor for future implementations maybe?
	 * 
	 * TODO: this class is in the process of being refactored for D7. it works as it is, but the api might change because of ongoing implementations for D7
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	public class DrupalProxy {
		// id of version 7, the present drupal implementation
		public static const VERSION_7 : uint = 7;
		// id of current version of drupal
		public static const VERSION_6 : uint = 6;
		// default version
		protected var version : uint = VERSION_7;
		// the gateway of your drupal setup
		private var gateway : String;
		// class that holds data about the security policy, can be used by subclasses to get all parameters for the security policy used.
		private var security : DrupalSecurity;
		// the data associated with the single next call to a service method
		private var remoteCallId : String;
		// holds the handlers for result and status for a unique service/method pair
		private var callMapper : HashMap;
		// the netconnection on which we call our remoting methods
		private var netConnection : NetConnection;
		// the timeOut value if a call has no response, defaults to 0 (no timeout)
		private var timeOut : int = 0;
		// the user object for the logged in user
		protected var user : Object;
		// default timeout handler
		private var timeOutHandler : Function;
		private var errorHandler : Function;
		// generic handlers to provide hooks for inside this package (@see DrupalInvokeTask)
		private var genericResultHandler : Function;
		private var genericStatusHandler : Function;
		private var genericErrorHandler : Function;
		private var genericTimeOutHandler : Function;
		private var sessionName : String;

		/**
		 * @param gateway String the gateway (D6) or endpoint (D7) you will connect to.
		 * @param version uint the version of drupal you will connect to. either DrupalProxy.VERSION_7 or DrupalProxy.VERSION_6. defaults to 7 in case of wrong input
		 * @param requireSession only for D6 (session authentication)
		 * @param key only for d6 (key authentication)
		 * @param domain only for d6 (key authentication)
		 */
		public function DrupalProxy(gateway : String, version : uint, requireSession : Boolean = false, key : String = '', domain : String = '') {
			// the gateway to the backend
			this.gateway = gateway;
			// handles the security issues for drupal
			setVersion(version);
			setSecurity(new DrupalSecurity(requireSession, key, domain));
			// default version
			callMapper = new HashMap();
			netConnection = new NetConnection();
			netConnection.objectEncoding = ObjectEncoding.AMF3;

			addNetConnectionListeners();
			connect();
		}

		/**
		 * the master manipulator, call your method on the remote service here
		 * this method takes the service name and the method name to call, along with any arguments you will need to pass to the remote method.
		 * 
		 * 
		 * @param service String the service name
		 * @param method String the method name
		 * @param args a variable number of arguments of any type expected by the remote method
		 * 
		 * Core services are: system, node, user, file, views, menu, taxonomy
		 * see drupal.org and the services module for method names and signatures of core calls
		 * this might be used from within subclasses too, do your preprocessing first before calling this one
		 */
		public final function invoke(service : String, method : String, ...args) : void {
			// do the magic
			args.unshift(method);
			args.unshift(service);
			doItNow.apply(null, args);
		}

		/**
		 * sets the error handler which will handle all errors.
		 * The error handler you implement in the client of DrupalProxy will have a DrupalData object as it's only argument.
		 */
		public function setErrorHandler(errorHandler : Function) : void {
			this.errorHandler = errorHandler;
		}

		/**
		 * core routine that handles the arguments and security aspects and calls the backend
		 */
		private function doItNow(...args) : void {
			var method : String = args[1];
			var service : String = args[0];
			var name : String = serviceAndMethodFormat(service, method);
			// remove the first two arguments, service and method
			args.shift();
			args.shift();

			// we will build a new arguments list for the remote method call
			var callArguments : Array = new Array();

			if (getVersion() == VERSION_6) {
				// different ways of doing things in version 6 (amfphp module) and 7 (amfserver module)

				// prime the security object
				security.prepare();
				// check what needs to be done and build an arguments list depending on the security settings
				if (security.sessionAndKey()) {
					callArguments.unshift(getSessionId());
					callArguments.unshift(security.getNonce());
					callArguments.unshift(security.getTimeStamp());
					callArguments.unshift(security.getDomain());
					callArguments.unshift(security.getHash(name));
				} else if (security.keyOnly()) {
					callArguments.unshift(security.getNonce());
					callArguments.unshift(security.getTimeStamp());
					callArguments.unshift(security.getDomain());
					callArguments.unshift(security.getHash(name));
				} else if (security.sessionOnly()) {
					callArguments.unshift(getSessionId());
				} else if (security.noSessionNoKey()) {
					trace("DrupalProxy: no session and no key: no security");
				}
			} else if (getVersion() == VERSION_7) {
				// we can always use drupal sessions from D7 and services 3, but this is specifically for standalone clients (flash player, authoring tool, air etc)
				netConnection.addHeader("amfserver", false, {sessid:getSessionId(), session_name:getSessionName()});
			}
			// build final array of arguments, first add the arguments that were used on the invoke() method call (without service name and method name
			callArguments = callArguments.concat(args);

			// finally, add the service and the method name at the beginning of the arguments list
			callArguments.unshift(method);
			callArguments.unshift(service);
			// do the remoting thing by calling an internal helper function with the complete arguments list
			remoteCall.apply(null, callArguments);
			// reset the callId
			setRemoteCallId("");
		}

		private function getSessionName() : String {
			return sessionName;
		}

		/**
		 * internal method that actually calls the service method and creates the state to hold when we get the result
		 * @param args a list of arguments of which the first two MUST be the name of the service and the name of the method to be called
		 */
		private function remoteCall(...args) : void {
			// trace(args);
			var methodCall : String = serviceAndMethodFormat(args[0], args[1]);
			// remove service name and method name
			args.shift();
			args.shift();
			// the responder object that handles the response from the remote call.
			var responder : Responder = new DrupalResponder(methodCall, onResult, onStatus, onTimeOut, timeOut, getRemoteCallId());
			// construct an array with all the necessary parameters for netconnection.call()
			var callArguments : Array = [methodCall, responder];

			// if there are arguments left, concatenate them
			if (args.length > 0) {
				callArguments = callArguments.concat(args);
			}

			// call the remote service method with the correct arguments
			netConnection.call.apply(null, callArguments);
		}

		/**
		 * helper method
		 */
		protected final function getRemoteCallId() : String {
			return this.remoteCallId;
		}

		/**
		 * default result handler for each remote call via netconnection
		 * use the hook "hookHandleResult" to handle/alter the data according to the name (service/method pair) of the original call in your subclass
		 */
		private function onResult(name : String, data : *, remoteCallId : String) : void {
			// handle normal 'core' drupal results.
			handleResult(name, data, remoteCallId);

			var dd : DrupalData = new DrupalData(data, remoteCallId, "");
			var handler : Function;
			var mapper : DrupalCallMapper = callMapper.search(name);
			if (mapper) {
				handler = mapper.getResult();
				handler(dd);
			} else {
				trace("DrupalProxy.onResult(name, data, remoteCallId): no handler found for " + name);
				trace("DrupalProxy.onResult(): use drupalProxy.addHandler() to add handlers for " + name);
			}

			if (genericResultHandler != null) {
				genericResultHandler(dd);
			}
		}

		/**
		 * default status/error handler for each remote call
		 * Some core methods need to set some data on this proxy, for example the session data and the user data when calls fail
		 * You could subclass DrupalProxy and use hookHandleStatus to use your own implementations for your calls
		 */
		private function onStatus(name : String, data : *, remoteCallId : String) : void {
			// handle normal 'core' drupal stuff
			handleStatus(name, data, remoteCallId);

			var handler : Function;
			var mapper : DrupalCallMapper = callMapper.search(name);

			// build DrupalData object
			var dd : DrupalData = new DrupalData(data, remoteCallId, "");
			if (data.description != null) {
				dd = new DrupalData(data, remoteCallId, data.description);
			} else if (data.faultString != null) {
				// do amf0 and amf3 handle error objects differently? I saw this as being flex.messaging.messages.ErrorMessage somewhere...
				dd = new DrupalData(data, remoteCallId, data.faultString);
			}

			if (mapper) {
				// call the method that handles status/errors
				handler = mapper.getStatus();
				handler(dd);
			} else {
				trace("DrupalProxy.onStatus(name, data, remoteCallId): no handler found for " + name);
				trace("DrupalProxy.onStatus(): use drupalProxy.addHandler() to add handlers for " + name);
				trace("DrupalProxy.onStatus(): " + data.description);
			}

			// check and call generic handler
			if (genericStatusHandler != null) {
				genericStatusHandler(dd);
			}
		}

		/**
		 * core hooks are implemented here.
		 * This method is called whenever normal result data comes back from drupal.
		 * It is used to do some specific stuff that needs to be done after specific method calls succeed.
		 * Some core methods need to set some data on this proxy, for example the session data and the user data.
		 * You could subclass DrupalProxy and use hookHandleResult to use your own implementations for your calls
		 */
		private function handleResult(name : String, data : *, remoteCallId : String) : void {
			switch(name) {
				case "system.connect":
					setSessionId(data.sessid);
					user = data.user;
					break;
				case "user.login":
					// the logged in user object is stored in the DrupalService.
					// on logout, it is removed again
					if (getVersion() == VERSION_6) {
						user = data;
						// change the sessionId, it is changed for a logged in user
						security.setSessionId(user.sessid);
					}
					if (getVersion() == VERSION_7) {
						setSessionName(data.session_name);
						setSessionId(data.sessid)
						user = data.user;
					}
					break;
				case "user.logout":
					if (StringUtils.toBoolean(data)) {
						// logout succeeded, remove the currently logged in user
						user = null;
						// TODO, does this change the sessionId?
						if (getVersion() == VERSION_7) {
							setSessionName('');
							setSessionId('');
						}
					}
					break;
			}
		}

		/**
		 * check if we are currently logged in via this proxy to the drupal backend
		 */
		public function isLoggedIn() : Boolean {
			if (getVersion() == VERSION_6) {
				if (user && user.userid) {
					return user.userid != 0;
				} else {
					return false;
				}
			}
			if (getVersion() == VERSION_7) {
				if (user && user.uid) {
					return user.uid != 0;
				} else {
					return false;
				}
			}
			return false;
		}

		/**
		 * core hooks are implemented here.
		 * This method is called whenever status/error data comes back from drupal.
		 * It is used to do some specific stuff that needs to be done after specific method calls fail.
		 * Some core methods need to set some data on this proxy, for example the session data and the user data.
		 * You could subclass DrupalProxy and use hookHandleStatus to use your own implementations for your failed calls
		 */
		private function handleStatus(name : String, data : *, remoteCallId : String) : void {
			// add core hooks for calls that did not succeed
			switch(name) {
				case "user.logout":
					// logout did not succeed, probably not even logged in. but clear anyway
					user = null;
					setSessionName('');
					setSessionId('');
					break;
			}
		}

		/**
		 * set a timeout on this instance. 
		 * The default timeout is 0, which means NO timeout detection.
		 * Every remote method that takes longer than this timeOut time will trigger the callback method which will get a DrupalData instance passed in as the only parameter
		 * On top of that, if there is a result after the timeout period it will be discarded.
		 * @param timeOut the timeout period in milliseconds. To be set correctly, it must be either 0 or more than 250 milliseconds.
		 */
		public function setTimeOut(timeOut : int, timeOutHandler : Function) : void {
			this.timeOutHandler = timeOutHandler;
			if (timeOut == 0 || timeOut > 250 ) {
				this.timeOut = timeOut;
			}
		}

		/**
		 * add handling methods for a method that is called on a service.
		 * A service/method combination is unique and this proxy can contain only one handling pair of functions.
		 * If you add multiple handlers for the same service/method combination, only the last added is used
		 * @param service String the service to be called (eg: "user" or "node")
		 * @param method String the method to be called on the service (eg: "get" or "save")
		 * @param resultHandler Function the function that handles the result data, wrapped in a DrupalData object that is the only argument of this function.
		 * @param statusHandler Function the function that handles the status/error data, wrapped in a DrupalData Object that is the only argument of this function.
		 */
		public function setHandler(service : String, method : String, resultHandler : Function, statusHandler : Function) : void {
			var name : String = serviceAndMethodFormat(service, method);
			callMapper.insert(name, new DrupalCallMapper(resultHandler, statusHandler));
		}

		/**
		 * a generic handler that will fire for every result or status/error from drupal when set.
		 * This can be used by classes in the same package to be notified of calls that were made 
		 * These generic handlers can be nulled.
		 * It is internal so we can safely use it for internal gephyr package Task purposes etc but without the risk of a client overwriting/abusing these handlers.
		 * @see DrupalInvokeTask
		 * 
		 */
		internal function setGenericHandler(genericResultHandler : Function = null, genericStatusHandler : Function = null, genericErrorHandler : Function = null, genericTimeOutHandler : Function = null) : void {
			this.genericTimeOutHandler = genericTimeOutHandler;
			this.genericErrorHandler = genericErrorHandler;
			this.genericStatusHandler = genericStatusHandler;
			this.genericResultHandler = genericResultHandler;
		}

		/**
		 * removes the result and status handlers for the service/method combination
		 */
		public function removeHandler(service : String, method : String) : void {
			var name : String = serviceAndMethodFormat(service, method);
			callMapper.remove(name);
		}

		/**
		 * Actually connects to the gateway specified in the constructor.
		 * @throws an error if connection fails.
		 */
		private function connect() : void {
			// Does not catch an error with a gateway that does not exist.
			try {
				netConnection.connect(gateway);
			} catch (error : Error) {
				callErrorHandler("DrupalProxy.connect(): " + error.message);
			}
		}

		private function addNetConnectionListeners() : void {
			netConnection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionNetStatus);
		}

		private function removeNetConnectionListeners() : void {
			netConnection.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			netConnection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetConnectionNetStatus);
		}

		private function onIOError(e : IOErrorEvent) : void {
			callErrorHandler(e.text);
		}

		private function onAsyncError(e : AsyncErrorEvent) : void {
			callErrorHandler(e.text);
		}

		private function onSecurityError(e : SecurityErrorEvent) : void {
			callErrorHandler(e.text);
		}

		/**
		 * Callback for the NetStatusEvent.NET_STATUS sent from the netConnection instance which calls invokeErrorHandlers or invokeConnectHandlers based on the info code from the event.
		 * @param e	The net status event object sent from the netConnection instance.
		 */
		private function onNetConnectionNetStatus(e : NetStatusEvent) : void {
			switch(e.info.code) {
				case "NetConnection.Connect.Closed":
					// The connection was closed successfully.
					break;
				case "NetConnection.Connect.Success":
					// The connection attempt succeeded.
					break;
				case "NetConnection.Call.BadVersion":
				// Packet encoded in an unidentified format.
				case "NetConnection.Call.Failed":
				// The NetConnection.call method was not able to invoke the server-side method or command.
				case "NetConnection.Call.Prohibited":
				// An Action Message Format (AMF) operation is prevented for security reasons. Either the AMF URL is not in the same domain as the SWF file, or the AMF server does not have a policy file that trusts the domain of the SWF file.
				default:
					// all possible other stuff that could happen, just low level connection stuff we handle in one error handler
					callErrorHandler(e.info.code);
					break;
			}
		}

		/**
		 * handles the low level errors generated by the system or by a subclass
		 */
		protected final function callErrorHandler(message : String) : void {
			var dd : DrupalData = new DrupalData(null, "this is a low level error, no remote call id can be associated", message);
			if (errorHandler != null) {
				errorHandler(dd);
			} else {
				trace("DrupalProxy: " + message);
			}

			if (genericErrorHandler != null) {
				genericErrorHandler(dd);
			}
		}

		/**
		 * which version for drupal?
		 */
		public function setVersion(version : uint = 7) : void {
			if (version != VERSION_6 && version != VERSION_7) {
				version = VERSION_7;
			}
			// TODO: consider moving it to a state pattern so we can get rid of switch statements elsewhere in the code.
			this.version = version;
		}

		/**
		 * internal function that creates the right format for the amfphp/drupal backend
		 */
		private function serviceAndMethodFormat(service : String, method : String) : String {
			return service + "." + method;
		}

		/**
		 * called by the responder object when a remote call timed out.
		 */
		private function onTimeOut(serviceAndMethodName : String, timeOut : int, remoteCallId : String) : void {
			var dd : DrupalData = new DrupalData(null, remoteCallId, "Timeout after " + timeOut + " ms occured when calling: " + serviceAndMethodName);
			if (timeOutHandler != null) {
				timeOutHandler(dd);
			} else {
				trace("DrupalProxy: Timeout occured when calling: " + serviceAndMethodName + "after " + timeOut + " ms");
			}
			if (genericTimeOutHandler != null) {
				genericTimeOutHandler(dd);
			}
		}

		/**
		 * used to cache data associated with the next method call
		 * the data will only be used for the first call made after this method is called and is invalidated directly after that call.
		 * The data will be associated with the specific call made and will be part of the DrupalData object that will come back to your result handler along with data from the drupal backend.
		 * This is particularly useful when doing a call on the views.get method since it does not return the name of the view called.
		 * when you first call setRemoteCallId("myviewname"); followed by proxy.invoke("views","get","myviewname");
		 * the handling function receiving the DrupalData object can use drupalData.getRemoteCallId() to get "myviewname" back.
		 * In this way, conditional action can be taken on the result of multiple calls to the same service method with differing input.
		 */
		public function setRemoteCallId(remoteCallId : String = "") : void {
			this.remoteCallId = remoteCallId;
		}

		/**
		 * cleans up the class.
		 * destroys all references, frees memory etc.
		 * after a call to destroy, the instance of DrupalProxy cannot be used anymore
		 */
		public function destroy() : void {
			removeNetConnectionListeners();
			netConnection.close();
			netConnection = null;
			user = null;
			security = null;
			callMapper.clear();
			callMapper = null;
			errorHandler = null;
			timeOutHandler = null;
		}

		/**
		 * sets data (a drupal user object) on the service as the currently logged in user.
		 * Normally you will get this user obect via a call to userLogin(), which will add the user object to the service automatically.
		 * In case you are logged in via the drupal site itself, you could pass a user Object to flash (for example via ExternalInterface).
		 * This might be useful because you don't want to log in via the drupal site itself AND via flash if you have a hybrid php/flash site.
		 * If you want to have only the functionality for when you are logged in via drupal, either pass in a valid sessionId via setSession() or make a call to userLogin()
		 * @param user a user object
		 * @see #userLogin
		 * @see #setSessionId
		 */
		public function setUser(user : Object) : void {
			this.user = user;
		}

		/**
		 * gets the sessionId from drupal.
		 * This is only available after a sucessful call to system.connect() or via user.login().
		 * Which method you need to call first to get a sessionId is also dependent on how the services module is configured.
		 * You can also set the sessionId via setSessionId().
		 */
		public function getSessionId() : String {
			return security.getSessionId();
		}

		/**
		 * sets the sessionId. 
		 * This might be useful if you would like to use multipe DrupalServices from within the same flash client and one of them gets the sessionId first. 
		 * The other can then use the same sessionId (which might be coupled to a logged in user for example).
		 * It can also be useful if you are logged in via a drupal frontend and want to pass in the sessionid to  a flash file, so you can immediately use the flash file as a logged in user.
		 * A way to pass in the sessionId could be via the FlashVarsRegistry, which uses flash variables.
		 * @see nl.dpdk.utils.FlashVarsRegistry
		 * @param sessionId the sessionId that will be passed to the drupal backend when a sessionId is required.
		 */
		public function setSessionId(sessionId : String) : void {
			security.setSessionId(sessionId);
		}

		/**
		 * gets the currently logged in user, or an empty object when no user is logged in.
		 */
		public function getUser() : Object {
			return user ? user : new Object();
		}

		/**
		 * gets the drupal security object configured for this service
		 */
		public function getSecurity() : DrupalSecurity {
			return security;
		}

		public function setSecurity(security : DrupalSecurity) : void {
			this.security = security;
		}

		public function getVersion() : uint {
			return version;
		}

		public function setSessionName(sessionName : String) : void {
			this.sessionName = sessionName;
		}
	}
}
