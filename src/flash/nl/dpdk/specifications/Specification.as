package nl.dpdk.specifications {

	/**
	 * @author Rolf
	 * Specification should be subclassed.
	 * In this way, specifications can be enhanced with 'not', 'or' and 'and' behaviour containing multiple specifications
	 * specifications can thus be chained to form an interpreter.
	 * 
	 * 
	 * 
	 * example:
	 * <code>
	 * var s1:ISpecification = new AbstractSpecification();
	 * var s2:ISpecification = new AbstractSpecification();
	 * var s3:ISpecification = (s1.not()).and(s2);
	 * var outcome:Boolean = s3.isSatisfiedBy(anObject);
	 * </code>
	 */
	public class Specification implements ISpecification 
	{
		public function Specification()
		{

		}

		
		/**
		 * !abstract!
		 * should be overriden with a concrete implementation.
		 * @param candidate An object that will be tested if it is satisfied by the conditions in this specification.
		 * @return Boolean true if the candidate is a match for the criteria.
		 */
		public function isSatisfiedBy(candidate : *) : Boolean
		{
			throw new Error(this.toString() + '.isSatisfiedBy() not overriden in a subclass');
		}
		
		
		
		/**
		 * method to chain different specifications with an or clause
		 * @param other	an ISpecification to use in the conditional
		 */
		public final function or(other : ISpecification) : ISpecification
		{
			return new OrSpecification(this, other);
		}

		
		/**
		 * method to chain different specifications with an and clause
		 * @param other	an ISpecification to use in the conditional
		 */		
		public final function and(other : ISpecification) : ISpecification
		{
			return new AndSpecification(this, other);	
		}

		
		/**
		 * method to change the specification with a negated version of the ISpecification
		 */
		public final function not() : ISpecification
		{
			return new NotSpecification(this);	
		}

		
		/**
		 * toString implementation
		 */
		public function toString() : String
		{
			return 'AbstractSpecification';	
		}
	}
}
