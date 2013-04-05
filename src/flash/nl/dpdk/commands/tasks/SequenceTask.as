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
package nl.dpdk.commands.tasks {
	import nl.dpdk.commands.tasks.Task;

	/**
	 * SequenceTask wraps a Sequence, so it can be used to form nested sequences of tasks inside a Sequence.
	 * Very powerful!
	 * @author Rolf Vreijdenberger
	 */
	public class SequenceTask extends Task {
		private var sequence : Sequence;

		public function SequenceTask(sequence : Sequence) {
			this.sequence = sequence;
			sequence.addEventListener(SequenceEvent.DONE, onDone);
			sequence.addEventListener(SequenceEvent.ERROR, onError);
		}

		private function onError(event : SequenceEvent) : void {
			fail(event.getMessage());
		}

		private function onDone(event : SequenceEvent) : void {
			done();
		}

		override protected function executeTaskHook() : void {
			sequence.execute();
		}

		override protected function destroyTaskHook() : void {
			sequence.removeEventListener(SequenceEvent.DONE, onDone);
			sequence.removeEventListener(SequenceEvent.ERROR, onError);
		}

		override public function toString() : String {
			return "SequenceTask";
		}
	}
}
