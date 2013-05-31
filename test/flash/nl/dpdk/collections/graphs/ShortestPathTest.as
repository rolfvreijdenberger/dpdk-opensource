package nl.dpdk.collections.graphs 
{
	import nl.dpdk.collections.CollectionTest;
	import nl.dpdk.collections.graphs.utils.ShortestPath;
	import nl.dpdk.collections.iteration.IIterator;
	import nl.dpdk.collections.lists.List;
	import nl.dpdk.debug.RunTimer;
	/**
	 * @author Peter Schmidt
	 */
	public class ShortestPathTest extends CollectionTest 
	{
		private var instance:Graph;
		private var path:ShortestPath;

		
		/**
		 * constructor
		 */
		public function ShortestPathTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		public function reset(directed:Boolean = true):void
		{
			instance = new Graph("test graph", directed);	
		}

		/**
		 * this method sets up all stuff we need before we run the test
		 */
		protected override function setUp():void 
		{
			reset(true);
		}

		/**
		 *	use to remove all stuff not needed after this test
		 */
		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testShortestPathNoWeightNoDirection():void
		{
			reset(false);
			var a:GraphNode = new ShortGraphNode("a");
			var b:GraphNode = new ShortGraphNode("b");
			var c:GraphNode = new ShortGraphNode("c");
			var d:GraphNode = new ShortGraphNode("d");
			var e:GraphNode = new ShortGraphNode("e");
			instance.add(a);
			instance.add(b);
			instance.add(c);
			instance.add(d);
			instance.add(e);
			
			instance.addEdge(a, b);
			instance.addEdge(a, c);
			instance.addEdge(b, c);
			instance.addEdge(b, d);
			instance.addEdge(c, d);
			instance.addEdge(d, e);	
			
			assertTrue('instance is graph', instance is Graph);
			assertEquals('instance has 5 nodes', instance.size(), 5);
			
			path = new ShortestPath(instance, a);
			assertTrue('path to b returns list', path.getShortestPath(b) is List);
			assertEquals('path to b returns list of size 1', path.getShortestPath(b).size(), 1);
			assertTrue('path to breturns list containing node b', path.getShortestPath(b).contains(b));
			
			assertEquals('path to e returns list of size 3', path.getShortestPath(e).size(), 3);
			assertEquals('path to e returns list with right content', path.getShortestPath(e).toArray().toString(), "b,d,e");
			
			assertEquals('path does not contain a new node', path.getShortestPath(new ShortGraphNode("z")).size(), 0);
		}

		public function testShortestPathWeightNoDirection():void
		{
			reset(false);
			var a:GraphNode = new ShortGraphNode("a");
			var b:GraphNode = new ShortGraphNode("b");
			var c:GraphNode = new ShortGraphNode("c");
			var d:GraphNode = new ShortGraphNode("d");
			var e:GraphNode = new ShortGraphNode("e");
			instance.add(a);
			instance.add(b);
			instance.add(c);
			instance.add(d);
			instance.add(e);
			
			instance.addEdge(a, b, 1);
			instance.addEdge(a, c, 2);
			instance.addEdge(b, c, 2);
			instance.addEdge(b, d, 5);
			instance.addEdge(c, d, 2);
			instance.addEdge(d, e, 10);	
			
			path = new ShortestPath(instance, a);
			
			assertEquals('path to e returns list of size 3', path.getShortestPath(e).size(), 3);
			assertEquals('path to e returns list with right content', path.getShortestPath(e).toArray().toString(), "c,d,e");
			assertEquals('path does not contain a new node', path.getShortestPath(new ShortGraphNode("z")).size(), 0);
		}

		/**
		 * These were copied from http://www.unf.edu/~wkloster/foundations/DijkstraApplet/DijkstraApplet.htm - a great java implementation
		 */
		public function testShortestPathWeightNoDirectionLarge():void
		{
			reset(false);
			var tokushima:GraphNode = new ShortGraphNode("Tokushima");
			var naruto:GraphNode = new ShortGraphNode("Naruto");
			var itano:GraphNode = new ShortGraphNode("Itano");
			var ishii:GraphNode = new ShortGraphNode("Ishii");
			var sanagouchi:GraphNode = new ShortGraphNode("Sanagouchi");
			var komatsujima:GraphNode = new ShortGraphNode("Komatsujima");
			var katsuura:GraphNode = new ShortGraphNode("Katsuura");
			var hanoura:GraphNode = new ShortGraphNode("Hanoura");
			var kamojima:GraphNode = new ShortGraphNode("Kamojima");
			var kamiyama:GraphNode = new ShortGraphNode("Kamiyama");
			var hiketa:GraphNode = new ShortGraphNode("Hiketa");
			var donari:GraphNode = new ShortGraphNode("Donari");
			var anan:GraphNode = new ShortGraphNode("Anan");
			var wajiki:GraphNode = new ShortGraphNode("Wajiki");
			var yamakawa:GraphNode = new ShortGraphNode("Yamakawa");
			var tachibana:GraphNode = new ShortGraphNode("Tachibana");
			var kamikatsu:GraphNode = new ShortGraphNode("Kamikatsu");
			var shirotori:GraphNode = new ShortGraphNode("Shirotori");
			var waki:GraphNode = new ShortGraphNode("Waki");
			var hiwasa:GraphNode = new ShortGraphNode("Hiwasa");
			var kamibun:GraphNode = new ShortGraphNode("Kamibun");
			var anabuki:GraphNode = new ShortGraphNode("Anabuki");
			var takamatsu:GraphNode = new ShortGraphNode("Takamatsu");
			var aioi:GraphNode = new ShortGraphNode("Aioi");
			var koyadaira:GraphNode = new ShortGraphNode("Koyadaira");
			var sawatani:GraphNode = new ShortGraphNode("Sawatani");
			var sadamitsu:GraphNode = new ShortGraphNode("Sadamitsu");
			var shionoe:GraphNode = new ShortGraphNode("Shionoe");
			var mima:GraphNode = new ShortGraphNode("Mima");
			var kainan:GraphNode = new ShortGraphNode("Kainan");
			var deai:GraphNode = new ShortGraphNode("Deai");
			var ikeda:GraphNode = new ShortGraphNode("Ikeda");
			var minokoshi:GraphNode = new ShortGraphNode("Minokoshi");
			var kotohira:GraphNode = new ShortGraphNode("Kotohira");
			var sakaide:GraphNode = new ShortGraphNode("Sakaide");
			var kito:GraphNode = new ShortGraphNode("Kito");
			var kawanoe:GraphNode = new ShortGraphNode("Kawanoe");
			var nishilyayama:GraphNode = new ShortGraphNode("Nishilyayama");
			var otoyo:GraphNode = new ShortGraphNode("Otoyo");
			var toyo:GraphNode = new ShortGraphNode("Toyo");
			var higashilyayama:GraphNode = new ShortGraphNode("Hisgashilyayama");
			var zentsuji:GraphNode = new ShortGraphNode("Zentsuji");
			var toyohama:GraphNode = new ShortGraphNode("Toyohama");
			var nangoku:GraphNode = new ShortGraphNode("Nangoku");
			var muroto:GraphNode = new ShortGraphNode("Muroto");
			var nahari:GraphNode = new ShortGraphNode("Nahari");
			var aki:GraphNode = new ShortGraphNode("Aki");
			var kochi:GraphNode = new ShortGraphNode("Kochi");
			instance.add(tokushima);
			instance.add(naruto);
			instance.add(itano);
			instance.add(ishii);
			instance.add(sanagouchi);
			instance.add(komatsujima);
			instance.add(katsuura);
			instance.add(hanoura);
			instance.add(kamojima);
			instance.add(kamiyama);
			instance.add(hiketa);
			instance.add(donari);
			instance.add(anan);
			instance.add(wajiki);
			instance.add(yamakawa);
			instance.add(tachibana);	
			instance.add(kamikatsu);
			instance.add(shirotori);
			instance.add(waki);
			instance.add(hiwasa);		
			instance.add(kamibun);
			instance.add(anabuki);
			instance.add(takamatsu);
			instance.add(aioi);
			instance.add(koyadaira);
			instance.add(sawatani);
			instance.add(sadamitsu);
			instance.add(shionoe);
			instance.add(mima);
			instance.add(kainan);
			instance.add(deai);
			instance.add(ikeda);
			instance.add(minokoshi);
			instance.add(kotohira);
			instance.add(sakaide);
			instance.add(kito);
			instance.add(kawanoe);
			instance.add(nishilyayama);
			instance.add(otoyo);
			instance.add(toyo);
			instance.add(higashilyayama);
			instance.add(zentsuji);
			instance.add(toyohama);
			instance.add(nangoku);
			instance.add(muroto);
			instance.add(nahari);
			instance.add(aki);
			instance.add(kochi);
			instance.addEdge(tokushima, naruto, 12);
			instance.addEdge(tokushima, itano, 15);
			instance.addEdge(tokushima, ishii, 11);
			instance.addEdge(tokushima, sanagouchi, 20);
			instance.addEdge(tokushima, komatsujima, 8);
			instance.addEdge(komatsujima, sanagouchi, 15);
			instance.addEdge(komatsujima, katsuura, 15);
			instance.addEdge(komatsujima, hanoura, 7);
			instance.addEdge(komatsujima, sanagouchi, 15);
			instance.addEdge(ishii, kamojima, 9);
			instance.addEdge(ishii, kamiyama, 20);
			instance.addEdge(naruto, itano, 16);
			instance.addEdge(naruto, hiketa, 18);
			instance.addEdge(itano, hiketa, 11);
			instance.addEdge(itano, donari, 14);
			instance.addEdge(hanoura, anan, 7);
			instance.addEdge(hanoura, wajiki, 24);
			instance.addEdge(wajiki, aioi, 10);
			instance.addEdge(sanagouchi, kamiyama, 10);
			instance.addEdge(kamojima, donari, 5);
			instance.addEdge(kamojima, yamakawa, 13);
			instance.addEdge(anan, tachibana, 5);
			instance.addEdge(katsuura, kamikatsu, 20);
			instance.addEdge(donari, shirotori, 22);
			instance.addEdge(donari, waki, 17);
			instance.addEdge(hiketa, shirotori, 9);
			instance.addEdge(tachibana, wajiki, 20);
			instance.addEdge(tachibana, hiwasa, 21);
			instance.addEdge(kamiyama, kamibun, 9);
			instance.addEdge(yamakawa, kamibun, 20);
			instance.addEdge(yamakawa, anabuki, 8);
			instance.addEdge(shirotori, takamatsu, 35);
			instance.addEdge(kamibun, koyadaira, 16);
			instance.addEdge(kamibun, sawatani, 22);
			instance.addEdge(anabuki, waki, 1);
			instance.addEdge(anabuki, sadamitsu, 12);
			instance.addEdge(anabuki, koyadaira, 25);
			instance.addEdge(waki, shionoe, 20);
			instance.addEdge(waki, mima, 11);
			instance.addEdge(kamikatsu, sawatani, 23);
			instance.addEdge(hiwasa, kainan, 29);
			instance.addEdge(hiwasa, aioi, 14);
			instance.addEdge(aioi, deai, 21);
			instance.addEdge(sadamitsu, mima, 1);
			instance.addEdge(sadamitsu, ikeda, 23);
			instance.addEdge(sadamitsu, minokoshi, 49);
			instance.addEdge(mima, kotohira, 33);
			instance.addEdge(mima, ikeda, 24);
			instance.addEdge(koyadaira, minokoshi, 25);
			instance.addEdge(sawatani, deai, 13);
			instance.addEdge(shionoe, takamatsu, 23);
			instance.addEdge(shionoe, kotohira, 29);
			instance.addEdge(takamatsu, kotohira, 30);
			instance.addEdge(takamatsu, sakaide, 25);
			instance.addEdge(deai, kito, 21);
			instance.addEdge(deai, kainan, 63);
			instance.addEdge(ikeda, kotohira, 29);
			instance.addEdge(ikeda, kawanoe, 27);
			instance.addEdge(ikeda, otoyo, 45);
			instance.addEdge(ikeda, nishilyayama, 30);
			instance.addEdge(kainan, toyo, 17);
			instance.addEdge(minokoshi, higashilyayama, 33);
			instance.addEdge(kotohira, zentsuji, 8);
			instance.addEdge(kotohira, sakaide, 15);
			instance.addEdge(kotohira, toyohama, 22);
			instance.addEdge(kito, nangoku, 74);
			instance.addEdge(toyo, nahari, 42);
			instance.addEdge(toyo, muroto, 32);
			instance.addEdge(zentsuji, sakaide, 9);
			instance.addEdge(zentsuji, toyohama, 24);
			instance.addEdge(kawanoe, toyohama, 13);
			instance.addEdge(nishilyayama, higashilyayama, 10);
			instance.addEdge(higashilyayama, otoyo, 47);
			instance.addEdge(otoyo, nangoku, 32);
			instance.addEdge(muroto, nahari, 29);
			instance.addEdge(nahari, aki, 15);
			instance.addEdge(aki, nangoku, 26);
			instance.addEdge(nangoku, kochi, 9);
			
			RunTimer.start();
			path = new ShortestPath(instance, tokushima);
			RunTimer.traceRunTime("path built for large undirected graph");
			
			assertEquals('path to kochi returns list of size 9', path.getShortestPath(kochi).size(), 9);
			assertEquals('path to kochi returns list with right content', path.getShortestPath(kochi).toArray().toString(), "Ishii,Kamojima,Yamakawa,Anabuki,Sadamitsu,Ikeda,Otoyo,Nangoku,Kochi");
			assertEquals('path to kochi returns a distance of 162', path.getShortestDistance(kochi), 162);
			
			assertEquals('path to kito returns list of size 6', path.getShortestPath(kito).size(), 6);
			assertEquals('path to kito returns list with right content', path.getShortestPath(kito).toArray().toString(), "Komatsujima,Hanoura,Wajiki,Aioi,Deai,Kito");
			assertEquals('path to kito returns a distance of 91', path.getShortestDistance(kito), 91);
			
			assertEquals('path to aki returns list of size 9', path.getShortestPath(aki).size(), 9);
			assertEquals('path to aki returns list with right content', path.getShortestPath(aki).toArray().toString(), "Komatsujima,Hanoura,Anan,Tachibana,Hiwasa,Kainan,Toyo,Nahari,Aki");
			assertEquals('path to aki returns a distance of 151', path.getShortestDistance(aki), 151);
			
			assertEquals('path to minokoshi returns list of size 5', path.getShortestPath(minokoshi).size(), 5);
			assertEquals('path to minokoshi returns list with right content', path.getShortestPath(minokoshi).toArray().toString(), "Sanagouchi,Kamiyama,Kamibun,Koyadaira,Minokoshi");
			assertEquals('path to minokoshi returns a distance of 80', path.getShortestDistance(minokoshi), 80);

			assertEquals('path from tokushima to itself returns empty', path.getShortestPath(tokushima).toArray().toString(), "");
			assertEquals('path from tokushima to itself returns list size 0', path.getShortestPath(tokushima).size(), 0);
			assertEquals('path from tokushima to itself returns a distance of 0', path.getShortestDistance(tokushima), 0);

			assertEquals('path from tokushima to new node returns empty', path.getShortestPath(new GraphNode("z")).toArray().toString(), "");
			assertEquals('path from tokushima to new node returns list size 0', path.getShortestPath(new GraphNode("z")).size(), 0);
			assertEquals('path from tokushima to new node returns a distance of -1', path.getShortestDistance(new GraphNode("z")), -1);
		}

		public function testShortestPathNoWeightDirection():void
		{
			reset(true);
			var a:GraphNode = new ShortGraphNode("a");
			var b:GraphNode = new ShortGraphNode("b");
			var c:GraphNode = new ShortGraphNode("c");
			var d:GraphNode = new ShortGraphNode("d");
			var e:GraphNode = new ShortGraphNode("e");
			instance.add(a);
			instance.add(b);
			instance.add(c);
			instance.add(d);
			instance.add(e);
			
			instance.addEdge(a, c);
			instance.addEdge(b, a);
			instance.addEdge(b, d);
			instance.addEdge(c, b);
			instance.addEdge(e, d);	
			
			path = new ShortestPath(instance, a);
			
			assertEquals('path to d returns list of size 3', path.getShortestPath(d).size(), 3);
			assertEquals('path to d returns list with right content', path.getShortestPath(d).toArray().toString(), "c,b,d");
			assertEquals('path does not contain a new node', path.getShortestPath(new ShortGraphNode("z")).size(), 0);
			assertEquals('path has no path to e', path.getShortestPath(e).size(), 0);
		}

		public function testShortestPathWeightDirection():void
		{
			reset(true);
			var a:GraphNode = new ShortGraphNode("a");
			var b:GraphNode = new ShortGraphNode("b");
			var c:GraphNode = new ShortGraphNode("c");
			var d:GraphNode = new ShortGraphNode("d");
			var e:GraphNode = new ShortGraphNode("e");
			instance.add(a);
			instance.add(b);
			instance.add(c);
			instance.add(d);
			instance.add(e);
			
			instance.addEdge(a, c, 2);
			instance.addEdge(b, a, 1);
			instance.addEdge(b, d, 1);
			instance.addEdge(c, b, 2);
			instance.addEdge(c, d, 5);
			instance.addEdge(e, d, 1);	
			
			path = new ShortestPath(instance, a);
			
			assertEquals('path to d returns list of size 3', path.getShortestPath(d).size(), 3);
			assertEquals('path to d returns list with right content', path.getShortestPath(d).toArray().toString(), "c,b,d");
			assertEquals('path does not contain a new node', path.getShortestPath(new ShortGraphNode("z")).size(), 0);
			assertEquals('path has no path to e', path.getShortestPath(e).size(), 0);
			assertEquals('path to b returns distance of 4', path.getShortestDistance(b), 4);
			assertEquals('path to d returns distance of 5', path.getShortestDistance(d), 5);
			assertEquals('path to e returns distance of -1', path.getShortestDistance(e), -1);
			assertEquals('path from a to itself returns distance of 0', path.getShortestDistance(a), 0);
			assertEquals('path from a to itself returns size of 0', path.getShortestPath(a).size(), 0);
			
			instance.addEdge(c, d, 1);
			
			assertEquals('path to d still returns list of size 3, even after update', path.getShortestPath(d).size(), 3);
			assertEquals('path to d still returns list with right content', path.getShortestPath(d).toArray().toString(), "c,b,d");
			assertEquals('path to d still returns a distance of 5', path.getShortestDistance(d), 5);
			
			path = new ShortestPath(instance, a);
			
			assertEquals('updated path to d now returns list of size 2', path.getShortestPath(d).size(), 2);
			assertEquals('updated path to d still returns list with right content', path.getShortestPath(d).toArray().toString(), "c,d");
			assertEquals('updated path to d now returns distance of 3', path.getShortestDistance(d), 3);
			assertEquals('updated path still does not contain a new node', path.getShortestPath(new ShortGraphNode("z")).size(), 0);
			assertEquals('updated path still has no path to e', path.getShortestPath(e).size(), 0);
		}

		public function testDenseGraph():void
		{
			reset(false);
			
			var nodeAmount:int = 200;
			
			createDenseGraph(nodeAmount);
			
			RunTimer.start();
			path = new ShortestPath(instance, instance.get(0));
			RunTimer.traceRunTime("path built for dense graph of "+ nodeAmount+ " nodes");
		}

		public function testDenseGraphSetup():void
		{
			reset(false);
			
			createDenseGraph(3);
			
			assertEquals('graph has three nodes', instance.size(), 3);
			assertTrue('instance contains 0', instance.contains(0));
			assertTrue('instance contains 1', instance.contains(1));
			assertTrue('instance contains 2', instance.contains(1));
			
			path = new ShortestPath(instance, instance.get(0));
			
			assertEquals('path returns list of size 0 to 0', path.getShortestPath(instance.get(0)).size(), 0);
			assertEquals('path returns list of size 1 to 1', path.getShortestPath(instance.get(1)).size(), 1);
			assertEquals('path returns list of size 1 to 2', path.getShortestPath(instance.get(2)).size(), 1);
			
			reset(false);
			
			createDenseGraph(5);
			
			assertEquals('graph has five nodes', instance.size(), 5);
			assertTrue('instance contains 0', instance.contains(0));
			assertTrue('instance contains 1', instance.contains(1));
			assertTrue('instance contains 2', instance.contains(2));
			assertTrue('instance contains 3', instance.contains(3));
			assertTrue('instance contains 4', instance.contains(4));
			
			path = new ShortestPath(instance, instance.get(0));
			
			assertEquals('path returns list of size 0 to 0', path.getShortestPath(instance.get(0)).size(), 0);
			assertEquals('path returns list of size 1 to 1', path.getShortestPath(instance.get(1)).size(), 1);
			assertEquals('path returns list of size 1 to 2', path.getShortestPath(instance.get(2)).size(), 1);
		}
		
		public function testCircleGraphSetup():void
		{
			reset(false);
			
			createCircleGraph(3);		//triangle
			
			assertEquals('graph has three nodes', instance.size(), 3);
			assertTrue('instance contains 0', instance.contains(0));
			assertTrue('instance contains 1', instance.contains(1));
			assertTrue('instance contains 2', instance.contains(2));
			
			path = new ShortestPath(instance, instance.get(0));
			
			assertEquals('path to 1 is list of size 1', path.getShortestPath(instance.get(1)).size(), 1);
			assertEquals('path to 2 is list of size 1', path.getShortestPath(instance.get(2)).size(), 1);
		}
		
		public function testCircleGraph():void
		{
			reset(false);
			
			var nodeAmount:int = 200;
			
			createCircleGraph(nodeAmount);
			
			assertEquals('graph has 200 nodes', instance.size(), 200);
			assertTrue('instance contains 0', instance.contains(0));
			assertTrue('instance contains 199', instance.contains(199));
			assertFalse('instance does not contain 200', instance.contains(200));
			
			RunTimer.start();
			path = new ShortestPath(instance, instance.get(0));
			RunTimer.traceRunTime("path built for circle graph of "+ nodeAmount + " nodes");
			
			assertEquals('path to 1 is list of size 1', path.getShortestPath(instance.get(1)).size(), 1);
			assertEquals('path to 2 is list of size 2', path.getShortestPath(instance.get(2)).size(), 2);
			assertEquals('path to 99 is list of size 99', path.getShortestPath(instance.get(99)).size(), 99);
			assertEquals('path to 101 is list of size 99', path.getShortestPath(instance.get(101)).size(), 99);
		}

		private function createCircleGraph(nodes:int):void
		{
			var node:ShortGraphNode;
			var prevNode:ShortGraphNode;
			for (var i:int = 0;i < nodes;++i)
			{
				node = new ShortGraphNode(i.toString());
				instance.add(node);
				if(prevNode)
				{
					instance.addEdge(node, prevNode);
				}
				prevNode = node;
			}
			instance.addEdge(instance.get(i-1), instance.get(0));
		}

		private function createDenseGraph(nodes:int):void
		{
			trace("DenseGraph nodes: " + nodes);
			var node:ShortGraphNode;
			var prevNode:ShortGraphNode;
			var counter:int = 0;
			for (var i:int = 0;i < nodes;++i)
			{
				node = new ShortGraphNode(i.toString());
				instance.add(node);
				if(prevNode)
				{
						var iterator:IIterator = prevNode.getAdjacencyList().iterator();
						while (iterator.hasNext())
						{
							instance.addEdge(node, iterator.next());
							++counter;
						}
					instance.addEdge(node, prevNode);
					++counter;
				}
				prevNode = node;
			}
			trace("DenseGraph edges: " + counter);
		}
	}
}

import nl.dpdk.collections.graphs.GraphNode;
internal class ShortGraphNode extends GraphNode
{
	public function ShortGraphNode(data:* = null) 
	{
		super(data);
	}

	override public function toString():String
	{
		return this.getData();
	}
}
