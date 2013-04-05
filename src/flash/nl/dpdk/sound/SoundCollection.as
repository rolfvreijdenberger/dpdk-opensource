package nl.dpdk.sound {
	import flash.events.EventDispatcher;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	/**
	 * @author Thomas Brekelmans
	 */
	public class SoundCollection extends EventDispatcher 
	{
		private var soundFiles:Dictionary;
		private var groups:Dictionary;
		
		private var muteSoundTransform : SoundTransform;
		private var unmuteSoundTransform : SoundTransform;

		public function SoundCollection()
		{
			initialize();	
		}
		
		private function initialize():void
		{
			soundFiles = new Dictionary();  
			groups = new Dictionary();
			
			muteSoundTransform = new SoundTransform(0, 0);
			unmuteSoundTransform = SoundMixer.soundTransform;
		}
		
		public function add(url:String, soundId:String, groupId:String = "defaultGroupId", reuseSoundAfterFirstPlay:Boolean = false):void
		{
			soundFiles[soundId] = createSoundFile(url, soundId, groupId, reuseSoundAfterFirstPlay); 
			
			if (groups[groupId] == null)
			{
				groups[groupId] = new Dictionary();
			}
			
			groups[groupId][soundId] = soundFiles[soundId];
		}
		
		private function createSoundFile(url:String, soundId:String, groupId:String, reuseSoundAfterFirstPlay:Boolean):SoundFile
		{
			var soundFile:SoundFile = new SoundFile(url, soundId, groupId, reuseSoundAfterFirstPlay); 
			soundFile.addEventListener( SoundFileEvent.SOUND_COMPLETE, onSoundCompleteHandler);
			return soundFile;
		}
		
		public function addEmbedded( soundClass:String, soundId:String, groupId:String = "defaultGroupId" ) : void
		{
			soundFiles[soundId] = createEmbeddedSoundFile( soundClass, soundId, groupId ); 
			
			if (groups[groupId] == null)
			{
				groups[groupId] = new Dictionary();
			}
			
			groups[groupId][soundId] = soundFiles[soundId];
		}
		
		private function createEmbeddedSoundFile(soundClass:String, soundId:String, groupId:String):EmbeddedSoundFile
		{
			var embeddedSoundFile:EmbeddedSoundFile = new EmbeddedSoundFile(soundClass, soundId, groupId); 
			embeddedSoundFile.addEventListener( SoundFileEvent.SOUND_COMPLETE, onSoundCompleteHandler);
			return embeddedSoundFile;
		}
		
		private function onSoundCompleteHandler(event:SoundFileEvent):void
		{
			dispatchEvent( event );
		}

		public function load(soundId:String):void
		{
			try
			{
				getSoundFile(soundId).load();
			}
			catch (e:Error)
			{
				// error
				//Log.debug("SoundCollection.load() error in loading soundId : " + soundId + "  reason : " + e.message);
			}
		}
		
		public function play(soundId:String, loops:uint = 0):void
		{
			try
			{
				getSoundFile(soundId).play(loops);
			}
			catch (e:Error)
			{
				// error
				//Log.debug("SoundCollection.play() error in playing soundId : " + soundId + "  reason : " + e.message);
			}
		}
		
		public function resume(soundId:String):void
		{
			try
			{
				getSoundFile(soundId).resume();
			}
			catch (e:Error)
			{
				// error
				//Log.debug("SoundCollection.resume() error in resuming soundId : " + soundId + "  reason : " + e.message);
			}
		}
		
		public function stop(soundId:String):void
		{
			try
			{
				getSoundFile(soundId).stop();
			}
			catch (e:Error)
			{
				// error
				//Log.debug("SoundCollection.stop() error in stopping soundId : " + soundId + "  reason : " + e.message);
			}			
		}
		
		public function setVolumeForSound(soundId:String, volume:Number):void
		{
			try
			{
				getSoundFile(soundId).setVolumeForSound(volume);
			}
			catch (e:Error)
			{
			}
		}
		
		public function setVolumeForGroup(groupId:String, volume:Number):void
		{
			for each (var soundFile:SoundFile in groups[groupId])
			{
				soundFile.setVolumeForGroup(volume);
			}
		}
		
		public function setVolumeForMaster(volume:Number):void
		{
			for each (var soundFile:SoundFile in soundFiles)
			{
				soundFile.setVolumeForMaster(volume);
			}
		}
		
		public function isPlaying( soundId:String ) : Boolean
		{
			try
			{
				return getSoundFile(soundId).playing;
			}
			catch (e:Error)
			{
			}
			return false;
		}
		
		public function isLoading(soundId:String):Boolean
		{
			try
			{
				return getSoundFile(soundId).loading;
			}
			catch (e:Error)
			{
			}
			return false;
		}
		
		public function getGroupBySoundId( soundId:String ) : String
		{
			try
			{
				return getSoundFile(soundId).groupId;
			}
			catch (e:Error)
			{
			}
			return "";
		}
		
		/**
		 * returns true/false if a soundfile in the group - where the given soundId belongs too - is playing
		 */
		public function isGroupPlaying( soundId:String ) : Boolean
		{
			// if the soundId you provide is already playing, there is no need anymore to check the whole group
			if( isPlaying(soundId) )
			{
				return true;
			}
			
			var groupId:String = getGroupBySoundId( soundId );
			
			for each (var soundFile:SoundFile in groups[groupId])
			{
				if( soundFile.playing ) 
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function muteSound(soundId:String, mute:Boolean):void
		{
			try
			{
				getSoundFile(soundId).mute(mute, MuteBits.MUTE_SOUND);
			}
			catch(e:Error)
			{
				
			}
		}
		
		public function muteGroup(groupId:String, mute:Boolean):void
		{
			for each (var soundFile:SoundFile in groups[groupId])
			{
				soundFile.mute(mute, MuteBits.MUTE_GROUP);
			}
		}
		
		public function muteMaster(mute:Boolean):void
		{
			for each (var soundFile:SoundFile in soundFiles)
			{
				soundFile.mute(mute, MuteBits.MUTE_MASTER);
			}
			
			if (mute)
			{
				unmuteSoundTransform = SoundMixer.soundTransform;
				SoundMixer.soundTransform = muteSoundTransform;
			}
			else
			{
				SoundMixer.soundTransform = unmuteSoundTransform;
			}
		}
		
		private function getSoundFile( soundId:String ) : SoundFile
		{
			//instead of calling this method, we could also do 'soundFiles[soundId]'
			// but this way we have compile-time type-checking instead of runtime 
			try
			{
				return soundFiles[soundId];
			}
			catch (e:Error)
			{
			//	Log.debug("SoundCollection.getSoundFile() error, soundfile not found errormessage : " + e.message);
			}
			return null;
		}
		
		override public function toString():String
		{
		    return "SoundCollection";
		}
	}
}
