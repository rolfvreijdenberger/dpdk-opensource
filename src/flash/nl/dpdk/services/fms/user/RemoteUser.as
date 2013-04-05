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
package nl.dpdk.services.fms.user 
{
	import nl.dpdk.services.fms.user.IRemoteUser;
	import nl.dpdk.user.User;		

	/**
	 * A remote user is an abstraction of a user who is available on another client in a different physical location.
	 * It will mostly be used in combination with a flash media server.
	 * 
	 * @see RemoteId
	 * @see RemoteIdEvent
	 * @see FMSService
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class RemoteUser extends User implements IRemoteUser {
		private var remoteId : RemoteId;

		public function RemoteUser() {
			super();
			//initialize, not remote by default
			remoteId = new RemoteId(RemoteId.NOT_REMOTE);
		}

		
		public function getRemoteId() : RemoteId {
			return remoteId;
		}

		
		public function setRemoteId(remoteId : RemoteId) : void {
			this.remoteId = remoteId;
		}

		
		public function isRemote() : Boolean {
			return remoteId.isRemote();
		}
		
		/**
		 * This method might be overriden.
		 * It's purpose is to explicitly state if this User is the local User, the logged in User, YOU!
		 * In contrast to any other user that is connected to the fms.
		 */
		public function isLocal() : Boolean {
			//normal behaviour is that we only have a databaseId when we are the logged in user (in multiuser systems) so use this information.
			//for specific behaviour, override
			return getId() != null;
		}

		
		override public function toString() : String {
			return "RemoteUser";
		}
	}
}
