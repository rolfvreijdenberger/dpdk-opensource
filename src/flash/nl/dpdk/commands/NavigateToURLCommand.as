package nl.dpdk.commands {
	import nl.dpdk.utils.URLUtils;
	import nl.dpdk.commands.ICommand;

	/**
	 * Concrete Command that will go to the url specified in the constructor.
	 * 
	 * 
	 * @author rolf vreijdenberger
	 * @author Kees Verburg
	 */
	public class NavigateToURLCommand implements ICommand {

		private var url : String;
		private var target : String;

		public function NavigateToURLCommand(url: String, target: String = "_blank") {
			
			this.target = target;
			this.url = url;
		}

		public function execute() : void {
			URLUtils.getURL(url, target);
		}
	}
}
