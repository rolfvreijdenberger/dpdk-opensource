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

	/**
	 * @author Rolf Vreijdenberger
	 * Address is a data holder for Address data that might be on a user object
	 */
	public class Address 
	{
		private var country:String;
		private var street:String;
		private var houseNumber:String;
		private var zipCode:String;
		private var city:String;

		
		public function Address() 
		{
		}

		public function getCity():String 
		{
			return city;
		}

		public function setCity(city:String):void 
		{
			this.city = city;
		}

		public function getZipCode():String 
		{
			return zipCode;
		}

		public function setZipCode(zipCode:String):void 
		{
			this.zipCode = zipCode;
		}

		public function getStreet():String 
		{
			return street;
		}

		public function setStreet(street:String):void 
		{
			this.street = street;
		}

		public function getHouseNumber():String 
		{
			return houseNumber;
		}

		public function setHouseNumber(houseNumber:String):void 
		{
			this.houseNumber = houseNumber;
		}

		public function getCountry():String 
		{
			return country;
		}

		public function setCountry(country:String):void 
		{
			this.country = country;
		}

		public function toString():String 
		{
			return "Address";
		}
	}
}
