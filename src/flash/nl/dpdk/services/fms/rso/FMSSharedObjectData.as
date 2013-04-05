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
package nl.dpdk.services.fms.rso {

	/**
	 * this is a wrapper class for the data in a RemoteSharedObject (RSO)
	 * The id is the value of the RSO property, for userlists, this will be a remoteId in most cases.
	 * The data is the object we are interested in.
	 * The data object is of type Object, as this is the way RSO's work.
	 * The id object is of type int, since we only use id's for RSO properties, this is a convention used by dpdk.
	 * The data should be handled by the client (preferrably by a Factory that creates a domain object) so it can then be used throughout the application.
	 * Changes on the data (which we can see by the type of FMSSharedObjectEvent) can be tracked by comparing the domain objects against each other (for example: by their id, which should probably happen in an ISpecification).
	 * 
	 * An instance of this class is set on an FMSSharedObjectEvent's data property
	 * An FMSSharedObject dispatches this event with a certain type, so we can see what has been changed/added/deleted
	 * 
	 * 
	 * @see FMSSharedObjectEvent
	 * @see FMSSharedObject
	 * @see FMSService
	 * @see RemoteId
	 * @see RemoteUser
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class FMSSharedObjectData {
		/**
		 * the id of the shared object data, the name of the list property.
		 * In most cases this will be the id (int) of a remoteId 
		 * we especially need this in case of a deleted property on a RSO (in which case the data is nonexistent).
		 */
		private var id: *;
		/**
		 * the data of the shared object list value.
		 */
		private var data: *;

		public function FMSSharedObjectData(id:*, data: *) {
			
			this.data = data;
			this.id = id;
		}
		
		/**
		 * get the name/id of the property of the shared object.
		 */
		public function getId() : * {
			return id;
		}
		
		
		/**
		 * get the data of the shared object property (that is defined by it's name/id).
		 * @return Object, the object in the list, specified by the id,  on the remote shared object.
		 */
		public function getData():* {
			return data;
		}
		
		
		public function toString() : String {
			return "FMSSharedObjectData[" + getId() + "]";
		}
	}
}
