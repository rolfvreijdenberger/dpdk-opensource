package nl.dpdk.assets {
	import nl.dpdk.collections.dictionary.HashMap;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.iteration.UnmodifiableIterator;

	/**
	 * @author rolf
	 * @author thomas brekelmans
	 */
	public class AssetManager {
		
		private static var assets: HashMap;
		
		public function AssetManager() {
			throw new Error("do not instantiate");
		}
		
		public static function add(asset: Asset):Boolean {
			return assets.insert(asset.getName(), asset);
		}
		
		public static function remove(asset: Asset):Boolean {
			return assets.remove(asset.getName());
		}
		
		public static function get(name:String):Asset
		{
			return assets.search(name);
		}
		
		public static function iterator(): IIterator {
			return new UnmodifiableIterator(assets.iterator());
		}
		
		public static function size(): int {
			return assets.size();
		}
	}
}
