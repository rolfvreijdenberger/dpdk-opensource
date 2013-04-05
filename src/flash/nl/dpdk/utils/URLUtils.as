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
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	

	/**
	 * URL related stuff goes here.
	 * @author Rolf Vreijdenberger
	 */
	public class URLUtils {

		/**
		 * Returns the extension (without the dot) of the file referenced in the given URL.
		 */
		public static function getFileExtension(url:String):String
		{
			var fileExtension:String = StringUtils.afterLast(url, ".");
        	if (fileExtension.indexOf("?") > -1)
        	{
        	   fileExtension = StringUtils.beforeFirst(fileExtension, "?");	
            }
            return fileExtension.toLowerCase();
		}
		
		/**
		 * adds a parameter to the query string of the url.
		 * If the parameter name already exists, it is not added or overwritten.
		 * @param url the url to modify
		 * @param name the name of the name/value pair to add to the url.
		 * @param value the value of the name/value pair to add to the url.
		 * @return the formatted url.
		 */
		public static function addParameter(url : String, name : String, value : String) : String {
			if(url.indexOf(name + "=") != -1) {
				return url;	
			}
			if(url.indexOf("?") == -1) {
				url = url + "?";	
			}else {
				url = url + "&";	
			}
			
			url = url + name + "=" + value;
			
			return url;
		}		

		
		/**
		 * creates an anticache parameter on the url that is different each time this method is called.
		 * @param url the url to modify
		 * @param antiCacheName The name of the query parameter for the anticache functionality.
		 * @return the modified url
		 */
		public static function addAntiCache(url : String, antiCacheName : String = "anticache") : String {
			return addParameter(url, antiCacheName, "" + Math.random());	
		}

		
		/**
		 * shortcut to mimick old scool getURL method.
		 * For doing javascript stuff, use flash.external.ExternalInterface, do not use this method.
		 * @param url The url to navigate to.
		 * @param target The target to navigate to (eg: "_blank", "_parent", "_self") in the html container. Defaults to "_blank".
		 */
		public static function getURL(url : String, target : String = "_blank") : void {
			try {
				navigateToURL(new URLRequest(url), target);
			}catch(e : Error) {
				//fail silently
			}
		}
	}
}
