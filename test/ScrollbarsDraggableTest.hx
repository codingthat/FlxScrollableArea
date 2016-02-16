package ;

import flixel.math.FlxRect;
import gimmicky.FlxScrollableArea;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import gimmicky.FlxScrollbar;
import mockatoo.Mockatoo.*;
using mockatoo.Mockatoo.*;

class ScrollbarsDraggableTest 
{
	var area:FlxScrollableArea; // TODO: mock out
	var instance:FlxScrollbar; 
	var randomInt:Int;
	var squareViewPort:FlxRect;
	var wideContent:FlxRect;
	var tallContent:FlxRect;
	
	@BeforeClass
	public function beforeClass():Void
	{
		area = new FlxScrollableArea( squareViewPort, tallContent, ResizeMode.FIT_WIDTH, randomInt );
	}
	
	@AfterClass
	public function afterClass():Void
	{
		area = null;
	}
	
	@Before
	public function setup():Void
	{
		randomInt = randomInt = Std.random( 89 ) + 1;
		squareViewPort = new FlxRect( 0, 0, 100, 100 );
		wideContent = new FlxRect( -500, -500, 400, 100 );
		tallContent = new FlxRect( -500, -500, 100, 400 );
		// instance = 
		destroyable = instance;
		resetGame();
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function testExample():Void
	{
		Assert.isTrue(false);
	}
}