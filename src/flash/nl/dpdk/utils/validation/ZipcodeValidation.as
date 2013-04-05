package nl.dpdk.utils.validation 
{
	/**
	 * @author Kees Verburg
	 */
	public class ZipcodeValidation 
	{
		static public function validateZipcodeDutch(zipcode:String):Boolean 
		{
			return (zipcode.match(/^([0-9]){4} ?([a-zA-z]){2}$/) != null);
		}
	}
}
