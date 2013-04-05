package nl.dpdk.services.gephyr 
{

	/**
	 * Holds the data from a call to the drupal backend.
	 * the raw data can be retrieved via getData();
	 * the id of the call can be retrieved by getRemoteCallId(). 
	 * This is very useful for instance when using a call to get a drupal view. 
	 * In this way, you can id which view you retrieved when you get the results back from drupal.
	 * any error can be retrieved via getMessage(). The raw amf error data is in getData()
	 * 
	 * DrupalData will be passed as the only argument to both a result and a status handling function registered via DrupalProxy.addHandler();
	 * @see nl.dpdk.services.gephyr.DrupalProxy
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	public class DrupalData 
	{
		private var data:*;
		private var remoteCallId:String;
		private var message:String;

		public function DrupalData(data:*, remoteCallId:String, message:String) 
		{
			
			this.message = message;
			this.remoteCallId = remoteCallId;
			this.data = data;
		}


		/**
		 * gets the message associated with DrupalData passed as an argument to a status handler.
		 */
		public function getMessage():String 
		{
			return message;
		}


		/**
		 * gets the data associated with DrupalData passed as an argument to a result handler or a status handler.
		 * In case of a result handler, it is the data retrieved from the Drupal service call.
		 * In case of a status handler, it is the raw error data retrieved from the Drupal service call, the human readable error message can be retrieved by getMessage().
		 */
		public function getData():* 
		{
			return data;
		}


		/**
		 * the data/id associated (if set on DrupalProxy before the data call was made) with this result of a specific remote call.
		 * Very useful for identification of which specific result you're handling if you make multiple calls to the same service method on the Drupal backend.
		 */
		public function getRemoteCallId():String 
		{
			return remoteCallId;
		}
	}
}
