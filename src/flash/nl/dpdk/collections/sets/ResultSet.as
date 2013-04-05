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

package nl.dpdk.collections.sets 
{
	import nl.dpdk.collections.core.ICollection;
	import nl.dpdk.collections.core.ISelectable;
	import nl.dpdk.collections.core.ISortable;
	import nl.dpdk.collections.core.UnmodifiableCollection;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.ArrayList;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.collections.sets.ResultRow;
	import nl.dpdk.collections.sorting.SortTypes;
	import nl.dpdk.specifications.ISpecification;	

	/**
	 * ResultSet is an abstraction of a datastructure that contains rows of different datatypes.
	 * The names of the fields are provided by the column names, and the contents are in the row objects.
	 * To be fully operational, a ResultSet allows dynamic creation and access and therefore  does not provide type safety on the fields.
	 * <p><p>
	 * The ResultSet also allows fast access of the i-th element of the resultset, so we can use both the iterator and a for loop to go over the resultset.
	 * <p><p>
	 * ResultSet will be mostly used in conjunction with data returned from amf remoting calls to the server, 
	 * where complete resultsets from a database query are sent back to the client.
	 * This is also the main reason why the ResultSet has a home in the sets package, as rows from a database are inherently unique (provided we follow normal forms of DDL).
	 * But this class does not really function as a set, because we might insert duplicates if we want. We do not check for this as this is a performance penalty.
	 * <p><p>
	 * A ResultSet's column names can only be set at creation time and they are unmodifiable.
	 * @author Rolf Vreijdenberger, Thomas Brekelmans
	 */
	public class ResultSet implements ICollection, ISortable, ISelectable 
	{
		/**
		 * a list of ResultRow objects.
		 * it is an ArrayList for fast access to the i-th item.
		 */
		private var rows : List = new ArrayList();
		/**
		 * a list of strings containing column names
		 */
		private var columns : List;
		/**
		 * sets a flag for checking the validity of a ResultRow during the add() operation.
		 * this will influence serialization performance.
		 */
		private var checkRowsForValidity : Boolean = false;

		/**
		 * @param columns a collection of Strings that represent the column names
		 * @param rows a collection of ResultRows objects that represent the rows. ResultRows must contain properties that correspond to the column names.
		 * @throws Error an error if colums are not of type String.
		 * @throws Error an error if rows do not contain ResultRow objects.
		 * @throws Error an error if setCheckRowsForValidity is set to true and there are ResultRows that do not contain all columnnames.
		 * @see add
		 * @see getCheckRowsForValidity
		 */
		public function ResultSet(columns : ICollection, rows : ICollection = null) 
		{
			setColums(columns);
			setRows(rows);
		}

		
		private function setColums(columns : ICollection) : void 
		{
			var iterator : IIterator = columns.iterator();
			var value : *;
			while(iterator.hasNext()) 
			{
				value = iterator.next();
				if(!(value is String)) 
				{
					throw new Error("Only Strings are allowed as column names.");
				}
			}
			this.columns = new ArrayList(columns);
		}

		
		private function setRows(rows : ICollection = null) : void 
		{
			if(rows == null) return;
			var iterator : IIterator = rows.iterator();
			while(iterator.hasNext()) 
			{
				add(iterator.next());
			}	
		}

		
		/**
		 * Get an unmodifiable list of columns.
		 * Use with ICollection.size() or with ICollection.iterator() to loop through the properties of the ResultRow objects.
		 */
		public function getColumns() : ICollection 
		{
			return new UnmodifiableCollection(columns);
		}

		
		/**
		 * gets all the fields in a certain column, where the column is specified by the index of the columnlist.
		 * @param i the index of the column
		 * @return an instance of ICollection containing all fields for the column.
		 */
		public function getColumnAt(i : int) : ICollection
		{
			var list : List = new ArrayList();
			if(i < 0 || i >= columns.size())
			{
				return list;	
			}
			var name : String = columns.get(i) as String;
			var iterator : IIterator = rows.iterator();
			var row : ResultRow;
			while(iterator.hasNext())
			{
				row = iterator.next() as ResultRow;
				list.add(row[name]);
			}
			return list;
		}

		
		/**
		 * gets all the fields in a certain column, where the column is specified by it's name.
		 * @param name the name of the column
		 * @return an instance of ICollection containing all fields for the column.
		 */
		public function getColumnByName(name : String) : ICollection
		{
			return getColumnAt(columns.indexOf(name));
		}

		
		/**
		 * get all the rows in the ResultSet.
		 * It will be a collection of ResultRow objects.
		 * @return an instance of an ICollection.
		 */
		public function getRows() : ICollection 
		{
			return rows;	
		}

		
		/**
		 * gets a ResultRow at a certain index.
		 * @param i the index to get the ResultRow from.
		 * @return the ResultRow if a valid index is provided, null otherwise.
		 */
		public function getRowAt(i : int) : ResultRow 
		{
			return rows.get(i);	
		}

		


		
		/**
		 * add a ResultRow to the ResultSet.
		 * @param data the ResultRow to add to the ResultSet
		 * @throws An error if setCheckRowsForValidity is true and the ResultRow does not hold all of the columnname properties.
		 */
		public function add(data : *) : void 
		{
			if(data is ResultRow) 
			{
				var row : ResultRow = data as ResultRow;
				//see if the user wants to check the rows for validity.
				if(getCheckRowsForValidity()) 
				{
					//extra check that columnames exist in the object that we get.
					//this might cause a lot of overhead when constructing a resultset, but gives an extra check on the validity of the resultset.
					var iterator : IIterator = columns.iterator();
					while(iterator.hasNext()) 
					{
						var property : String = iterator.next();
						if (row.hasOwnProperty([property])) {
							//all is well, the added row conforms to the expected column signature.
						}else 
						{
							//all is not well.
							throw new Error("The ResultRow does not contain property'" + property + "'.");
						}
					}
				}
				//now add the row
				rows.add(data);	
			}
		}

		
		/**
		 * clears the content of the rows in the resultset, but leaves the columnnames intact
		 */
		public function clear() : void 
		{
			rows.clear();
		}

		
		/**
		 * checks if a certain ResulRrow is in the resultset.
		 * this is checked by comparing each object's identity.
		 * To check for specific values in the resultrow, use the selectBy method with a specification of what the row should look like.
		 */
		public function contains(data : *) : Boolean 
		{
			if(data is ResultRow) 
			{
				return rows.contains(data);	
			}
			return false;
		}

		
		/**
		 * checks whether there are any rows in the ResultSet.
		 * @inheritDoc
		 */
		public function isEmpty() : Boolean 
		{
			return rows.isEmpty();
		}

		
		/**
		 * @inheritDoc
		 */
		public function remove(data : *) : Boolean 
		{
			if(data is ResultRow) 
			{
				return rows.remove(data);	
			}
			return false;
		}

		
		/**
		 * returns the number of rows.
		 * @inheritDoc
		 */
		public function size() : int 
		{
			return rows.size();
		}

		
		/**
		 * iterator over the rows of the ResultSet
		 * @inheritDoc
		 */
		public function iterator() : IIterator 
		{
			return rows.iterator();
		}

		
		/**
		 * the comparator should operate on a ResultRow.
		 * @param comparator the comparator function to use. Use the default sort type on more or less unordered ResultSets. Use insertion sort for nearly ordered lists.
		 * @param sortType
		 */
		public function sort(comparator : Function, sortType : int = SortTypes.QUICK) : void 
		{
			rows.sort(comparator, sortType);
		}

		
		/**
		 * the specification should operate on a ResultRow.
		 * @inheritDoc
		 */
		public function selectBy(specification : ISpecification) : List 
		{
			return rows.selectBy(specification);	
		}

		
		/**
		 * returns the rows of the resultset, containing ResultRow instances.
		 * @inheritDoc
		 */
		public function toArray() : Array 
		{
			return rows.toArray();
		}

		
		/**
		 * @inheritDoc
		 */
		public function toString() : String 
		{
			var iterator : IIterator = columns.iterator();
			var allColumns : String = '';
			while(iterator.hasNext()) 
			{
				if(allColumns != '') 
				{
					allColumns += ", ";
				}
				allColumns += iterator.next();
			}
			return "ResultSet with columns " + allColumns;
		}

		
		/**
		 * @return true if we are checking the ResultRows for having the same properties as we have columns. This is done when we are adding a ResultRow.
		 */
		public function getCheckRowsForValidity() : Boolean 
		{
			return checkRowsForValidity;
		}

		
		/**
		 * sets if we need to check for a valid ResultRow when we are adding one.
		 * This means it must have the same properties as we have columns.
		 * This will be a performance penalty at creation time, therefore it is set to false by default.
		 * @param checkRowsForValidity a boolean indicating whether this should be checked.
		 */
		public function setCheckRowsForValidity(checkRowsForValidity : Boolean) : void 
		{
			this.checkRowsForValidity = checkRowsForValidity;
		}
	}
}


