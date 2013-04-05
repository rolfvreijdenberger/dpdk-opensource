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
	import nl.dpdk.loader.tasks.BitmapLoadBytesTask;

	import flash.utils.ByteArray;

	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.lists.PriorityQueue;
	import nl.dpdk.collections.lists.PriorityQueueNode;
	import nl.dpdk.loader.specifications.ExtensionToDataTypeByExtensionSpecification;
	import nl.dpdk.loader.specifications.ExtensionToDataTypeExistsSpecification;
	import nl.dpdk.loader.tasks.BinaryLoadTask;
	import nl.dpdk.loader.tasks.BitmapLoadTask;
	import nl.dpdk.loader.tasks.LoadTask;
	import nl.dpdk.loader.tasks.MovieClipLoadTask;
	import nl.dpdk.loader.tasks.SoundLoadTask;
	import nl.dpdk.loader.tasks.TextLoadTask;
	import nl.dpdk.loader.tasks.VideoLoadTask;
	import nl.dpdk.loader.tasks.XMLLoadTask;
	import nl.dpdk.utils.StringUtils;
	import nl.dpdk.utils.URLUtils;

	import flash.utils.Dictionary;
	/**
	 * LoaderManager is responsible for determining which Loader is up next to load something.
	 * It registeres all DataTypes and LoadTasks and provides methods to do this
	 * externally as well.
	 * LoaderManager is mostly used internally between Loaders and shouldn't be instantiated.
	 * 
	 * @see #registerTaskDefinitionToDataType()
	 * @see #registerExtensionToDataType()
	 * @see DataTypes 
	 * 
	 * @author Thomas Brekelmans
	 */
	final public class LoaderManager 
	{
		private static var instance:LoaderManager;
		private var queue:PriorityQueue;
		private var filesLoading:int = 0;
		private var maxConcurrentRequests:int = 2;
		private var current:Loader;
		private var extensionToDataTypeMap:List;
		private var taskDefinitionToDataTypeMap:Dictionary;

		public function LoaderManager() 
		{
			initialize();
		}

		public static function getInstance():LoaderManager
		{
			if (LoaderManager.instance == null)
			{
				LoaderManager.instance = new LoaderManager();
			}
			return LoaderManager.instance;
		}

		private function initialize():void
		{
			resetLoading();
		    
			initializeQueue();
			initializeMaps();
		    
			registerBuiltInTaskDefinitionsToDataTypes();
			registerBuiltInExtensionsToDataTypes();
		}

		private function resetLoading():void
		{
			filesLoading = 0;
			current = null;
		}

		private function initializeQueue():void
		{
			queue = new PriorityQueue();
		}

		private function initializeMaps():void
		{
			extensionToDataTypeMap = new ArrayList();
			taskDefinitionToDataTypeMap = new Dictionary();
		}

		private function registerBuiltInTaskDefinitionsToDataTypes():void
		{
			registerTaskDefinitionToDataType(BitmapLoadTask, DataTypes.BITMAP_TYPE);
			registerTaskDefinitionToDataType(VideoLoadTask, DataTypes.VIDEO_TYPE);
			registerTaskDefinitionToDataType(MovieClipLoadTask, DataTypes.MOVIE_CLIP_TYPE);
			registerTaskDefinitionToDataType(XMLLoadTask, DataTypes.XML_TYPE);
			registerTaskDefinitionToDataType(SoundLoadTask, DataTypes.SOUND_TYPE);
			registerTaskDefinitionToDataType(TextLoadTask, DataTypes.TEXT_TYPE);
		}

		private function registerBuiltInExtensionsToDataTypes():void
		{
			registerExtensionToDataType("jpg", DataTypes.BITMAP_TYPE);
			registerExtensionToDataType("jpeg", DataTypes.BITMAP_TYPE);
			registerExtensionToDataType("png", DataTypes.BITMAP_TYPE);
			registerExtensionToDataType("gif", DataTypes.BITMAP_TYPE);
		    
			registerExtensionToDataType("flv", DataTypes.VIDEO_TYPE);
			registerExtensionToDataType("f4v", DataTypes.VIDEO_TYPE);
			registerExtensionToDataType("f4p", DataTypes.VIDEO_TYPE);
		    
			registerExtensionToDataType("swf", DataTypes.MOVIE_CLIP_TYPE);
		 
			registerExtensionToDataType("xml", DataTypes.XML_TYPE);
		    
			registerExtensionToDataType("mp3", DataTypes.SOUND_TYPE);
			registerExtensionToDataType("f4a", DataTypes.SOUND_TYPE);
			registerExtensionToDataType("f4b", DataTypes.SOUND_TYPE);
		   
			registerExtensionToDataType("txt", DataTypes.TEXT_TYPE);
			registerExtensionToDataType("js", DataTypes.TEXT_TYPE);
			registerExtensionToDataType("php", DataTypes.TEXT_TYPE);
			registerExtensionToDataType("asp", DataTypes.TEXT_TYPE);
			registerExtensionToDataType("py", DataTypes.TEXT_TYPE);
		}

		/**
		 * Registers the given ExtensionToDataType to all loaders.
		 * Meaning that whenever a URL is loaded with the given extension,
		 * the task registered to the given type is executed.
		 * 
		 * If you try to register an already registered extension to a different 
		 * type it will override the old type.
		 * 
		 * Note: powerusers only, all common extensions are already registered to a type.
		 * Be careful with overriding registered extensions, it might break something 
		 * else in your application.
		 * 
		 * @param extension The extension of the file without the dot (.).
		 * 
		 * @see #registerTaskDefinitionToDataType
		 * @see DataTypes
		 */
		public function registerExtensionToDataType(extension:String, dataType:uint):void
		{
			// quick sanitize since it's hard to remember not to include the dot
			extension = StringUtils.remove(extension, ".");
			
			var extensionToDataType:ExtensionToDataType = new ExtensionToDataType(extension, dataType);
			if (containsDuplicateExtensionToDataTypes(extensionToDataType) == false)
			{
				removeRegisteredExtensionDataTypes(extensionToDataType.extension);
				
				extensionToDataTypeMap.add(extensionToDataType);
			}
		}

		/**
		 * set the maximum number of files to be loaded at once.
		 * this number is limited by the number of simultaneous http request a browser can make
		 * default is set to 2, as this is supported by every browser and recommended by w3c
		 * 
		 * see http://www.w3.org/Protocols/rfc2616/rfc2616-sec8.html
		 * 
		 * Maximum connections by browser:
		 * IE 6/7, Firefox 2: 2
		 * IE 8, Chrome: 6
		 * Firefox 3: 15
		 * 
		 * @param to maximum of files to be loaded at once
		 */
		public function setMaximumConcurrentRequests(to:int):void
		{
			maxConcurrentRequests = to; 
		}

		private function containsDuplicateExtensionToDataTypes(extensionToDataType:ExtensionToDataType):Boolean 
		{
			// can't do this with a simple contains because there might be two different ExtensionToDataType objects 
			// while both have the same extension and dataType combination and thus shouldn't be added twice
			var duplicateExtensionToDataTypes:List = extensionToDataTypeMap.selectBy(new ExtensionToDataTypeExistsSpecification(extensionToDataType));
			return duplicateExtensionToDataTypes.isEmpty() == false;
		}

		private function removeRegisteredExtensionDataTypes(extension:String):void 
		{
			var existingDataTypesForExtension:List = extensionToDataTypeMap.selectBy(new ExtensionToDataTypeByExtensionSpecification(extension));
				
			var iterator:IIterator = existingDataTypesForExtension.iterator();
			while (iterator.hasNext())
			{
				extensionToDataTypeMap.remove(iterator.next());
			}
		}

		/**
		 * Registers the given loader (task) type to the given LoadTask subclass definition.
		 * Meaning that whenever a loader tries to load something of the given type, the given LoadTask subclass is use to do the loading.
		 */
		public function registerTaskDefinitionToDataType(loadTaskDefinition:Class, dataType:uint):void
		{
			taskDefinitionToDataTypeMap[dataType] = loadTaskDefinition;
		}

		internal function registerLoader(loader:Loader):void
		{
			if (queue.contains(loader) == false)
			{
				queue.add(new PriorityQueueNode(loader.getPriority(), loader));
			}
			
			tryLoadingNextTask();
		}

		internal function createLoadTask(url:String, data:*, dataType:uint):LoadTask
		{
			if (dataType == 0)
			{
				var resolvedDataType:ExtensionToDataType = extensionToDataTypeMap.selectBy(new ExtensionToDataTypeByExtensionSpecification(URLUtils.getFileExtension(url))).getFirst();
				dataType = (resolvedDataType == null) ? DataTypes.BINARY_TYPE : resolvedDataType.dataType;
			}
			
			var taskDefinition:Class = getTaskDefinition(dataType);
			return new taskDefinition(url, data);
		}

		private function getTaskDefinition(dataType:uint):Class
		{
			var taskDefinition:Class = taskDefinitionToDataTypeMap[dataType];
			return (taskDefinition == null) ? BinaryLoadTask : taskDefinition;
		}

		internal function createBitmapLoadBytesTask(bytes:ByteArray, data:*):LoadTask
		{
			return new BitmapLoadBytesTask(bytes, data);
		}

		private function tryLoadingNextTask():void
		{
			if (loadingIsAllowed())
			{
				loadNextTask();
			}
		}

		private function loadingIsAllowed():Boolean
		{
			return (filesLoading < maxConcurrentRequests) && queue.isEmpty() == false;
		}

		internal function rePrioritize(loader:Loader):void
		{
			assignPriorityToPriorityQueueNode(loader);
			
			queue.heapify();
		}

		private function assignPriorityToPriorityQueueNode(loader:Loader):void
		{
			var priorityQueueNode:PriorityQueueNode;
			var iterator:IIterator = queue.iterator();
			while (iterator.hasNext())
			{
				priorityQueueNode = iterator.next();
				if (priorityQueueNode.getData() == loader)
				{
					priorityQueueNode.setPriority(loader.getPriority());
					break;
				}
			}
		}

		internal function notifyIsActive():void
		{
			queue.heapify();
			
			tryLoadingNextTask();
		}

		internal function notifyIsInActive():void
		{
			queue.heapify();
		}

		private function loadNextTask():void
		{
			// Works because of custom comparator: @see LoaderComparator
			current = queue.getMaximum().getData();
			// extra check to make sure the loader is active because it is possible that 
			// all loaders are inactive in the queue
			if (current.getIsActive() == true)
			{
				current.loadNextTask();
				
				filesLoading += 1;
				tryLoadingNextTask();
			}
			else
			{
				resetLoading();
			}
		}

		/**
		 * Callback method called from Loader.
		 */
		internal function notifyTaskDone(loader:Loader):void
		{
			//because the destroy method on loader calls this method, this 0 check is needed 	
			(filesLoading == 1) ? filesLoading -= 1 : filesLoading = 0;
			
			// rather than listening to the LOADER_DONE event from currentLoader
			// we manually decide when to check for an empty loader (namely here)
			// since the timing is crucial:
			// we want to be sure the empty (finished) loader is removed from
			// the priority queue to ensure it's not included in the loop in
			// the loadNextTask method
			if (loader.size() == 0)
			{
				queue.remove(loader);
			}
			
			tryLoadingNextTask();
		}

		public function toString():String
		{
			return "LoaderManager";
		}
	}
}