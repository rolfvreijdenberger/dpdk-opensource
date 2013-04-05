package nl.dpdk.services.gephyr 
{

	/**
	 * internal Helper class
	 * maps a Service.methodName pair to a result and status handler in drupalproxy
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	internal class DrupalCallMapper 
	{
		private var result:Function;
		private var status:Function;

		public function DrupalCallMapper(result: Function, status: Function) 
		{
			
			this.status = status;
			this.result = result;
		}
		
		public function getResult():Function
		{
			return result;
		}
		
		public function getStatus():Function
		{
			return status;
		}
	}
}
