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
package nl.dpdk.services.fms.user {

	/**
	 * A RemoteId is an abstraction to be able to identify a user as being a remote entity.
	 * In practice, this class is used in combination with flash media server (fms) related programs.
	 * An id is created on the fms server and stored on the client.
	 * A client's id is used to identify it to other remote users or to be able to identify remote users we want to interact with.
	 * Also, the remoteId is ideal to be used on remote shared objects such as userlists, or roomlists with users. just use the remoteId as the identifier on the data item of the RSO.
	 * Internally a type of int is used for the id, as this is the preferred way of doing business with fms.
	 * 
	 * @see nl.dpdk.services.fms.FMSService
	 * @see nl.dpdk.user.IRemoteUser
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class RemoteId {
		private var id: int = NOT_REMOTE;
		public static const NOT_REMOTE: int = -1;
		
		public function RemoteId(id:int) {
			setId(id);
		}
		
		public function getId() : int {
			return id;
		}
		
		private function setId(id : int) : void {
			this.id = id;
		}
		
		
		/**
		 * check whether we really are a remote id, or just a placeholder at the moment. (for instance, when we are not yet connected to the flash media server)
		 */
		public function isRemote():Boolean{
			return getId() != NOT_REMOTE;
		}	
	}
}
