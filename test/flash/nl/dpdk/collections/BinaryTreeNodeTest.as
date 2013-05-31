package nl.dpdk.collections {
	import nl.dpdk.collections.iteration.IIterator;	import nl.dpdk.collections.lists.LinkedList;	import nl.dpdk.collections.trees.BinaryTreeNode;	import nl.dpdk.collections.trees.ITreeNode;	import nl.dpdk.collections.trees.ITreeNodeVisitor;	import nl.dpdk.debug.RunTimer;	
	public class BinaryTreeNodeTest extends CollectionTest implements ITreeNodeVisitor {
		private var instance : BinaryTreeNode;
		private	var a : String = "a";
		private	var b : String = "b";
		private	var c : String = "c";
		private	var d : String = "d";
		private	var e : String = "e";
		private	var f : String = "f";
		private	var g : String = "g";
		private	var h : String = "h";
		private	var i : String = "i";
		private	var j : String = "j";
		private	var k : String = "k";
		private	var l : String = "l";
		private	var m : String = "m";
		private	var n : String = "n";
		private	var o : String = "o";
		private	var p : String = "p";
		private	var q : String = "q";
		private	var r : String = "r";
		private	var s : String = "s";
		private	var t : String = "t";
		private	var u : String = "u";
		private	var v : String = "v";
		private	var w : String = "w";
		private	var x : String = "x";
		private	var y : String = "y";
		private	var z : String = "z";
		private	var zz : String = "zz";

		/**
		 * constructor
		 */
		public function BinaryTreeNodeTest(testMethod : String = null) {
			super(testMethod);
		}
		
		public function testAdd():void{
			trace("BinaryTreeNodeTest.testAdd()");
			basicSetup();
			for(var i: int = 0;i<alphabetLength;++i){
				instance.add(i+alphabet.charAt(i));		
			}
			
			//BinaryTreeNode.levelOrder(instance, this);
			var visitor : Visitor = new Visitor();
			BinaryTreeNode.levelOrder(instance, visitor);
			trace("after adding and processing in level order: " + visitor.getResult().toString());
		}

		
		/**
		 * this method sets up all stuff we need before we run the test
		 */
		protected override function setUp() : void {
			instance = new BinaryTreeNode(null);
		}

		
		/**
		 *	use to remove all stuff not needed after this test
		 */
		protected override function tearDown() : void {
			instance = null;
		}

		
		/**
		 *	a test implementation
		 */
		public function testInstantiated() : void {
			assertTrue("BinaryTreeNode instantiated", instance is BinaryTreeNode);
		}

		
		public function testData() : void {
			trace("BinaryTreeNodeTest.testData()");

			instance.clear();
			assertNull(instance.getData());
			instance.setData('a');
			assertEquals(instance.getData(), 'a');
			instance.setData(null);
			assertNull(instance.getData());
		}

		
		public function testEmpty() : void {
			trace("BinaryTreeNodeTest.testEmpty()");
			basicSetup();
			assertFalse(instance.isEmpty());	
			assertFalse(instance.getRight().isEmpty());	
			assertTrue(instance.getRight().getRight().getRight().isEmpty());	
			assertFalse(instance.getRight().getRight().getLeft().isEmpty());	
		}

		
		public function testClear() : void {
			trace("BinaryTreeNodeTest.testClear()");
			basicSetup();
			assertEquals(instance.getLeft().getData(), 'a');
			assertEquals(instance.getRight().getData(), 'b');
			instance.clear();
			assertNull(instance.getLeft());
			assertNull(instance.getRight());
			assertNull(instance.getData());
			assertNull(instance.getParent());
			
		}

		/**
		 * TODO:
		 * this test passes on my pc, but fails on my mac: a stack overflow occurs...
		 */
		public function testOrdering() : void {
			trace("BinaryTreeNodeTest.testOrdering()");	
			
			basicSetup();
			var visitor : Visitor = new Visitor();
			BinaryTreeNode.levelOrder(instance, visitor);
			assertEquals('levelorder order', visitor.getResult().toString(), 'root,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,zz');
			
			visitor = new Visitor();
			BinaryTreeNode.preOrder(instance, visitor);
			assertEquals('preorder order', visitor.getResult().toString(), 'root,a,c,g,o,p,h,q,r,d,i,s,t,j,u,v,b,e,k,w,x,l,y,z,f,m,zz,n');
			
			visitor = new Visitor();
			BinaryTreeNode.inOrder(instance, visitor);
			assertEquals('inorder order', visitor.getResult().toString(), 'o,g,p,c,q,h,r,a,s,i,t,d,u,j,v,root,w,k,x,e,y,l,z,b,zz,m,f,n');
			
			
			visitor = new Visitor();
			BinaryTreeNode.postOrder(instance, visitor);
			assertEquals('post order', visitor.getResult().toString(), 'o,p,g,q,r,h,c,s,t,i,u,v,j,d,a,w,x,k,y,z,l,e,zz,m,n,f,b,root');
			
			var test : BinaryTreeNode; 
			var next : BinaryTreeNode;
			//apparently, the mac has a stack overflow somewhere between 2500-3000. windows pc easily does 5000
			//FIXED, this was due to creating a left leaning tree by using next.setLeft(fill);next = next.getLeft();
			var numNodes : int = 10000;
			
			var fill:String = 'a';


			test = new BinaryTreeNode(0);
			next = test;
			RunTimer.start();
			for(i = 0;i < numNodes; ++i) {
				test.add(fill);
			}
			//trace('test size: ' + test.size());
			visitor = new Visitor();
			BinaryTreeNode.postOrder(test, visitor);
			RunTimer.traceRunTime('recursive postorder', true);

			test = new BinaryTreeNode(0);
			var i : int;
			next = test;
			RunTimer.start();
			for(i = 0;i < numNodes; ++i) {
				test.add(fill);
		
			}
			
			//trace('test size: ' + test.size());
		
			visitor = new Visitor();
			BinaryTreeNode.preOrder(test, visitor);
			RunTimer.traceRunTime('recursive preorder', true);
			
	

			
			test = new BinaryTreeNode(0);
			next = test;
			RunTimer.start();
			for(i = 0;i < numNodes; ++i) {
				test.add(fill);
			}
			//trace('test size: ' + test.size());
			visitor = new Visitor();
			BinaryTreeNode.inOrder(test, visitor);
			RunTimer.traceRunTime('recursive inOrder', true);
		}

		
		/**
		 * contains is also tested in testRemove()
		 */
		public function testContains() : void {
			trace("BinaryTreeNodeTest.testContains()");
			basicSetup();
			assertTrue(instance.contains('a'));	
			assertTrue(instance.contains('a'));	
			assertTrue(instance.contains('b'));	
			assertFalse('does not contain bogus', instance.contains('asdf'));	
			assertTrue(instance.contains('root'));	
			assertTrue(instance.contains('zz'));	
			assertTrue(instance.contains('z'));	
			assertFalse('does not contain bogus', instance.contains('asdf'));	
		}

		
		public function testChildrenAndSiblings() : void {
			trace("BinaryTreeNodeTest.testChildrenAndSiblings()");
			basicSetup();	
			assertEquals(instance.getChildren().size(), 2);
			assertEquals(instance.getSiblings().size(), 0);
			assertEquals(instance.getChildren().get(0).getData(), a);			
			assertEquals(instance.getChildren().get(1).getData(), b);	
			assertEquals(instance.getSiblings().get(0), null);		
			assertEquals(instance.getLeft().getChildren().size(), 2);
			assertEquals(instance.getLeft().getSiblings().size(), 1);
			assertEquals(instance.getLeft().getChildren().get(0).getData(), c);			
			assertEquals(instance.getLeft().getChildren().get(1).getData(), d);	
			assertEquals(instance.getLeft().getSiblings().get(0).getData(), b);	
			
			
			
			var hey: BinaryTreeNode = instance.getRight().getRight().getLeft().getLeft();
			

			assertEquals("zz's children", hey.getChildren().size(), 0);
			assertEquals(hey.getSiblings().size(), 0);
			assertEquals(hey.getChildren().get(0), null);			
			assertEquals(hey.getChildren().get(1), null);	
			assertEquals(hey.getSiblings().get(0), null);	
			
			
			/**
			 * tests with right node only
			 */
			var aa : BinaryTreeNode = new BinaryTreeNode('aa');
			var bb :String = 'bb';
			
			aa.setRight(bb);
			assertEquals("aa's children", aa.getChildren().size(), 1);
			assertEquals(aa.getSiblings().size(), 0);
			assertEquals(aa.getChildren().get(0).getData(), bb);			
			assertEquals(aa.getChildren().get(1), null);	
			assertEquals(aa.getSiblings().get(0), null);	
		}

		
		public function testRemove() : void {
			trace("BinaryTreeNodeTest.testRemove()");
			basicSetup();
			assertTrue(instance.remove('m'));
			assertFalse(instance.contains('zz'));
			assertFalse(instance.contains('m'));
			assertTrue(instance.contains("b"));
			assertTrue(instance.contains("f"));
			assertTrue(instance.contains("n"));
			assertTrue(instance.contains("z"));
			assertTrue(instance.contains("o"));
			assertTrue(instance.contains("d"));
			assertTrue(instance.contains("u"));
			assertNull(instance.getRight().getRight().getLeft());
			assertEquals(instance.getRight().getRight().getRight().getData(), n);
			assertFalse(instance.remove('m'));
			
			assertTrue(instance.remove('d'));
			assertFalse(instance.remove('d'));
			assertFalse(instance.contains('zz'));
			assertFalse(instance.contains('m'));
			assertTrue(instance.contains("b"));
			assertTrue(instance.contains("f"));
			assertTrue(instance.contains("n"));
			assertTrue(instance.contains("z"));
			assertTrue(instance.contains("o"));
			assertFalse(instance.contains('d'));
			assertFalse(instance.contains('i'));
			assertFalse(instance.contains('v'));
			
			assertNull(instance.getLeft().getRight());
			assertEquals(instance.getLeft().getData(), a);
			
			assertTrue(instance.remove('root'));
			assertFalse(instance.contains('root'));
			assertFalse(instance.contains('a'));
			assertFalse(instance.contains('b'));
			assertFalse(instance.contains('zz'));
			
			assertFalse(instance.remove('zz'));
			assertFalse(instance.remove('root'));
			assertFalse(instance.remove('b'));
			assertFalse(instance.remove('a'));
			assertFalse(instance.remove('z'));
			assertFalse(instance.remove('n'));
			assertFalse(instance.remove('q'));
			assertFalse(instance.remove('asdfasdf'));
		}

		
		public function testSetNodes() : void {
			trace("BinaryTreeNodeTest.testSetNodes()");	
			instance.clear();
		
			instance.setLeft(a);	
			instance.setRight(b);	
			instance.getRight().setRight(d);
			instance.getRight().setLeft(c);
			assertEquals("left is a", instance.getLeft().getData(), a);
			assertEquals("right is b", instance.getRight().getData(), b);
			assertEquals("b.right is d", instance.getRight().getRight().getData(), d);
			assertEquals("b.left is c", instance.getRight().getLeft().getData(), c);
			instance.getRight().setLeft(null);
			assertNull("b.left is null", instance.getRight().getLeft());
		}

		
		public function testRootRelated() : void {
			trace("BinaryTreeNodeTest.testRootRelated()");
			basicSetup();
			assertFalse('no root ', instance.getLeft().isRoot());
			assertFalse('no root ', instance.getRight().isRoot());
			assertFalse('no root ', instance.getLeft().getLeft().isRoot());
			assertFalse('no root ', instance.getLeft().getRight().isRoot());
			assertFalse('no root ', instance.getRight().getLeft().isRoot());
			assertFalse('no root ', instance.getLeft().getLeft().isRoot());
			assertTrue(' root ', instance.isRoot());
			assertEquals('intance is root of f', instance.getLeft().getLeft().getRoot(), instance);	
			assertEquals('intance is root of a', instance.getLeft().getRoot(), instance);	
			assertEquals('intance is root of instance', instance.getRoot(), instance);
		}

		
		public function testIterator() : void {
			trace("BinaryTreeNodeTest.testIterator()");
			basicSetup();
			var iterator : IIterator = instance.iterator();
			var array : Array = new Array();
			
			
			while(iterator.hasNext()) {
				array.push(iterator.next());		
			}
			assertEquals(array.toString(), 'root,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,zz');
			
			var aa : BinaryTreeNode = new BinaryTreeNode('aa');
			var bb : String = 'bb';
			var cc : String = 'cc';
			aa.setRight('bb');
			aa.getRight().setLeft('cc')
			
				
			
			iterator = aa.iterator();
			array = new Array();
			while(iterator.hasNext()) {
				array.push(iterator.next());		
			}
			assertEquals(array.toString(), 'aa,bb,cc');
			
			var list : LinkedList = new LinkedList(instance);
			assertEquals("converting binarytree collection to list", list.toArray().toString(), 'root,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,zz');
			
			
			
			
				
			iterator = instance.getRight().getLeft().iterator();
			array = new Array();
			while(iterator.hasNext()) {
				array.push(iterator.next());		
			}
			assertEquals(array.toString(), 'e,k,l,w,x,y,z');
		}

		
		public function testLeftRight() : void {
			trace("BinaryTreeNodeTest.testLeftRight()");
			basicSetup();
			assertEquals(instance.getLeft().getData(), a);	
			assertEquals(instance.getRight().getData(), b);	
			assertEquals(instance.getRight().getRight().getData(), f);	
		}
		
		public function testConstructor():void{
			trace("BinaryTreeNodeTest.testConstructor()");
			instance = new BinaryTreeNode(b, new BinaryTreeNode(a));
			assertEquals(instance.getParent().getData(), 'a');
			assertEquals(instance.getData(), 'b');
			assertEquals(instance.isLeft(), true);	
			assertEquals(BinaryTreeNode(instance.getParent()).getLeft(), instance);
			assertEquals(BinaryTreeNode(instance.getParent()).getRight(), null);
		}

		
		public function testSizeLevelHeightChildrenSiblings() : void {
			trace("BinaryTreeNodeTest.testSizeCountLevelAndHeight()");
			
			/**
			 * test empty 
			 */
			instance.clear();
			assertEquals('empty tree size 1', instance.size(), 1);
			assertEquals('empty tree height 1', instance.getHeight(), 1);
			assertEquals('empty tree level 0', instance.getLevel(), 0);
			assertEquals('empty tree children 0', instance.getChildCount(), 0);
			assertEquals('empty tree siblings 0', instance.getSiblingCount(), 0);
			
			
			/**
			 * test basic setup
			 */
			basicSetup();
			assertEquals('basic tree size', instance.size(), 28);
			assertEquals('basic tree height', instance.getHeight(), 5);
			assertEquals('basic tree level', instance.getLevel(), 0);
			assertEquals('basic tree children', instance.getChildCount(), 2);
			assertEquals('basic tree siblings', instance.getSiblingCount(), 0);
			
			assertEquals('basic d size', instance.getLeft().getRight().size(), 7);
			assertEquals('basic d height', instance.getLeft().getRight().getHeight(), 3);
			assertEquals('basic d level', instance.getLeft().getRight().getLevel(), 2);
			assertEquals('basic d children', instance.getLeft().getRight().getChildCount(), 2);
			assertEquals('basic d siblings', instance.getLeft().getRight().getSiblingCount(), 1);
			
			var zezz: BinaryTreeNode = instance.getRight().getRight().getLeft().getLeft();
			assertEquals('basic zz size', zezz.size(), 1);
			assertEquals('basic zz height', zezz.getHeight(), 1);
			assertEquals('basic zz level', zezz.getLevel(), 4);
			assertEquals('basic zz children', zezz.getChildCount(), 0);
			assertEquals('basic zz siblings', zezz.getSiblingCount(), 0);
			
			
			/**
			 * test all non root stuff
			 */
			 var fez: BinaryTreeNode = instance.getRight().getRight();
			 var bez: BinaryTreeNode = instance.getRight();
			 var mez: BinaryTreeNode = instance.getRight().getRight().getLeft();
			 var zzez: BinaryTreeNode = instance.getRight().getRight().getLeft().getLeft();
			 var zez: BinaryTreeNode = instance.getRight().getLeft().getRight().getRight();
			 
			assertEquals('f  children', fez.getChildCount(), 2);
			assertEquals('b children', bez.getChildCount(), 2);
			assertEquals('m children', mez.getChildCount(), 1);
			assertEquals('zz children', zzez.getChildCount(), 0);
			assertEquals('z children', zez.getChildCount(), 0);
			
			assertEquals('f  sibling', fez.getSiblingCount(), 1);
			assertEquals('b sibling', bez.getSiblingCount(), 1);
			assertEquals('m sibling', mez.getSiblingCount(), 1);
			assertEquals('zz sibling', zzez.getSiblingCount(), 0);
			assertEquals('z sibling', zez.getSiblingCount(), 1);
		}

		
		/**
		 * simple setup for a complete binary tree with alpabet in level order plus a 'root' and 'zz' node. root is 'root' and the final is 'zz'
		 */
		private function basicSetup() : void {
			instance = new BinaryTreeNode();
			instance.setData("root");

			
			
			
			instance.setLeft(a);	
			instance.setRight(b);
			instance.getLeft().setLeft(c);	
			instance.getLeft().setRight(d);	

			instance.getRight().setLeft(e);
			instance.getRight().setRight(f);
			
			instance.getLeft().getLeft().setLeft(g);
			instance.getLeft().getLeft().setRight(h);
			
			
			
			instance.getLeft().getRight().setLeft(i);
			instance.getLeft().getRight().setRight(j);
			
			
			instance.getRight().getLeft().setLeft(k);
			instance.getRight().getLeft().setRight(l);
			
			
			instance.getRight().getRight().setLeft(m);
			instance.getRight().getRight().setRight(n);
			
			
			instance.getLeft().getLeft().getLeft().setLeft(o);
			instance.getLeft().getLeft().getLeft().setRight(p);
			
			
			instance.getLeft().getLeft().getRight().setLeft(q);
			instance.getLeft().getLeft().getRight().setRight(r);
			
			
			instance.getLeft().getRight().getLeft().setLeft(s);
			instance.getLeft().getRight().getLeft().setRight(t);
			
			
			instance.getLeft().getRight().getRight().setLeft(u);
			instance.getLeft().getRight().getRight().setRight(v);
			
			
			instance.getRight().getLeft().getLeft().setLeft(w);
			instance.getRight().getLeft().getLeft().setRight(x);
			
			
			instance.getRight().getLeft().getRight().setLeft(y);
			instance.getRight().getLeft().getRight().setRight(z);
			
			instance.getRight().getRight().getLeft().setLeft(zz);
		}
		
		
		/**
		 * we also implement the interface IBinaryTreeNodeVisitor, so we can do some stuff here
		 */
		public function visit(node : ITreeNode) : void {
			trace("BinaryTreeNodeTest.visit("+node.getData()+")");
			//trace(node.getData());
		}
	}
}




