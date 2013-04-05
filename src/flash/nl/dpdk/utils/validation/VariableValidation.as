package nl.dpdk.utils.validation {

	/**
	 * @author Thomas Brekelmans
	 */
	public class VariableValidation {
		public static function isSet(variable : *) : Boolean {
			return variable != null && variable != undefined && variable != "";
		}
	}
}
