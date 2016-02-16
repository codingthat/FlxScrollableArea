package ;

import flixel.math.FlxRect;
import flixel.util.FlxColor;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import gimmicky.FlxScrollableArea;
import openfl.gl.GL;
import openfl.utils.UInt8Array;
import flixel.FlxTest;

class CorrectScrollbarsShownTest extends FlxTest
{
	var instance:FlxScrollableArea;
	var randomInt:Int;
	var squareViewPort:FlxRect;
	var wideContent:FlxRect;
	var tallContent:FlxRect;
	var squareContent:FlxRect;
	var bigSquareContent:FlxRect;
	var wideContent2:FlxRect;
	var tallContent2:FlxRect;
	var tallContent3:FlxRect;
	var beforeWidth:Int;
	var beforeHeight:Int;
	
	@Before
	public function setup():Void
	{
		squareViewPort = new FlxRect( 0, 0, 100, 100 );
		wideContent = new FlxRect( -500, -500, 400, 100 );
		tallContent = new FlxRect( -500, -500, 100, 400 );
		squareContent = new FlxRect( -500, -500, 100, 100 );
		bigSquareContent = new FlxRect( -500, -500, 200, 200 );
		wideContent2 = new FlxRect( -500, -500, 110, 100 );
		tallContent2 = new FlxRect( -500, -500, 100, 110 );
		destroyable = instance;
		resetGame();
	}
	
	@Test
	public function testHorizScrollWhenTooWide():Void
	{
		instance = new FlxScrollableArea( squareViewPort, wideContent, ResizeMode.FIT_HEIGHT );
		Assert.areNotEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( ResizeMode.FIT_HEIGHT, instance.bestMode );
	}
	
	@Test
	public function testVertScrollWhenTooTall():Void
	{
		instance = new FlxScrollableArea( squareViewPort, tallContent, ResizeMode.FIT_WIDTH );
		Assert.areNotEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( ResizeMode.FIT_WIDTH, instance.bestMode );
	}
	
	@Test
	public function testNoScrollWhenRightSizeFitWidth():Void
	{
		instance = new FlxScrollableArea( squareViewPort, squareContent, ResizeMode.FIT_WIDTH );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
	}
	
	@Test
	public function testNoScrollWhenRightSizeFitHeight():Void
	{
		instance = new FlxScrollableArea( squareViewPort, squareContent, ResizeMode.FIT_HEIGHT );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
	}	

	@Test
	public function testNoScrollWhenRightSizeNone():Void
	{
		instance = new FlxScrollableArea( squareViewPort, squareContent, ResizeMode.NONE );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( ResizeMode.NONE, instance.bestMode );
	}
	
	@Test
	public function testVertScrollWhenTooTallNone():Void
	{
		randomInt = Std.random( 50 ) + 5;
		tallContent3 = new FlxRect( -500, -500, 100 - randomInt, 110 );
		instance = new FlxScrollableArea( squareViewPort, tallContent3, ResizeMode.NONE );
		Assert.areNotEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( ResizeMode.NONE, instance.bestMode );
	}
	
	@Test
	public function testScrollbarThicknessHonoured():Void
	{
		randomInt = Std.random( 89 ) + 1;
		instance = new FlxScrollableArea( squareViewPort, bigSquareContent, ResizeMode.NONE, randomInt );
		Assert.areEqual( randomInt, instance.horizontalScrollbarHeight );
		Assert.areEqual( randomInt, instance.verticalScrollbarWidth );
	}
	
	@Test
	public function testBestModeSwitchWhenTooWide():Void
	{
		randomInt = Std.random( 75 ) + 15;
		instance = new FlxScrollableArea( squareViewPort, wideContent2, ResizeMode.FIT_HEIGHT, randomInt );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( ResizeMode.FIT_WIDTH, instance.bestMode );
	}
	
	@Test
	public function testBestModeSwitchWhenTooTall():Void
	{
		randomInt = Std.random( 75 ) + 15;
		instance = new FlxScrollableArea( squareViewPort, tallContent2, ResizeMode.FIT_WIDTH, randomInt );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( ResizeMode.FIT_HEIGHT, instance.bestMode );
	}
	
	@Test
	public function testToggleVisible():Void
	{
		instance = new FlxScrollableArea( squareViewPort, tallContent, ResizeMode.FIT_WIDTH );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areNotEqual( instance.verticalScrollbarWidth, 0 );
		beforeWidth = instance.width;
		beforeHeight = instance.height;
		Assert.areEqual( true, instance.visible );
		instance.visible = false;
		Assert.areEqual( false, instance.visible );

		// this would resize the area, were it visible
		instance.content = squareContent;
		Assert.areEqual( beforeWidth, instance.width );
		Assert.areEqual( beforeHeight, instance.height );
		
		// even an actual resize should be ignored
		instance.onResize();
		Assert.areEqual( beforeWidth, instance.width );
		Assert.areEqual( beforeHeight, instance.height );

		instance.visible = true;
		Assert.areEqual( true, instance.visible );

		// now that it's visible, its scrollbar should have gone away, causing a width change
		Assert.areNotEqual( beforeWidth, instance.width );
		Assert.areEqual( beforeHeight, instance.height );		
	}
	
	@After
	public function testDestroyingScrollableArea():Void
	{
		this.testDestroy();
	}
}