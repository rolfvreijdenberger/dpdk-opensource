/*
Copyright (c) 2009 De Pannekoek en De Kale B.V.,  www.dpdk.nl

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
package nl.dpdk.loader 
{

	/**
	 * Enumeration of all types of data that are supported.
	 * Meaning that these types of data have are detected automatically from the url extensions
	 * that are registered to these types.
	 * 
	 * If you want to add your own types you can, with registerExtensionType on LoaderManager.
	 * Make sure you assign your custom types to a uint other than 1 to 7.
	 * If you don't, the built-in task that corresponds to the built-in type will be registered
	 * to your custom type making your custom type useless.
	 * 
	 * If you want to use your own implementation of a specific LoadTask, use registerLoadTask
	 * on LoaderManager and register your custom LoadTask with one of the built-in types or with
	 * a custom type that you have registered to your own extensions.
	 * If you have assigned a custom type to an already registered built-in extension it will
	 * not be used, the built-in type will be used instead.
	 * So if you want to use your own implementation of say loading a jpg you have to assign 
	 * your own LoadTask subclass to the built-in BITMAP_TYPE via registerLoadTask on LoaderManager.
	 * 
	 * Adding custom types is therefor only necessary if you have a custom file extension,
	 * say .config that you want to load with your own custom LoadTask, say ConfigLoadTask.
	 * If that's the case, then you have to register the .config extension to a type higher than 7.
	 * LoaderManager.getInstance().registerExtensionType(".config", 8);
	 * Then register your custom LoadTask that will load the .config files with the type 8.
	 * LoaderManager.getInstance().registerLoadTask(ConfigLoadTask, 8);
	 * 
	 * Again, if you just want to load .config files with the built-in (say) XML_TYPE LoadTask
	 * LoaderManager.getInstance().registerExtensionType(".config", LoaderTypes.XML_TYPE);
	 * is all you need to do.
	 * 
	 * @see LoaderManager
	 * 
	 * @author Thomas Brekelmans
	 */
	public class DataTypes 
	{
		public static const BITMAP_TYPE:uint = 1;
        public static const MOVIE_CLIP_TYPE:uint = 2;
        public static const SOUND_TYPE:uint = 3;
		public static const TEXT_TYPE:uint = 4;
        public static const VIDEO_TYPE:uint = 5;
        public static const XML_TYPE:uint = 6;
        /**
         * Default type when no other built-in or custom registered type can be found.
         */
        public static const BINARY_TYPE:uint = 7;
	}
}
