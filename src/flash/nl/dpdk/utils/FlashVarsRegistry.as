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
 package nl.dpdk.utils {

	/**
	 * Class that explicitely collects flashvars coming into the flashmovie.
	 * this is a simple wrapper that gives us a means to explicitely have a storage class for the flashvars, with some convenient methods on it.
	 * the flashvars must be fed to this class by a visible member of the displaylist, preferrably the document class (root.loaderInfo.parameters).
	 * this is a premisse for using the flashvars (displaylist/visible).
	 * It is a dynamic Registry (variation of a Singleton).
	 * @author Rolf Vreijdenberger
	 */
	public class FlashVarsRegistry  
	{
		private static var instance : FlashVarsRegistry;
		private static var store : Array;

		
		/**
		 * mimic a singleton by making sure there can be no instantiated class
		 * @param	noInstantiation
		 */
		function FlashVarsRegistry(noInstantiation : SingletonEnforcer)
		{
			//remove, no need of it anyway, and eclipse gives a warning that it is not used ;)
			noInstantiation = null;
			store = new Array();
		}

		
		/**
		 * sets the flash vars in this class, by being given an object that contains the flashvars.
		 * Explicitely call this method from the document class or any other <strong>visible displayItem</strong>.
		 * The flashvars are normally collected from 'root.loaderInfo.parameters'.
		 * @param objectContainingFlashVars Object	an object, preferrably 'root.loaderInfo.parameters' coming in from the document class of the flash movie.
		 */
		public function setFlashVars(objectContainingFlashVars : Object) : void
		{
			if(objectContainingFlashVars == null) return;
			for(var i:String in objectContainingFlashVars)
			{
				set(i, objectContainingFlashVars[i]);
			}
		}

		
		/**
		 * the singleton getter
		 * @return FlashVarsRegistry
		 */
		public static function getInstance() : FlashVarsRegistry
		{
			if(instance == null)
			{
				instance = new FlashVarsRegistry(new SingletonEnforcer());
			}
			return instance;
		}

		
		/**
		 * tries to get a value belonging to a certain key (variable name).
		 * @param key String	the key/identifier (variable name) of the flashvar we want.
		 * @return	String	the value belonging to the key, null if it does not exist.
		 * @see isValid
		 */
		public function get(key : String) : String
		{
			return store[key];
		}

		
		public function set(key : String, value : String) : void
		{
			store[key] = value;
		}

		
		/**
		 * checks if a certain key exists or not, use this to make sure we will be getting a valid result from the @see get method
		 * @param key String	the key to search for
		 * @return Boolean	indicating if the key actually exists or not
		 */
		public function isValid(key : String) : Boolean
		{
			if(store[key] != null){
				return true;
			}
			return false;
		}

		
		public function toString() : String
		{
			return 'FlashVarsRegistry';
		}
	}
}


/**
 * class that can only be used from inside the package, to enforce a Singleton pattern
 */
class SingletonEnforcer
{
}
