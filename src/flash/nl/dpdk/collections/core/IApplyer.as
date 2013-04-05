package nl.dpdk.collections.core {

	/**
	 * Used on an IApplyable, probably a list of some sorts, where an IApplayer is passed to a method.
	 * The list itself will then pass each item to the IApplyers execute() method as context, so an algorithm can be applied to the context.
	 * @author rolf
	 */
	public interface IApplyer {
		
		/**
		 * An instance of IApplyer can have context provided in the constructor when this is necessary.
		 * @param context an item passed in to be transformed, altered, adjusted.
		 * The method itself contains the logic to apply whatever you want to do to the object.
		 */
		function execute(context: *):void;
	}
}
