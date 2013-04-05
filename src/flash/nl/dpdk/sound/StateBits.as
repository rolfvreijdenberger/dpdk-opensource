package nl.dpdk.sound 
{
	/**
	 * @author Oskar van Velden
	 */
	public class StateBits 
	{
		public static const STATE_LOADING:uint 	= 1 << 0; // 1
		public static const STATE_LOADED:uint 	= 1 << 1; // 10
		public static const STATE_PLAYING:uint 	= 1 << 2; // 100		public static const STATE_PAUSED:uint 	= 1 << 3; // 1000		public static const STATE_STOPPED:uint 	= 1 << 4; // 10000
	}
}
