package nl.dpdk.services.gephyr {
	import nl.dpdk.utils.DateUtils;

	/**
	 * Utils class for drupal based stuff.
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	public class DrupalUtils {
		public static const TYPE_PAGE : String = "page";
		public static const TYPE_STORY : String = "story";
		public static const MENU_PRIMARY : String = "primary-links";
		public static const MENU_SECONDARY : String = "secondary-links";
		public static const MENU_NAVIGATION : String = "navigation";
		public static const SERVICE_NODE : String = "node";
		public static const SERVICE_SYSTEM : String = "system";
		public static const SERVICE_VIEWS : String = "views";
		public static const SERVICE_TAXONOMY : String = "taxonomy";
		public static const SERVICE_USER : String = "user";
		public static const SERVICE_MENU : String = "menu";
		public static const SERVICE_FILE : String = "file";
		public static const SERVICE_SEARCH : String = "search";

		/**
		 * returns a simple drupal user object.
		 * @param name the name of the user
		 * @param email the email of the user
		 * @param uid Optional parameter, defaults to the uid of a new user. If another number is specified user.save will update the existing user
		 */
		public static function createUser(name : String, email : String, uid : uint = 0):Object {
			var user : Object = new Object();
			user.name = name;
			user.email = email;
			user.uid = uid;
			return user;
		}

		/**
		 * returns a simple drupal node object, with a proper timestamp for creation date.
		 * @param type The type of the node, either a built in type such as DrupalUtils.TYPE_PAGE or TYPE_STORY or a custom type
		 * @param title The title of the node
		 * @param body Optional parameter, the body of the node
		 * @param nid Optional parameter, defaults to the nid of a new node
		 */
		public static function createNode(type : String, title : String, body : String = "", nid : int = 0):Object {
			var node : Object = new Object();
			node.type = type;
			node.created = DateUtils.dateToUnixTimeStamp(new Date());
			node.title = title;
			node.body = body;
			node.nid = nid;
			return node;
		}

		/**
		 * PHP's function print_r for drupal
		 * @param data    data to be printed
		 * @param output the output (used in recursive call)
		 * @param level  depth of recursivity (used in recursive calls)
		 */
		public static function print_r(data : *, output : String = '', level : int = 0):* {
			if(typeOf(data) != "Array" && typeOf(data) != "object" && level == 0) {
				output += '\n(' + DrupalUtils.typeOf(data) + ') ' + data;
				return output;
			}
			if(level == 0) {
				output += '\n(' + DrupalUtils.typeOf(data) + ') {\n';
			} else if(level == 10) {
				return output;
			}
			
			var tabs : String = '\t';
			for(var i : int = 0; i < level; i++, tabs += '\t') {
			}
			for(var child:* in data) {
				output += tabs + '[' + child + '] => (' + DrupalUtils.typeOf(data[child]) + ') ';

				if(DrupalUtils.count(data[child]) == 0)
					output += data[child];

				var childOutput : String = '';
				if(typeof data[child] != 'xml') {
					childOutput = DrupalUtils.print_r(data[child], '', level + 1);
				}
				if(childOutput != '') {
					output += '{\n' + childOutput + tabs + '}';
				}
				output += '\n';
			}

			if(level == 0) {
				output += "}";
			}
			return output;
		}

		/**
		 * used for the print_r method
		 */
		private static function typeOf(variable : *):String {
			if(variable is Array)
				return 'array';
			else if(variable is Date)
				return 'date';
			else
				return typeof variable;
		}

		/**
		 * used for the print_r method
		 */
		private static function count(obj : Object):uint {
			if(DrupalUtils.typeOf(obj) == 'array')
				return obj.length;
			else {
				var len : uint = 0;
				for(var item:* in obj) {
					if(item != 'mx_internal_uid')
						len++;
				}
				return len;
			}
		}
	}
}
