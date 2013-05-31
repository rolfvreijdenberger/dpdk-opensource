package nl.dpdk.collections {
	import nl.dpdk.collections.lists.ArrayList;	import nl.dpdk.collections.lists.List;	import nl.dpdk.collections.sorting.Comparators;	import nl.dpdk.collections.sorting.SortTypes;	

	/**
	 * test class for the list abstract data type
	 * for concrete implementations, the setup method is overriden to create the right list type (array or linked)
	 * @author Rolf Vreijdenberger
	 */
	public class ArrayListTest extends ListTest {
		/**
		 * constructor
		 */
		public function ArrayListTest(testMethod : String = null) {
			super(testMethod);
		}

		
		/**
		 * factory method
		 * override for the right list
		 */
		protected override function getConcreteList() : List {
			return new ArrayList();
		}

		
		/**
		 * List
		 */
		public function testListaddAll() : void {
			trace("ListTest.testListaddAll()");		 
			var test : List = getConcreteList();
			instance.clear();
			test.add('d');
			test.add('e');
			test.add('f');
			instance = new ArrayList(test);
			assertEquals("after first addition", instance.toArray().toString(), 'd,e,f');
			
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.add('g');
			instance.add('h');
			instance.add('i');
			assertEquals("after additions first addition", instance.toArray().toString(), 'd,e,f,a,b,c,g,h,i');
			instance.addAll(test);
			//trace(instance.toArray());
			assertEquals("after additions and addAll addition", instance.toArray().toString(), 'd,e,f,a,b,c,g,h,i,d,e,f');
			


			
			
			instance.clear();
			instance.add('a');
			instance.add('b');
			instance.add('c');
			instance.addAll(test);
			assertEquals("addition", instance.toArray().toString(), 'a,b,c,d,e,f');
			
			
			instance.clear();
			instance.addAll(test);
			assertEquals("addition  on empty list", instance.toArray().toString(), 'd,e,f');
		}

		
		/**
		 * List
		 */
		public function testListSort() : void {
			trace("ArrayListTest.testListSort()");

			var func : Function = Comparators.compareStringCaseInsensitive;
			//return;

			doSort(func, SortTypes.BUBBLE, LIST_EMPTY, "bubble sort empty list");		
			doSort(func, SortTypes.BUBBLE, LIST_ONE_ELEMENT, "bubble sort one element");		
			doSort(func, SortTypes.BUBBLE, LIST_ODD, "bubble sort odd");		
			doSort(func, SortTypes.BUBBLE, LIST_EVEN, "bubble sort even");		
			doSort(func, SortTypes.BUBBLE, LIST_ALMOST_SORTED_ELEMENTS, "bubble sort almost sorted");		
			doSort(func, SortTypes.BUBBLE, LIST_SORTED_ELEMENTS, "bubble sort sorted");		
			doSort(func, SortTypes.BUBBLE, LIST_DUPLICATE, "bubble sort duplicate");		
			doSort(func, SortTypes.BUBBLE, LIST_UNSORTED, "bubble sort unsorted");		
			doSort(func, SortTypes.BUBBLE, LIST_LARGE, "bubble sort large");		
			doSort(func, SortTypes.BUBBLE, LIST_LARGE_KEYS, "bubble sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.BUBBLE, LIST_LARGE_SORTED, "bubble sort large sorted");		
			
			doSort(func, SortTypes.SELECTION, LIST_EMPTY, "selection sort empty list");		
			doSort(func, SortTypes.SELECTION, LIST_ONE_ELEMENT, "selection sort one element");		
			doSort(func, SortTypes.SELECTION, LIST_ODD, "selection sort odd");		
			doSort(func, SortTypes.SELECTION, LIST_EVEN, "selection sort even");		
			doSort(func, SortTypes.SELECTION, LIST_ALMOST_SORTED_ELEMENTS, "selection sort almost sorted");		
			doSort(func, SortTypes.SELECTION, LIST_SORTED_ELEMENTS, "selection sort sorted");		
			doSort(func, SortTypes.SELECTION, LIST_DUPLICATE, "selection sort duplicate");		
			doSort(func, SortTypes.SELECTION, LIST_UNSORTED, "selection sort unsorted");		
			doSort(func, SortTypes.SELECTION, LIST_LARGE, "selection sort large");		
			doSort(func, SortTypes.SELECTION, LIST_LARGE_KEYS, "selection sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.SELECTION, LIST_LARGE_SORTED, "selection sort large sorted");		
			
			doSort(func, SortTypes.INSERTION, LIST_EMPTY, "insertion sort empty list");		
			doSort(func, SortTypes.INSERTION, LIST_ONE_ELEMENT, "insertion sort one element");		
			doSort(func, SortTypes.INSERTION, LIST_ODD, "insertion sort odd");		
			doSort(func, SortTypes.INSERTION, LIST_EVEN, "insertion sort even");		
			doSort(func, SortTypes.INSERTION, LIST_ALMOST_SORTED_ELEMENTS, "insertion sort almost sorted");		
			doSort(func, SortTypes.INSERTION, LIST_SORTED_ELEMENTS, "insertion sort sorted");		
			doSort(func, SortTypes.INSERTION, LIST_DUPLICATE, "insertion sort duplicate");		
			doSort(func, SortTypes.INSERTION, LIST_UNSORTED, "insertion sort unsorted");		
			doSort(func, SortTypes.INSERTION, LIST_LARGE, "insertion sort large");		
			doSort(func, SortTypes.INSERTION, LIST_LARGE_KEYS, "insertion sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.INSERTION, LIST_LARGE_SORTED, "insertion sort large sorted");		
						
			doSort(func, SortTypes.BINARY_INSERTION, LIST_EMPTY, "binary insertion sort empty list");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_ONE_ELEMENT, "binary insertion sort one element");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_ODD, "binary insertion sort odd");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_EVEN, "binary insertion sort even");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_ALMOST_SORTED_ELEMENTS, "binary insertion sort almost sorted");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_SORTED_ELEMENTS, "binary insertion sort sorted");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_DUPLICATE, "binary insertion sort duplicate");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_UNSORTED, "binary insertion sort unsorted");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_LARGE, "binary insertion sort large");		
			doSort(func, SortTypes.BINARY_INSERTION, LIST_LARGE_KEYS, "binary insertion sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.BINARY_INSERTION, LIST_LARGE_SORTED, "binary insertion sort large sorted");		
						
			doSort(func, SortTypes.SHELL, LIST_EMPTY, "shell sort empty list");		
			doSort(func, SortTypes.SHELL, LIST_ONE_ELEMENT, "shell sort one element");		
			doSort(func, SortTypes.SHELL, LIST_ODD, "shell sort odd");		
			doSort(func, SortTypes.SHELL, LIST_EVEN, "shell sort even");		
			doSort(func, SortTypes.SHELL, LIST_ALMOST_SORTED_ELEMENTS, "shell sort almost sorted");		
			doSort(func, SortTypes.SHELL, LIST_SORTED_ELEMENTS, "shell sort sorted");		
			doSort(func, SortTypes.SHELL, LIST_DUPLICATE, "shell sort duplicate");		
			doSort(func, SortTypes.SHELL, LIST_UNSORTED, "shell sort unsorted");		
			doSort(func, SortTypes.SHELL, LIST_LARGE, "shell sort large");		
			doSort(func, SortTypes.SHELL, LIST_LARGE_KEYS, "shell sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.SELECTION, LIST_LARGE_SORTED, "shell sort large sorted");		
	
			
			doSort(func, SortTypes.QUICK, LIST_EMPTY, "quick sort empty list");		
			doSort(func, SortTypes.QUICK, LIST_ONE_ELEMENT, "quick sort one element");		
			doSort(func, SortTypes.QUICK, LIST_ODD, "quick sort odd");		
			doSort(func, SortTypes.QUICK, LIST_EVEN, "quick sort even");		
			doSort(func, SortTypes.QUICK, LIST_ALMOST_SORTED_ELEMENTS, "quick sort almost sorted");		
			doSort(func, SortTypes.QUICK, LIST_SORTED_ELEMENTS, "quick sort sorted");		
			doSort(func, SortTypes.QUICK, LIST_DUPLICATE, "quick sort duplicate");		
			doSort(func, SortTypes.QUICK, LIST_UNSORTED, "quick sort unsorted");		
			doSort(func, SortTypes.QUICK, LIST_LARGE, "quick sort large");		
			doSort(func, SortTypes.QUICK, LIST_LARGE_KEYS, "quick sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.SELECTION, LIST_LARGE_SORTED, "quick sort large sorted");		

			doSort(func, SortTypes.NATIVE, LIST_EMPTY, "native sort empty list");		
			doSort(func, SortTypes.NATIVE, LIST_ONE_ELEMENT, "native sort one element");		
			doSort(func, SortTypes.NATIVE, LIST_ODD, "native sort odd");		
			doSort(func, SortTypes.NATIVE, LIST_EVEN, "native sort even");		
			doSort(func, SortTypes.NATIVE, LIST_ALMOST_SORTED_ELEMENTS, "native sort almost sorted");		
			doSort(func, SortTypes.NATIVE, LIST_SORTED_ELEMENTS, "native sort sorted");		
			doSort(func, SortTypes.NATIVE, LIST_DUPLICATE, "native sort duplicate");		
			doSort(func, SortTypes.NATIVE, LIST_UNSORTED, "native sort unsorted");		
			doSort(func, SortTypes.NATIVE, LIST_LARGE, "native sort large");		
			doSort(func, SortTypes.NATIVE, LIST_LARGE_KEYS, "native sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.NATIVE, LIST_LARGE_SORTED, "native sort large sorted");		
			//	
			doSort(func, SortTypes.MERGE, LIST_EMPTY, "merge sort empty list");		
			doSort(func, SortTypes.MERGE, LIST_ONE_ELEMENT, "merge sort one element");		
			doSort(func, SortTypes.MERGE, LIST_ODD, "merge sort odd");		
			doSort(func, SortTypes.MERGE, LIST_EVEN, "merge sort even");		
			doSort(func, SortTypes.MERGE, LIST_ALMOST_SORTED_ELEMENTS, "merge sort almost sorted");		
			doSort(func, SortTypes.MERGE, LIST_SORTED_ELEMENTS, "merge sort sorted");		
			doSort(func, SortTypes.MERGE, LIST_DUPLICATE, "merge sort duplicate");		
			doSort(func, SortTypes.MERGE, LIST_UNSORTED, "merge sort unsorted");		
			doSort(func, SortTypes.MERGE, LIST_LARGE, "merge sort large");		
			doSort(func, SortTypes.MERGE, LIST_LARGE_KEYS, "merge sort large keys");		
			doSort(Comparators.compareIntegers, SortTypes.SELECTION, LIST_LARGE_SORTED, "merge sort large sorted");		
		}

		
		/**
		 * List
		 */
		public function testConstructor() : void {

			var test : ArrayList = getConcreteList() as ArrayList;
			test.add('a');
			test.add('b');
			test.add('c');
			instance = new ArrayList(test);	
			assertEquals(instance.toArray().toString(), 'a,b,c');
			instance.add('d');
			assertEquals(instance.toArray().toString(), 'a,b,c,d');
		}
	}
}

import nl.dpdk.specifications.Specification;

internal class ObjectIdSpecification extends Specification {
	private var id : int;

	public function ObjectIdSpecification(id : int) {
		this.id = id;
	}

	
	override public function isSatisfiedBy(candidate : *) : Boolean {
		return candidate.id == id;
	}
}

