/*
Copyright (c) 2009 De Pannekoek en De Kale B.V.,  www.dpdk.nl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */
package nl.dpdk.utils.timeline {
	import nl.dpdk.collections.dictionary.HashMap;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	/**
	 * Frame script manager allows you to easily trigger callbacks from labels in a given MovieClip.
	 * 
	 * @usage
	 * An example use of a FrameScriptManager might be for use with a screen (with transitions):
	 * Assume a Screen class which extends MovieClip.
	 * The ScreenAsset has these frame labels defined:
	 * show (at the beginning of a show animation on the timeline)
	 * showDone (at the end of a show animation on the timeline, when the animation is finished)
	 * hide (at the beginning of a hide animation on the timeline)
	 * hideDone (at the end of a hide animation on the timeline, when the hide animtaion is finished)
	 * 
	 * This might be code that goes inside the Screen class:
	 * <code>
	 * private function initialize():void
	 * {
	 * 		frameScriptManager = new FrameScriptManager(this);
	 * 		frameScriptManager.add("showDone", screenShowDoneHandler);
	 * 		frameScriptManager.add("hideDone", screenHideDoneHandler);
	 * }
	 * 
	 * public function show():void
	 * {
	 * 		// implement screen disable logic here
	 * 		gotoAndPlay("show"); // (will play the timeline to the showDone label)
	 * }
	 * public function hide():void
	 * {
	 * 		// implement screen disable logic here
	 * 		gotoAndPlay("hide"); // (will play the timeline to the hideDone label)
	 * }
	 * 
	 * private function screenShowDoneHandler():void
	 * {
	 * 		// implement logic that needs to be executed when the screen has done it's display animation
	 * }
	 * private function screenHideDoneHandler():void
	 * {
	 * 		// implement logic that needs to be executed when the screen has done it's hide animation
	 * }
	 * </code>
	 * 
	 * This class is similar to TimelineListener but takes a different approach to the same problem.
	 * The problem is that you want to have a trigger of reaching a specific frame(label) in a MovieClip
	 * inside a class which has some sort of a reference to that MovieClip.
	 * To create a seperation of concerns for developers and designers, they only have to agree on the framelabel naming convention
	 * and they can both do their thing.
	 * 
	 * The approach of the TimelineListener is a passive one, in that it dispatches an event for each
	 * frame, label or scene reached and expects the user of the class to (usually) switch on the 
	 * frame number, frame label name or scene name and call the appropriate callback accordingly.
	 * 
	 * The approach of the FrameScriptManager is a direct one, in that it expects the user of the class
	 * to map the appropriate callback directly on the desired frame label.
	 * 
	 * Which class/approach you take depends on personal preference and desired functionality.
	 * 
	 * @author Frank Spee
	 * @author Thomas Brekelmans
	 */
	public class FrameScriptManager
	{
		// Reference to the related movieClip.
		private var movieClip:MovieClip;
		// A collection of the current frame labels.
		private var _frameLabels:HashMap;

		/**
		 * Creates a new FrameScriptManager.
		 */
		public function FrameScriptManager(movieClip:MovieClip)
		{	
			// Save the reference to the related movieClip.
			this.movieClip = movieClip;
			
			// Get the frame labels from the assigned movieClip and create a frame label collection.
			createFrameLabelsCollection();
		}

		/**
		 * Create the frame labels collection from the referenced movieClip.
		 */
		private function createFrameLabelsCollection():void
		{
			_frameLabels = new HashMap(5);
			
			// Loop through the current labels collection to get the frame labels.
			for each (var label:FrameLabel in movieClip.currentLabels)
			{
				// Add the label name and frame to the frame labels dictionary.
				frameLabels.insert(label.name, label.frame);
			}
		}

		/**
		 * Adds a frame script to a frame label, wraps around the MovieClip.addFrameScript().
		 * @param labelName		Label name used in the timeline.
		 * @param callback	The function invoked as a listener in an event handler.
		 */
		public function add(labelName:String, callback:Function):void
		{
			try
			{
				// The frame number is zero based (frame 1 = 0), so we need to subtract 1 from the framelabel from the currentlabels.
				var label: uint = frameLabels.search(labelName);
				label -= 1;
				movieClip.addFrameScript(label, callback);
			}
			catch (error:Error)
			{
				trace("FrameScriptManager.add() error.message: " + error.message);
			}
		}


		/**
		 * Returns an object with the name of the frame label as a key and the number of the frame on which
		 * the frame label is placed as a value.
		 */
		public function get frameLabels():HashMap
		{
			return _frameLabels;
		}
		
		/**
		 * Destroy the FrameScriptManager to make it ready to be deleted.
		 */
		public function destroy():void {
			_frameLabels.clear();
			_frameLabels = null;
			movieClip = null;
		}

		/**
		 * Returns the class name in a String.
		 */
		public function toString():String 
		{
			return "FrameScriptManager";
		}
	}
}