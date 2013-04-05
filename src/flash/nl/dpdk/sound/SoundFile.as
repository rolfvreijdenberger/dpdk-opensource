package nl.dpdk.sound {
	import nl.dpdk.commands.tasks.TaskEvent;
	import nl.dpdk.loader.tasks.SoundLoadTask;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author Thomas Brekelmans
	 */
	internal class SoundFile extends EventDispatcher 
	{
		public static var totalNumberOfSoundChannels : uint = 0;		public var instanceNumberOfSoundChannels : uint = 0;
		
		private var _url:String;
		private var _soundId:String;
		private var _groupId:String;
		
		protected var sound:Sound;
		private var soundChannel:SoundChannel;
		
		private var soundLoadTask:SoundLoadTask;

		private var loops:int;
		private var position:Number;
		
		private var _loading:Boolean;
		protected var _loaded:Boolean;
		private var _playing:Boolean;
		
		private var volumeForSound:Number = 1;
		private var volumeForGroup:Number = 1;
		private var volumeForMaster:Number = 1;
		
		private var oldVolume:Number = volumeForSound;
		
		private var muteBitMask:uint;
		private var playAfterLoading:Boolean;
		private var reuseSoundAfterFirstPlay:Boolean;

		
		public function SoundFile(url:String, soundId:String, groupId:String, reuseSoundAfterFirstPlay:Boolean = false) 
		{
			this._url = url;
			this._soundId = soundId;
			this._groupId = groupId;			
			this.reuseSoundAfterFirstPlay = reuseSoundAfterFirstPlay;
			
			initialize();
		}
		
		private function initialize():void
		{
			sound = new Sound();
			
			soundLoadTask = new SoundLoadTask(url, null);
			soundLoadTask.addEventListener(TaskEvent.DONE, soundLoadTaskDoneHandler);
		}

		public function load():void
		{
			if (_loaded == false && _loading == false)
			{
				_loading = true;
				
				initialize();
				
				soundLoadTask.execute();
			}
		}
		
		private function soundLoadTaskDoneHandler(event:TaskEvent):void
		{
			_loading = false;
			_loaded = true;
			sound = soundLoadTask.getLoadedContent();
			
			//clean up the soundLoadTask
			soundLoadTask.removeEventListener(TaskEvent.DONE, soundLoadTaskDoneHandler);
			soundLoadTask.destroy();
			
			if (playAfterLoading)
			{
				startSoundAt(0);
			}
		}
		
		public function play(loops:uint):void
		{
			if( !playing )
			{
				this.loops = loops;
				
				if (loaded)
				{
					startSoundAt(0);
				}
				else
				{
					playAfterLoading = true;
					load();
				}
			}
		}
		
		private function startSoundAt(position:uint):void
		{
			_playing = true;
			//set the position, in case we call 'resume' without pause?
			this.position = position;
			
			soundChannel = sound.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			
			adjustSoundTransform();
		}

		private function soundCompleteHandler(event:Event):void
		{
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			
			// keep the remaining loops up to date to ensure resume works properly
			loops--;
			
			if( loops > 0 )
			{
				startSoundAt(0);
			}
			else
			{
				reset();
				
				dispatchEvent( new SoundFileEvent( SoundFileEvent.SOUND_COMPLETE, this._soundId ) );
			}
		}
		
		public function pause():void
		{
			if( soundChannel )
			{
				position = soundChannel.position;
			}
			stopSound();
		}

		public function resume():void
		{
			if( !_playing )
			{
				//TODO: add if-paused-check
				startSoundAt(position);
			}
		}

		/**
		 * stops the file if it's playing, if it's still loading it will kill the loading and 
		 */
		public function stop():void
		{
			if( playing )
			{
				stopSound();
				reset();
			}
			else 
			{
				if( loading )
				{
					playAfterLoading = false;
					//soundLoadTask.interrupt();
					soundLoadTask.removeEventListener(TaskEvent.DONE, soundLoadTaskDoneHandler);
					soundLoadTask.destroy();
					soundLoadTask = null;
					_loading = false;
				}
			}
		}
		
		private function stopSound():void
		{
			_playing = false;
			if( soundChannel )
			{
				soundChannel.stop();
			}
		}

		public function setVolumeForSound(volume:Number):void
		{
			volumeForSound = volume;
			adjustSoundTransform();
		}
		public function setVolumeForGroup(volume:Number):void
		{
			volumeForGroup = volume;
			adjustSoundTransform();
		}
		public function setVolumeForMaster(volume:Number):void
		{
			volumeForMaster = volume;
			adjustSoundTransform();
		}
		
		private function adjustSoundTransform():void
		{
			if (soundChannel)
			{
				var volume:Number = volumeForSound * volumeForGroup * volumeForMaster;
				// TODO: Double check if this is right / this fixed a bug -- Thomas
				oldVolume = volume;
				
				if( muted )
				{
					volume = 0;
				}
				
				var soundTransform:SoundTransform = new SoundTransform(volume, soundChannel.soundTransform.pan);
				soundChannel.soundTransform = soundTransform;
			}
		}
		
		public function mute(mute:Boolean, muteBit:uint):void
		{
			if (mute)
			{
				muteBitMask |= muteBit;
				processMute();
			}
			else
			{
				//only remove the muteBit and processMute when the bit is set - otherwise it's not needed to process (and volume would be f#cked up)
				if( ( muteBitMask & muteBit ) > 0 )
				{
					muteBitMask &= ~muteBit;
					processMute();
				}
			}
		}
		
		private function processMute():void
		{
			if (soundChannel)
			{
				var volume:Number;
				
				if( muted ) 
				{
					oldVolume = soundChannel.soundTransform.volume;
					volume = 0;
				}
				else
				{
					// TODO: Double check if this is right / this fixed a bug -- Thomas
					volume = oldVolume;
					//volume = (oldVolume != 0) ? oldVolume : 1;
				}
				
				var soundTransform:SoundTransform = new SoundTransform(volume, soundChannel.soundTransform.pan);
				soundChannel.soundTransform = soundTransform;
			}
		}
		
		/*
		 * reset the settings for the soundFile
		 * we want to remove the reference to the sound - so it gets removed from the memory by the GC
		 * but we also want to be able to just address the SoundFile as usual - so we reset all the settings
		 * and the soundFile will just reload the MP3 when asked for it
		 * 
		 * we don't reset the volumes, because those are set from outside the SoundFile
		 * we also don't reset the mute-state, because those are also set from outside
		 */
		private function reset() : void
		{
			soundLoadTask = null;
			
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			soundChannel.stop();
			
			soundChannel = null;
			
			if (reuseSoundAfterFirstPlay == false) sound = null;
		
			loops = 0;
			position = 0;
		
			_loading = false;
			if (reuseSoundAfterFirstPlay == false) _loaded = false;
			_playing = false;
			
			oldVolume = volumeForSound;
		
			playAfterLoading = false;
		}

		public function get muted():Boolean
		{
			return (muteBitMask > 0);
		}

		public function get url():String
		{
			return _url;
		}
		
		public function get soundId():String
		{
			return _soundId;
		}
		
		public function get groupId():String
		{
			return _groupId;
		}
		
		public function get playing():Boolean
		{
			return _playing;
		}
		
		public function get loading():Boolean
		{
			return _loading;
		}

		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		override public function toString():String
		{
		    return "SoundFile[" + soundId + "]";
		}
	}
}