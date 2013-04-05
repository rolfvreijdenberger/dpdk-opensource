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
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.sorting.Comparators;
	import nl.dpdk.collections.trees.BinarySearchTree;	

	/**
	 * Filter is a special type of collection which stores a list of words.
	 * A given text is filtered on this list of words. Whenever there's an 
	 * occurance of a word in the filter, each character of that word is 
	 * replaced by a given replace character. 
	 * 
	 * @author Rolf Vreijdenberger, Thomas Brekelmans 
	 */
	public class Filter implements ICollection 
	{
		private var badWords:BinarySearchTree;
		private var replaceCharacter:String = '*';
		private var comparator:Function;

		/**
		 * make sure the collection is in random order (not ordered by alphabet etc.) when adding to the filter.
		 */
		public function Filter(caseInSensitive:Boolean = true, collection:ICollection = null) 
		{
			comparator = caseInSensitive == true ? Comparators.compareStringCaseInsensitive : Comparators.compareString;
			badWords = new BinarySearchTree(comparator, collection);
		}

		/**
		 * adds a word to the filter.
		 * make sure they are randomly added.
		 * @param word a String to add
		 */
		public  function add( word:*):void 
		{
			if(word is String) 
			{
				badWords.add(word);
			}
		}

		/**
		 * clears the filter of all stored words
		 */
		public  function clear():void 
		{
			badWords.clear();
		}

		/**
		 * sets the character we want to take the place of all the letters in a bad word
		 */
		public  function setReplaceCharacter(character:String):void 
		{
			replaceCharacter = character;	
		}

		/**
		 * applies the filter to the text
		 */
		public function filter(text:String):String 
		{
			var punctuation:Array = new Array();
			//TODO, finetune regular expression, some stuff is not caught  (eg: an '@' as the final character in a word) and fucks up shit.
			var punctuationRegExp:RegExp = /[[:punct:]]/gi;
			var punctuationSearchResult:Object = punctuationRegExp.exec(text);
			while(punctuationSearchResult != null)
			{
				punctuation.push(punctuationSearchResult);
				
				punctuationSearchResult = punctuationRegExp.exec(text);
			}
			
			var pattern:RegExp = /\b\w+\b/gi;
			var wordsToFilter:Array = text.match(pattern);
			
			var filteredText:String;			var badWord:String;
			
			var i:String;
			for (i in wordsToFilter) 
			{
				//binary search tree search
				badWord = badWords.search(wordsToFilter[i]);
				if(badWord == null) 
				{ 
					continue;
				}
				wordsToFilter[i] = badWord.replace(/\w/gi, "*");
			}
			
			filteredText = wordsToFilter.join(" ");
			
			for (var j:int; j < punctuation.length; ++j)
			{
				filteredText = filteredText.substring(0, punctuation[j].index) + punctuation[j][0] + filteredText.substring(punctuation[j].index);
			}
			
			return filteredText;
		}

		public  function toString():String 
		{
			return 'Filter';
		}

		public function contains(word:*):Boolean 
		{
			if(word is String) 
			{
				return badWords.contains(word);
			}
			return false;
		}

		public function isEmpty():Boolean 
		{
			return badWords.isEmpty();
		}

		public function remove(word:*):Boolean 
		{
			if(word is String) 
			{
				return badWords.remove(word);
			}
			return false;
		}

		public function size():int 
		{
			return badWords.size();
		}

		public function toArray():Array 
		{
			return badWords.toArray();
		}

		public function iterator():IIterator 
		{
			return badWords.iterator();
		}
	}
}