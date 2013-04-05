package nl.dpdk.utils 
{
	/**
	 * @author Thomas Brekelmans
	 */
	public class NumberUtils 
	{
		/**
		 * Creates a random number within a given range.
		 */
		public static function getRandomNumberInRange(startRange:Number, endRange:Number):Number 
		{
			var rangeSize:Number = endRange - startRange;
			return startRange + (rangeSize - Math.random() * rangeSize);
		}
		
		/**
		 * Returns a random boolean value.
		 * @param chanceOfReturningTrue	Determines the chance of returning true (valid range is a Number between 0 and 1).
		 */
		public static function getRandomBoolean(chanceOfReturningTrue:Number = 0.5):Boolean 
		{
			return (Math.random() < chanceOfReturningTrue);
		}

		/**
		 * Returns either 1 or -1 randomly.
		 * @param chanceOfReturningOne	Determines the change or returning 1 (valid range is a Number between 0 and 1).		
		 */
		public static function getRandomSign(chanceOfReturningOne:Number = 0.5):int 
		{
			return (Math.random() < chanceOfReturningOne) ? 1 : -1;
		}

		/**
		 * Returns either 1 or 0 randomly.
		 * @param chanceOfReturningOne	Determines the change or returning 1 (valid range is a Number between 0 and 1).		
		 */
		public static function getRandomBit(chanceOfReturningOne:Number = 0.5):int 
		{
			return (Math.random() < chanceOfReturningOne) ? 1 : 0;
		}

		/**
		 * Rounds a floating point number to a given precision. Precision can be any positive number, eg. 0.1 for flooring to 1 decimal numbers, 1 for flooring to whole number or 10 for flooring to tens of numbers.
		 */
		public static function roundFloat(value:Number, precision:Number):Number 
		{
			if (precision < 0) 
			{
				precision = Math.abs(precision);
			}
			return Math.round(value / precision) * precision;
		}
		
		/**
		 * Floor a floating point number to a given precision. Precision can be any positive number, eg. 0.1 for flooring to 1 decimal numbers, 1 for flooring to whole number or 10 for flooring to tens of numbers.
		 */
		public static function floorFloat(value:Number, precision:Number):Number 
		{
			if (precision < 0) 
			{
				precision = Math.abs(precision);
			}
			return Math.floor(value / precision) * precision;
		}

		/**
		 * Finds the x value of a point on a sine curve of which only the y value is known. The closest x value is returned, ranging between -1 pi and 1 pi.
		 */
		public static function xPosOnSinus(yPosOnCurve:Number,
											curveBottom:Number,
											curveTop:Number):Number 
		{
			return Math.asin(2 * NumberUtils.getNormalizedValue(yPosOnCurve, curveBottom, curveTop) - 1);
		}

		/**
		 * Finds the relative position of a number in a range between min and max, and returns its normalized value between 0 and 1.
		 */
		public static function getNormalizedValue(value:Number, min:Number, max:Number):Number 
		{
			var difference:Number = max - min;
			
			if (difference == 0) 
			{
				return min;
			}
			
			var normalizeFactor:Number = 1 / difference;
			return normalizeFactor * (value - min);
		}

		/**
		 * Calculates the value of a continuum between start and end given a percentage position.
		 */
		public static function getPercentageValue(percentage:Number, min:Number, max:Number):Number 
		{
			return min + (percentage * (max - min));
		}

		/**
		 * Calculates the angle of a vector in degrees (if radians are desired, pass false as an optional third parameter).
		 */
		public static function getAngle(deltaX:Number, deltaY:Number, useDegrees:Boolean = true):Number 
		{
			var result:Number = Math.atan2(deltaX, deltaY);
			if (useDegrees)
			{
				result = NumberUtils.toDegrees(result);
			}
			return result;
		}

		/**
		 * Converts a value in radians to degrees.
		 */
		public static function toDegrees(value:Number):Number
		{
			return value * 180 / Math.PI;	
		}

		/**
		 * Converts a value in degrees to radians.
		 */
		public static function toRadians(value:Number):Number
		{
			return value * Math.PI / 180;	
		}
	}
}
