package nl.dpdk.assets {

	/**
	 * @author rolf 
	 * @author thomas
	 */
	public class Asset {
		private var name:String;
		private var data:*;
		private var content:*;
		
		/**
		 * @param name the name of the asset
		 * @param content the content that is relevant for the asset
		 * @param data an optional parameter to add associated data for this content
		 */
		public function Asset(name:String, content: *,  data:* = null) {
			
			this.name = name;
			this.content = content;
			this.data = data;
		}
		
		/**
		 * gets the name that identifies the asset
		 */
		public function getName() : String {
			return name;
		}
		
		/**
		 * gets the data associated with the asset
		 * Note: this is not the content itself
		 */
		public function getData() : * {
			return data;
		}
		
		
		/**
		 * get the content associated with the asset.
		 */
		public function getContent() : * {
			return content;
		}
	}
}
