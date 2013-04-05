package nl.dpdk.utils {
	import flash.display.DisplayObject;

	/**
	 * @author Thomas Brekelmans
	 */
	public class ResizeUtils {
		/**
		 * Resized the given DisplayObject to fill at least the desiredWidth and desiredHeight while maintaning the ratio between the width and height of the DisplayObject.
		 * Some cropping will occur when the DisplayObject ratio is different from the ratio between desiredWidth and desiredHeight.
		 * 
		 * TODO: Make cropping optional. 
		 */
		public static function resizeToRatio(displayObject : DisplayObject, desiredWidth : Number, desiredHeight : Number) : void {
			if (displayObject) {
				var originalRatio : Number = displayObject.width / displayObject.height;
				var desiredRatio : Number = desiredWidth / desiredHeight;
				if (desiredRatio > originalRatio) {
					displayObject.width = desiredWidth;
					displayObject.height = desiredWidth / originalRatio;
					displayObject.x = 0;
					displayObject.y = (desiredHeight - displayObject.height) / 2;
				} else {
					displayObject.height = desiredHeight;
					displayObject.width = desiredHeight * originalRatio;
					displayObject.y = 0;
					displayObject.x = (desiredWidth - displayObject.width) / 2;
				}
			}
		}
	}
}
