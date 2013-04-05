package nl.dpdk.utils.validation 
{
	/**
	 * @author Kees Verburg
	 */
	public class TelephoneValidation 
	{
		static public function validateTelephoneNumberDutch(telephoneNumber:String):Boolean 
		{
			return (telephoneNumber.match(/^((\+31|0031)|0)[0-9]{9}$/) != null);
		}
	}
}
