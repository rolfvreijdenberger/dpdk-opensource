package nl.dpdk.sound 
{
	import nl.dpdk.specifications.Specification;

	/**
	 * @author Thomas Brekelmans
	 */
	public class SoundFileBySoundIdSpecification extends Specification 
	{
		private var soundId:String;
		
		public function SoundFileBySoundIdSpecification(soundId:String) 
		{
			this.soundId = soundId;	
		}
		
		override public function isSatisfiedBy(candidate:*):Boolean
		{
			var soundFile:SoundFile = candidate as SoundFile;
					
			return soundFile.soundId == this.soundId;
		}
	}
}
