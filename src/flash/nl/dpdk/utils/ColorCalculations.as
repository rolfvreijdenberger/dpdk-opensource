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
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	/**
	 * Library class to convert color values and make calculations on colorparts
	 * @author Rolf Vreijdenberger
	 */
	public class ColorCalculations 
	{
		/**
		 * get the red part of a color
		 */
		public static function getRed(color : uint) : uint
		{
			return color >> 16 & 0xFF;
		}

		
		/**
		 * get the green part of a color
		 */
		public static function getGreen(color : uint) : uint
		{
			return color >> 8 & 0xFF;
		}

		
		/**
		 * get the blue part of a color
		 */
		public static function getBlue(color : uint) : uint
		{
			return color & 0xFF;
		}

		
		/**
		 * hex store is a string containing all valid hexadecimal entities in string form at the correct string position
		 */
		private static function getHexStore() : String 
		{
			return "0123456789abcdef";	
		}

		
		/**
		 * when this method is fed a string with an html color it returns the correct decimal counterpart
		 * @param color a string of the form "FF9900" or "F90" optionally prefixed with "0x" or "#". 
		 */
		public static function getColorFromHtmlColor(color : String) : uint 
		{
			var r : String, g : String, b : String;

			//parse out the #
			if(color.substr(0, 1) == "#" )
			{
				color = color.slice(1, color.length);
			}
			
			//parse out the 0x
			if(color.substr(0, 2) == "0x")
			{
				color = color.slice(2, color.length);
			}	
		
			
			//short code like fff
			if(color.length == 3)
			{
				r = color.substr(0, 1);
				g = color.substr(1, 2);
				b = color.substr(2, 3);
				color = r + r + g + g + b + b;
			}
			
			if(color.length != 6){
				throw new Error('not a valid html color format');	
			}
			
			return fromHexStringToNumber(color);
		}

		
		/**
		 * helper method that converts a hexadecimal string to a number
		 */
		public static function fromHexStringToNumber(hexadecimal : String) : uint
		{
			hexadecimal = hexadecimal.toLowerCase();
			var output : uint = 0;
			var value : uint;
			var exponent : Number = 0;
			var store: String = getHexStore();

			//for all parts in the hexadecimal string, loop, get the corresponding number for a hex number and apply standard hex to number conversion (value * 16 ^ weight
			for (var i : int = hexadecimal.length - 1 ;i >= 0; --i, ++exponent)
			{
				value = store.indexOf(hexadecimal.charAt(i));
				output += value * Math.pow(16, exponent);
			}
			return output;
		}

		
		/**
		 * helper method to convert a color number to the hex representation as a string
		 */
		public static function getHexValue(color : uint) : String
		{
			return toHex(getRed(color)) + toHex(getGreen(color)) + toHex(getBlue(color));
		}

		
		/**
		 * helper method gets the hex value as a string from a number between 0 and 255
		 * @param color	this color should be a maximum of 255 and a minimum of 0
		 */
		public static function toHex(value : Number) : String 
		{
			//not recursive, cause we want to use this method to create parts of an rgb value
			//if we implemented this recursively we would not be able to always generate a six char rgb hex value
			if (value == 0 ) return "00";
			value = checkValidRangeForColorPart(value);
			return getHexStore().charAt((value - value % 16) / 16) + getHexStore().charAt(value % 16);
		}

		
		/**
		 * given a color number, this method returns a valid html color with a "#" prefixed
		 */
		public static function getHtmlColorFrom(color : uint, prefix: String = "#") : String
		{
			//convert to hex string
			var output : String;
			output = prefix;
			output += getHexValue(color);
			return output;
		}

		
		/**
		 * sanitize the input
		 */
		private static function checkValidRangeForColorPart(part : Number) : uint
		{
			return Math.round(Math.max(0, Math.min(part, 255)));
		}

		
		/**
		 * method that creates a valid color number from it's red, green and blue values
		 */
		public static function createColorFrom(red : uint, green : uint, blue : uint) : uint
		{
			red = checkValidRangeForColorPart(red);
			green = checkValidRangeForColorPart(green);
			blue = checkValidRangeForColorPart(blue);
			return red << 16 | green << 8 | blue;
		}

		
		/**
		 * sets a color an a displayobject
		 */
		public static function setColor(color : uint, d : DisplayObject) : void
		{

			var red : uint = getRed(color);
			var blue : uint = getBlue(color);
			var green : uint = getGreen(color);
			d.transform.colorTransform = new ColorTransform(0, 0, 0, 1, red, green, blue);
		}

		
		public static function toString() : String
		{
			return "ColorCalculations";	
		}
	}
}
