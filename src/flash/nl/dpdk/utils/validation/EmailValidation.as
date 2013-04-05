package nl.dpdk.utils.validation {

	/**
	 * @author Frank Spee, Thomas Brekelmans
	 */
	public class EmailValidation {
		static public function validateEmail(email : String) : Boolean {
			return (email.match(/(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/) != null);
		}
	}
}