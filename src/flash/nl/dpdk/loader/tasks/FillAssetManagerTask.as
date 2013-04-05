package nl.dpdk.loader.tasks {
	import nl.dpdk.assets.Asset;
	import nl.dpdk.assets.AssetManager;
	import nl.dpdk.commands.tasks.Task;
	import nl.dpdk.loader.Loader;
	import nl.dpdk.loader.events.LoaderEvent;
	import nl.dpdk.loader.events.LoaderItemEvent;

	/**
	 * @author rolf
	 */
	public class FillAssetManagerTask extends Task {
		private var loader : Loader;
		private var finished : Boolean = false;

		public function FillAssetManagerTask(loader : Loader) {
			this.loader = loader;
			loader.addEventListener(LoaderItemEvent.DONE, onItemDone);
			//TRICKY, LoaderItemEvent.ERROR is not implemented, the user should listen to a Loader instance if he is interested in error handling
			loader.addEventListener(LoaderEvent.DONE, onLoaderDone);
		}

		private function onLoaderDone(event : LoaderEvent) : void {
			finished = true;
			done();
		}
		
		private function onItemDone(event : LoaderItemEvent) : void {
			AssetManager.add(new Asset(event.getUrl(), event.getLoadedContent(), event.getData()));
		}

		override protected function destroyTaskHook() : void {
			loader.removeEventListener(LoaderItemEvent.DONE, onItemDone);
			loader.removeEventListener(LoaderEvent.DONE, onLoaderDone);
			loader = null;
		}

		override protected function executeTaskHook() : void {
			if(finished){
				done();
			}
		}
	}
}
