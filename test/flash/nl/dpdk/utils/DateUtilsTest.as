package nl.dpdk.utils 
{
	import asunit.framework.TestCase;
	/**
	 * @author Szenia Zadvornykh
	 */
	public class DateUtilsTest extends TestCase 
	{
		public function DateUtilsTest(testMethod:String = null)
		{
			super(testMethod);
		}

		public function testDateToUnixTimeStamp():void
		{
			var date:Date = new Date(2010, 4, 18, 10, 36, 12);	//remember, month is zero-based
			assertEquals("date object equals corresponding timestamp #1", DateUtils.dateToUnixTimeStamp(date), "1274171772");
			date = new Date(2010, 11, 31, 23, 53, 20);
			assertEquals("date object equals corresponding timestamp #2", DateUtils.dateToUnixTimeStamp(date), "1293836000");
			assertFalse("does not equal some other timestamp", DateUtils.dateToUnixTimeStamp(new Date()) == "1254172142");
		}

		public function testUnixTimeStampToDate():void
		{
			var date:Date = new Date(2010, 04, 10, 23, 20, 19); 
			assertFalse("timestamp doesn't equal current date/time", DateUtils.unixTimeStampToDate("1273526419") == new Date());
			assertEquals("timestamp does equal corresponding date", DateUtils.unixTimeStampToDate("1273526419").toString(), date.toString());
		}

		public function testTimeStampToDate():void
		{
			assertEquals(DateUtils.timeStampToDate("2010-03-15 22:13:59").toString(), new Date(2010, 02, 15, 22, 13, 59).toString());
		}

		public function testDateToTimeStamp():void
		{
			assertEquals(DateUtils.dateToTimeStamp(new Date(2010, 2, 15, 22, 13, 59)), "2010-03-15 22:13:59");
			assertEquals(DateUtils.dateToTimeStamp(new Date(1999, 11, 31, 23, 59, 59)), "1999-12-31 23:59:59");		//why hello new millenium!
			assertEquals(DateUtils.dateToTimeStamp(new Date(2004, 8, 21, 9, 03, 43)), "2004-09-21 09:03:43");
		}

		public function testPrefixWhenUnderTen():void
		{
			assertEquals(DateUtils.prefixWithZeroWhenUnderTen(25), "25");
			assertEquals(DateUtils.prefixWithZeroWhenUnderTen(9), "09");
			assertEquals(DateUtils.prefixWithZeroWhenUnderTen(Number.NaN), "00");	//NaN becomes 0 when converted to integer
		}

		public function testGetTime():void
		{
			assertEquals(DateUtils.getTime(new Date(2010, 01, 01, 15, 10, 30)), "15:10:30");
			assertEquals(DateUtils.getTime(new Date(2010, 01, 01, 9, 59, 59)), "09:59:59");
			assertEquals(DateUtils.getTime(new Date(2010, 01, 01, 5, 2, 41)), "05:02:41");
		}	
		
		public function testGetDate():void
		{
			assertEquals(DateUtils.getDate(new Date(2010, 01, 01, 15, 10, 30)), "2010-02-01");
			assertEquals(DateUtils.getDate(new Date(2001, 07, 22, 9, 59, 59)), "2001-08-22");
			assertEquals(DateUtils.getDate(new Date(1970, 00, 01, 5, 2, 41)), "1970-01-01");
		}
		
		public function testGetReversedDate():void
		{
			assertEquals(DateUtils.getReversedDate(new Date(2010, 01, 01, 15, 10, 30)), "01-02-2010");
			assertEquals(DateUtils.getReversedDate(new Date(2001, 07, 22, 9, 59, 59)), "22-08-2001");
			assertEquals(DateUtils.getReversedDate(new Date(1970, 00, 01, 5, 2, 41)), "01-01-1970");
		}
		
		public function testMonthFromIndex():void
		{
			assertEquals(DateUtils.getMonthFromIndex(0), "januari");
			assertEquals(DateUtils.getMonthFromIndex(1), "februari");
			assertEquals(DateUtils.getMonthFromIndex(2), "maart");
			assertEquals(DateUtils.getMonthFromIndex(3), "april");
			assertEquals(DateUtils.getMonthFromIndex(4), "mei");
			assertEquals(DateUtils.getMonthFromIndex(5), "juni");
			assertEquals(DateUtils.getMonthFromIndex(6), "juli");
			assertEquals(DateUtils.getMonthFromIndex(7), "augustus");
			assertEquals(DateUtils.getMonthFromIndex(8), "september");
			assertEquals(DateUtils.getMonthFromIndex(9), "oktober");
			assertEquals(DateUtils.getMonthFromIndex(10), "november");
			assertEquals(DateUtils.getMonthFromIndex(11), "december");
		}
		
		public function testIndexFromMonth():void
		{
			assertEquals(DateUtils.getIndexFromMonth("januari"), 0);
			assertEquals(DateUtils.getIndexFromMonth("februari"), 1);
			assertEquals(DateUtils.getIndexFromMonth("maart"), 2);
			assertEquals(DateUtils.getIndexFromMonth("april"), 3);
			assertEquals(DateUtils.getIndexFromMonth("mei"), 4);
			assertEquals(DateUtils.getIndexFromMonth("juni"), 5);
			assertEquals(DateUtils.getIndexFromMonth("juli"), 6);
			assertEquals(DateUtils.getIndexFromMonth("augustus"), 7);
			assertEquals(DateUtils.getIndexFromMonth("september"), 8);
			assertEquals(DateUtils.getIndexFromMonth("oktober"), 9);
			assertEquals(DateUtils.getIndexFromMonth("november"), 10);
			assertEquals(DateUtils.getIndexFromMonth("december"), 11);
		}

		public function testGetDaysInMonthNormalYear():void
		{
			var year:int = 2010;
		
			assertEquals(DateUtils.getDaysInMonth(year, 0), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 1), 28);
			assertEquals(DateUtils.getDaysInMonth(year, 2), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 3), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 4), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 5), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 6), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 7), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 8), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 9), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 10), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 11), 31);
		}

		public function testGetDaysInMonthLeapYear():void
		{
			var year:int = 2004;

			assertEquals(DateUtils.getDaysInMonth(year, 0), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 1), 29);
			assertEquals(DateUtils.getDaysInMonth(year, 2), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 3), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 4), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 5), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 6), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 7), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 8), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 9), 31);
			assertEquals(DateUtils.getDaysInMonth(year, 10), 30);
			assertEquals(DateUtils.getDaysInMonth(year, 11), 31);
		}
	}
}
