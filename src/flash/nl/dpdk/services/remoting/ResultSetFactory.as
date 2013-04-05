/*
Copyright (c) 2008 De Pannekoek en De Kale B.V.,  www.dpdk.nl

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
package nl.dpdk.services.remoting 
{
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.sets.ResultRow;
	import nl.dpdk.collections.sets.ResultSet;	

	/**
	 * This Factory creates a ResultSet object from the data that comes back via the result of a call with flash remoting.
	 * 
	 * @see ResultRow
	 * @see ResultSet
	 * 
	 * @author Rolf Vreijdenberger
	 */
	public class ResultSetFactory 
	{


		/**
		 * creates a result set from raw flash remoting data.
		 * @param from the raw remoting data
		 * @return a new ResultSet
		 */
		public static function create(from:*):ResultSet 
		{
			/**
			 * expected properties on a Recordset returned from flash remoting:
			 * serverInfo an Object
			 * serverInfo.totalCount(number of the records)
			 * serverInfo.initialData (2d array with the record data)
			 * serverInfo.cursor (number)
			 * serverInfo.serviceName (string eg: pageAbleResult)
			 * serverInfo.columnNames (array with strings of the columnnames. the position is the position of the rows in initialData)
			 * serverInfo.version (number eg: 1)
			 * serverInfo.id (string eg:  801edfcdb7440171a8f208c041cbc452)
			 */
			var columns:List = new ArrayList();
			var row:ResultRow;
			var rowData:Array;
			var totalRowFields:int;
			var serverInfo:Object = null;
			var totalColumnNames:int;
			var totalInitialData:int;

			//notice the uppercase and lowercase i in serverInfo
			if (from.serverInfo == null) 
			{
				if (from.serverinfo != null) 
				{
					serverInfo = from.serverinfo;
				}
			}
			else 
			{
				serverInfo = from.serverInfo;
			}
			totalColumnNames = serverInfo.columnNames.length;
			totalInitialData = serverInfo.initialData.length;
			//get the column names
			var i:int;
			for (i = 0;i < totalColumnNames; ++i) 
			{
				columns.add(serverInfo.columnNames[i]);
			}
			
			
			//create the resultset
			var resultSet:ResultSet = new ResultSet(columns);
			//fill the rows
			var j:int;
			for (i = 0;i < totalInitialData; ++i) 
			{
				rowData = serverInfo.initialData[i];
				totalRowFields = rowData.length;
				//create a new ResultRow with an id
				row = new ResultRow();
				for (j = 0;j < totalRowFields; ++j) 
				{
					//dynamic setting of properties
					row[columns.get(j)] = rowData[j];
				}
				resultSet.add(row);
			}			
			return resultSet;
		}
	}
}
