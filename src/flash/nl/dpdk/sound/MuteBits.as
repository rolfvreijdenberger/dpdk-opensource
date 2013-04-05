package nl.dpdk.sound 
{

	/**
	 * @author Thomas Brekelmans
	 */
	internal class MuteBits 
	{
		public static const MUTE_SOUND:uint = 1 << 0; // 1
		public static const MUTE_GROUP:uint = 1 << 1; // 10
		public static const MUTE_MASTER:uint = 1 << 2; // 100
	}
}
