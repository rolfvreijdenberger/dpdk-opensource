package nl.dpdk.sound 
{
	import nl.dpdk.sound.SoundFile;

	import flash.utils.getDefinitionByName;
	
	/**
	 * @author Skar
	 */
	public class EmbeddedSoundFile extends SoundFile 
	{
		public function EmbeddedSoundFile( soundClass : String, soundId : String, groupId : String)
		{
			super("", soundId, groupId, true);
			
			var classReference:Class = getDefinitionByName(soundClass) as Class;
			
			sound = new classReference();			
			_loaded = true;
		}
	}
}
