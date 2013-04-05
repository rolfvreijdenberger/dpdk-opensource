package nl.dpdk.utils {

	/**
	 * http://en.wikipedia.org/wiki/Soundex
	 * Soundex is a phonetic algorithm for indexing names by sound, as pronounced in English. 
	 * The goal is for homophones to be encoded to the same representation so that they can be matched despite minor differences in spelling.
	 * The algorithm mainly encodes consonants; a vowel will not be encoded unless it is the first letter. 
	 * Soundex is the most widely known of all phonetic algorithms
	 * @author rolf
	 */
	public class Soundex {

		/**
		 * create a soundex string from the input
		 */
		public static function create(homophone : String) : String {
			//trace("Soundex.create() " + homophone);
			//sanity checks
			if(homophone.length < 1) { 
				return homophone;
			}
			//convert to uppercase
			homophone = homophone.toUpperCase();
			//replace non characters with space
			homophone.replace(new RegExp("[^A-Z]", "gi"), " ");
			//remove the leading spaces
			homophone.replace(new RegExp("^\s*", "g"), "");
			//remove trailing spaces
			homophone.replace(new RegExp("\s*$", "g"), "");
			
			//get the first letter
			var firstLetter : String = homophone.substr(0, 1);
			//trace("firstletter: '" + firstLetter +"'");
			
			
			//replace characters (special case for characters that convert to 0)
			homophone = homophone.replace(new RegExp("[AEIOUYHW]", "g"), 0);
			homophone = homophone.replace(new RegExp("[BPFV]", "g"), 1);
			homophone = homophone.replace(new RegExp("[CSGJKQXZ]", "g"), 2);
			homophone = homophone.replace(new RegExp("[DT]", "g"), 3);
			homophone = homophone.replace(new RegExp("[L]", "g"), 4);
			homophone = homophone.replace(new RegExp("[MN]", "g"), 5);
			homophone = homophone.replace(new RegExp("[R]", "g"), 6);
			
			//adjacent digits handling
			var l : int = homophone.length;
			var last : String = "";
			var current : String;
			var tmp : String = "";
			for(var i : int = 0;i < l;++i) {
				current = homophone.charAt(i);
				if(current == last) {
					tmp += "";
				} else {
					tmp += current;
					last = current;
				}
			}
			homophone = tmp;
			
			//get rid of the first letter (converted to code)
			//trace('with firstletter : ' + homophone);
			homophone = homophone.substr(1);
			//trace('firstletter removed: ' + homophone);
			//remove spaces
			homophone = homophone.replace(/\s/gi, "");
			//trace('space replaced: ' + homophone);
			//remove zeroes
			homophone = homophone.replace(new RegExp("0", "g"), "");
			//trace('0 replaced: ' + homophone);
			//add original firstletter
			homophone = firstLetter + homophone;
			//trace('real firstletter attached: ' + homophone);
			//pad with zeroes if output is less than 4 characters
			homophone = StringUtils.padRight(homophone, "0", 4);
			//get the 4 character substring
			homophone = homophone.substr(0, 4);
			
			
			//trace('output: ' + homophone);
			return homophone;
		}
	}
}
