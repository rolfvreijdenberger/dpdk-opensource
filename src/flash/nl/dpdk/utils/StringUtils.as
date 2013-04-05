/* 
 * The code in this file is incorporated in the dpdk package, but possibly not all the code in this file is originally by dpdk.
 * in case the code below has no licensing, the license following below is used and if not provided is the MIT license.
 * If there is a license, it follows below. In case the author is known, he is named below.
 */


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

	public class StringUtils {

		/**
		 * generates a random string from the characters fed to the method and with the specified length
		 * @param source the source string, can be any string, only the characters inside the source will be used.
		 * @param length the length of the random string to return
		 */
		public static function generateRandomString(source : String, length : int) : String {
			var l : int = source.length;
			var random : String = "";
			for(var i : int = 0;i < length;++i) {
				random += source.charAt(Math.floor(Math.random() * l));
			}
			return random;
		}
		
		/**
		 * checks whether the input might be viewed as a boolean value
		 */
		public static function toBoolean(data: *): Boolean {
			if(data == true || data == 1 || data == "1" || data == "true" || data =="yes" || data== "y"){
				return true;
			}
			return false;
		}

		/**
		 * prefixes an int with a zero when under ten (1-9) and returns a string.
		 * @param toPrefix an int that possibly needs prefixing
		 */		public static function prefixWithZeroWhenUnderTen(toPrefix : int) : String {
			var output : String;
			if(toPrefix >= 10 || toPrefix < 0) {
				return String(toPrefix);
			}
			output = '0' + String(toPrefix);
			return output;
		}

		
		/**
		 * prefixes a string with a zero when under ten (1-9) and returns a string.
		 * @param toPrefix a string that possibly needs prefixing
		 */		public static function prefixStringWithZeroWhenUnderTen(toPrefix : String) : String {
			return prefixWithZeroWhenUnderTen(parseInt(toPrefix));	
		}

		/**
		 * Returns everything after the first occurrence of the provided character in the string.
		 */
		public static function afterFirst(source : String, character : String) : String {
			if (source == null) { 
				return ''; 
			}
			var idx : int = source.indexOf(character);
			if (idx == -1) { 
				return ''; 
			}
			idx += character.length;
			return source.substr(idx);
		}

		/**
		 * Returns everything after the last occurence of the provided character in source.
		 */
		public static function afterLast(source : String, character : String) : String {
			if (source == null) { 
				return ''; 
			}
			var idx : int = source.lastIndexOf(character);
			if (idx == -1) { 
				return ''; 
			}
			idx += character.length;
			return source.substr(idx);
		}

		/**
		 * Determines whether the specified string begins with the specified begin.
		 */
		public static function beginsWith(source : String, begin : String) : Boolean {
			if (source == null) { 
				return false; 
			}
			return source.indexOf(begin) == 0;
		}

		/**
		 * Determines whether the specified string ends with the specified end.
		 */
		public static function endsWith(source : String, end : String) : Boolean {
			return source.indexOf(end) == source.length - end.length;
		}

		/**
		 * Returns everything before the first occurrence of the provided character in the string.
		 */
		public static function beforeFirst(source : String, character : String) : String {
			if (source == null) { 
				return ''; 
			}
			var characterIndex : int = source.indexOf(character);
			if (characterIndex == -1) { 
				return ''; 
			}
			return source.substr(0, characterIndex);
		}

		/**
		 * Returns everything before the last occurrence of the provided character in the string.
		 */
		public static function beforeLast(source : String, character : String) : String {
			if (source == null) { 
				return ''; 
			}
			var characterIndex : int = source.lastIndexOf(character);
			if (characterIndex == -1) { 
				return ''; 
			}
			return source.substr(0, characterIndex);
		}

		/**
		 * Returns everything after the first occurance of start and before the first occurrence of end in the given string.
		 */
		public static function between(source : String, start : String, end : String) : String {
			var str : String = '';
			if (source == null) { 
				return str; 
			}
			var startIdx : int = source.indexOf(start);
			if (startIdx != -1) {
				startIdx += start.length; 
				
				var endIdx : int = source.indexOf(end, startIdx);
				if (endIdx != -1) { 
					str = source.substr(startIdx, endIdx - startIdx); 
				}
			}
			return str;
		}

		/**
		 * Returns you the closest possible match to the given delimeter,
		 * while keeping the text length within the given length.
		 *	
		 * <p>If a match can't be found in your specified length an  '...' is added to that block,
		 * and the blocking continues untill all the text is broken apart.</p>
		 *
		 * @param source The string to break up.
		 * @param length Maximum length of each block of text.
		 * @param delimiter delimter to end text blocks on, default = '.'
		 */
		public static function block(source : String, length : uint, delimiter : String = ".") : Array {
			var arr : Array = new Array();
			if (source == null || !contains(source, delimiter)) { 
				return arr; 
			}
			var chrIndex : uint = 0;
			var strLen : uint = source.length;
			var replPatt : RegExp = new RegExp("[^" + escapePattern(delimiter) + "]+$", null);
			while (chrIndex < strLen) {
				var subString : String = source.substr(chrIndex, length);
				if (!contains(subString, delimiter)) {
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		 * Capitallizes the first word or all the words in the given string and returns it.
		 */
		public static function capitalize(source : String, capitalizeAll : Boolean) : String {
			var str : String = trimLeft(source);
			if (capitalizeAll == true) { 
				return str.replace(/^.|\b./g, _upperCase);
			} else { 
				return str.replace(/(^\w)/, _upperCase); 
			}
		}

		/**
		 * Determines whether the specified string contains any instances of character.
		 */
		public static function contains(source : String, character : String) : Boolean {
			if (source == null) { 
				return false; 
			}
			return source.indexOf(character) != -1;
		}

		/**
		 * Returns the number of times a character or sub-string appears within the string.
		 */
		public static function countOf(source : String, character : String, isCaseSensitive : Boolean = true) : uint {
			if (source == null) { 
				return 0; 
			}
			var char : String = escapePattern(character);
			var flags : String = (!isCaseSensitive) ? 'ig' : 'g';
			return source.match(new RegExp(char, flags)).length;
		}

		/**
		 * Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		 * The distance is the number of deletions, insertions, or substitutions required to transform the source into the target.
		 */
		public static function editDistance(source : String, target : String) : uint {
			var i : uint;

			if (source == null) { 
				source = ''; 
			}
			if (target == null) { 
				target = ''; 
			}

			if (source == target) { 
				return 0; 
			}

			var d : Array = new Array();
			var cost : uint;
			var n : uint = source.length;
			var m : uint = target.length;

			if (n == 0) { 
				return m; 
			}
			if (m == 0) { 
				return n; 
			}

			for (i = 0;i <= n; i++) { 
				d[i] = new Array(); 
			}
			for (i = 0;i <= n; i++) { 
				d[i][0] = i; 
			}
			for (var k : uint = 0;k <= m; k++) { 
				d[0][k] = k; 
			}

			for (i = 1;i <= n; i++) {

				var s_i : String = source.charAt(i - 1);
				for (var j : uint = 1;j <= m; j++) {

					var t_j : String = target.charAt(j - 1);

					if (s_i == t_j) { 
						cost = 0; 
					} else { 
						cost = 1; 
					}

					d[i][j] = _minimum(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost);
				}
			}
			return d[n][m];
		}

		/**
		 * Determines whether the specified string contains any text except spaces.
		 */
		public static function hasText(source : String) : Boolean {
			var str : String = removeExtraWhitespace(source);
			return !!str.length;
		}

		/**
		 * Determines whether the specified string contains any characters.
		 */
		public static function isEmpty(source : String) : Boolean {
			if (source == null) { 
				return true; 
			}
			return !source.length;
		}

		/**
		 * Determines whether the specified string is numeric (i.e. is formatted as a number).
		 */
		public static function isNumeric(source : String) : Boolean {
			if (source == null) { 
				return false; 
			}
			var regx : RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(source);
		}

		/**
		 * Pads source with specified character to a specified length from the left.
		 */
		public static function padLeft(source : String, characterToPad : String, length : uint) : String {
			var s : String = source;
			while (s.length < length) { 
				s = characterToPad + s; 
			}
			return s;
		}

		/**
		 * Pads source with specified character to a specified length from the right.
		 */
		public static function padRight(source : String, characterToPad : String, length : uint) : String {
			var s : String = source;
			while (s.length < length) { 
				s = s + characterToPad; 
			}
			return s;
		}

		/**
		 * Properly cases' the string in "sentence format".
		 * TODO, Discuss if this is the best name for this method
		 */
		public static function properCase(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			var str : String = source.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		 * Removes all occurances of the remove string in the given string.
		 */
		public static function remove(source : String, remove : String, isCaseSensitive : Boolean = true) : String {
			if (source == null) { 
				return ''; 
			}
			var rem : String = escapePattern(remove);
			var flags : String = (!isCaseSensitive) ? 'ig' : 'g';
			return source.replace(new RegExp(rem, flags), '');
		}

		/**
		 * Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the given string.
		 */
		public static function removeExtraWhitespace(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			var str : String = trim(source);
			return str.replace(/\s+/g, ' ');
		}

		/**
		 * Returns the given string in reverse character order.
		 */
		public static function reverse(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			return source.split('').reverse().join('');
		}

		/**
		 * Returns the given string in reverse word order.
		 */
		public static function reverseWords(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			return source.split(/\s+/).reverse().join('');
		}

		/**
		 *	Determines the percentage of similiarity between two given strings, based on editDistance.
		 *	@see #editDistance
		 */
		public static function similarity(source : String, target : String) : Number {
			var ed : uint = editDistance(source, target);
			var maxLen : uint = Math.max(source.length, target.length);
			if (maxLen == 0) { 
				return 100; 
			} else { 
				return (1 - ed / maxLen) * 100; 
			}
		}

		/**
		 *	Remove's all < and > based tags from the given string.
		 */
		public static function stripTags(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			return source.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		 *	Swaps the casing of a string.
		 */
		public static function swapCase(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			return source.replace(/(\w)/, _swapCase);
		}

		/**
		 *	Removes whitespace from the front and the end of the specified string.
		 */
		public static function trim(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			return source.replace(/^\s+|\s+$/g, '');
		}

		/**
		 *	Removes whitespace from the front (left-side) of the specified string.
		 */
		public static function trimLeft(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			return source.replace(/^\s+/, '');
		}

		/**
		 *	Removes whitespace from the end (right-side) of the specified string.
		 */
		public static function trimRight(source : String) : String {
			if (source == null) { 
				return ''; 
			}
			return source.replace(/\s+$/, '');
		}

		/**
		 *	Determins the number of words in a string.
		 */
		public static function wordCount(source : String) : uint {
			if (source == null) { 
				return 0; 
			}
			return source.match(/\b\w+\b/g).length;
		}

		/**
		 *	Returns a string truncated to a specified length with optional suffix.
		 */
		public static function truncate(source : String, length : uint, suffix : String = "...") : String {
			if (source == null) { 
				return ''; 
			}
			if (length <= 0) { 
				length = source.length; 
			}
			length -= suffix.length;
			var trunc : String = source;
			if (trunc.length > length) {
				trunc = trunc.substr(0, length);
				if (/[^\s]/.test(source.charAt(length))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += suffix;
			}

			return trunc;
		}

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern : String) : String {
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		private static function _minimum(a : uint, b : uint, c : uint) : uint {
			return Math.min(a, Math.min(b, Math.min(c, a)));
		}

		private static function _upperCase(character : String, ...args) : String {
			return character.toUpperCase();
		}

		private static function _swapCase(character : String, ...args) : String {
			var lowChar : String = character.toLowerCase();
			var upChar : String = character.toUpperCase();
			switch (character) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return character;
			}
		}
	}
}
