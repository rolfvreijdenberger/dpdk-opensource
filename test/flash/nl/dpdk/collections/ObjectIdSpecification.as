package nl.dpdk.collections {	import nl.dpdk.specifications.Specification;	internal class ObjectIdSpecification extends Specification {		private var id : int;		public function ObjectIdSpecification(id : int) {			this.id = id;		}				override public function isSatisfiedBy(candidate : *) : Boolean {			return candidate.id == id;		}	}}