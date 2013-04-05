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
package nl.dpdk.user 
{
	import flash.events.EventDispatcher;	

	/**
	 * User represents a typical user in a system.
	 * It might be 'the' user of a system (the logged in user) or a representation of other users (friends, users in a userlist etc).
	 * User can be subclassed for specific implementations that need extra functionality or properties.
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class User extends EventDispatcher 
	{
		//usually  a database id or a hashed id.
		private var id:String;
		//registration data
		private var identificationDate:Date;
		//the firstname
		private var firstName:String;
		//the surname
		private var surname:String;
		//the nickname of the user
		private var nickname:String;
		//passowrd
		private var password:String;
		//the gender, see Gender
		private var gender:int;
		//the email address
		private var email:String;
		//the user's birthday
		private var birthday:Date;
		//the user's adress, see Address
		private var address:Address;
		//the phone
		private var phone:String;
		//the mobile
		private var mobilePhone:String;

		/**
		 * constructor
		 * not parametized as a user may be initially identified by different properties (nickname, email, id etc..)
		 */
		public function User() 
		{
			//to avoid runtime errors when we are getting these values from the user instance, we initialize them.
			address = new Address();
			identificationDate = new Date();
			birthday = new Date();
		}
		
		/**
		 * the database id / systemId if any
		 */
		public function getId():String
		{
			return id;
		}
		
		public function setId(id:String):void
		{
			this.id = id;
		}
		
		public function getIdentificationDate():Date
		{
			return identificationDate;
		}
		
		public function setIdentificationDate(identificationDate:Date):void
		{
			this.identificationDate = identificationDate;
		}
		
		public function getFirstName():String
		{
			return firstName;
		}
		
		public function setFirstName(firstName:String):void
		{
			this.firstName = firstName;
		}
		
		public function getSurname():String
		{
			return surname;
		}
		
		public function setSurname(surname:String):void
		{
			this.surname = surname;
		}
		
		public function getNickname():String
		{
			return nickname;
		}
		
		public function setNickname(nickname:String):void
		{
			this.nickname = nickname;
		}
		
		public function getPassword():String
		{
			return password;
		}
		
		public function setPassword(password:String):void
		{
			this.password = password;
		}
		
		public function getGender():int
		{
			return gender;
		}
		
		public function setGender(gender:int):void
		{
			this.gender = gender;
		}
		
		public function getEmail():String
		{
			return email;
		}
		
		public function setEmail(email:String):void
		{
			this.email = email;
		}
		
		public function getBirthday():Date
		{
			return birthday;
		}
		
		public function setBirthday(birthday:Date):void
		{
			this.birthday = birthday;
		}
		
		public function getAddress():Address
		{
			return address;
		}
		
		public function setAddress(address:Address):void
		{
			this.address = address;
		}
		
		
		
		public function getPhone() : String {
			return phone;
		}
		
		
		public function setPhone(phone : String) : void {
			this.phone = phone;
		}
		
		
		public function getMobilePhone() : String {
			return mobilePhone;
		}
		
		
		public function setMobilePhone(mobilePhone : String) : void {
			this.mobilePhone = mobilePhone;
		}

		
		override public function toString() : String {
			return "User[" + getId() + "]";
		}
	}
}
