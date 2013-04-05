package nl.dpdk.utils {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;	

	/**
     * DisplayUtils is a library class which provides utility methods for working
     * with DisplayObjects and/or descendant classes.
     * All methods are static and DisplayUtils itself should not be instantiated.
     * Doing so whill throw an error.
     * 
     * @author Thomas Brekelmans / rolf vreijdenberger
     */
	public class DisplayUtils 
	{

        
		/**
		 * Removes all displayObject children in a given displayObjectContainer.
		 */
		public static function removeAllChildren(container:DisplayObjectContainer):void 
		{
			var totalChildren:int = container.numChildren;
			
			while (--totalChildren - (-1)) 
			{
				container.removeChildAt(0);
			}
		}

		/**
		 * Sets the child index of the given child to the top most index available in the given container.
		 * I.e. places the given child on top of all other childs of the given container.
		 */
		public static function setToTopIndex(container:DisplayObjectContainer, child:DisplayObject):void
		{
			if (child == null || container == null) return;
			
			container.setChildIndex(child, container.numChildren - 1);
		}

		/**
		 * Sets the child index of the given child to the lowest index available in the given container.
		 * I.e. places the given child below all other childs of the given container.
		 */
		public static function setToBottomIndex(container:DisplayObjectContainer, child:DisplayObject):void
		{
			if (child == null || container == null) return;
			
			container.setChildIndex(child, 0);
		}
		
		/**
		 * draws a bitmap object in a container of type displayobjectcontainer.
		 * The bitmap can be a loaded asset or something we manufactured ourselves
		 */
		public static  function drawBitmapInDisplayObject(bmp : Bitmap, object : DisplayObjectContainer, smoothing : Boolean = true) : void {
			object.addChild(bmp);
			bmp.smoothing = smoothing;
			bmp.bitmapData.draw(object);
		}
		
		/**
		 * returns a reference to a new MovieClip that is linked via the flash library
		 * @param fullyQualifiedClassName the fully qualified classname of the movieclip eg: nl.dpdk.ui.widget
		 */
		public static function getLibraryMovieClip(fullyQualifiedClassName: String): MovieClip {
			return getLibrarySprite(fullyQualifiedClassName) as MovieClip;
		}
		
		/**
		 * returns a reference to a new Sprite that is linked via the flash library
		 * @param fullyQualifiedClassName the fully qualified classname of the sprite eg: nl.dpdk.graphics.logo
		 */
		public static function getLibrarySprite(fullyQualifiedClassName: String): Sprite {
				return new (getDefinitionByName(fullyQualifiedClassName))();
		}
	}
}
