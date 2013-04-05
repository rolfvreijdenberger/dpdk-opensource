package nl.dpdk.utils.easyContextMenu {
	import nl.dpdk.collections.dictionary.HashMap;

	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;

	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.commands.ICommand;

	/**
	 * @usage

	 var myEasyContextMenu : EasyContextMenu = new EasyContextMenu();
	 myEasyContextMenu.add("dpdk", new NavigateToURLCommand("http://www.dpdk.nl"));
	 
	 stage.contextMenu.items = myEasyContextMenu.customItems
	 
	 * 
	 * @author Thomas Brekelmans
	 */
	public class EasyContextMenu {
		private var _customItems : ArrayList;
		private var labelToCommandMap : HashMap;

		public function EasyContextMenu() {
			initialize();
		}

		private function initialize() : void {
			_customItems = new ArrayList();
			
			labelToCommandMap = new HashMap();
		}
		
		/**
		 * Adds the given label to the context menu.
		 * ClickCommand is executed when the user selects (clicks) the given label from the context menu.
		 */
		public function add(label : String, clickCommand : ICommand) : void {
			var contextMenuItem : ContextMenuItem = new ContextMenuItem(label);
			contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItemSelectHandler);
			
			_customItems.push(contextMenuItem);
			
			labelToCommandMap.insert(label, clickCommand);
		}

		private function contextMenuItemSelectHandler(event : ContextMenuEvent) : void {
			labelToCommandMap.search(event.target.caption).execute();
		}
		
		/**
		 * Returns a valid Array of custom context menu items to set to the current contextMenu property of a display object.
		 * Eg. stage.contextMenu.items = myEasyContextMenu.customItems;
		 */
		public function get customItems() : Array {
			return _customItems.toArray();
		}
	}
}
