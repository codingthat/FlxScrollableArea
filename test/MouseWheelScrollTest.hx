package ;

import flixel.FlxG;
import flixel.input.FlxInput.FlxInputState;
import flixel.math.FlxRect;
import flixel.system.replay.MouseRecord;
import flixel.util.FlxColor;
import ibwwg.FlxScrollbar;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import ibwwg.FlxScrollableArea;
import openfl.gl.GL;
import openfl.utils.UInt8Array;
import flixel.FlxTest;

class MouseWheelScrollTest extends FlxTest
{
	var instance:FlxScrollableArea;
	var squareViewPort:FlxRect;
	var wideContent:FlxRect;
	var tallContent:FlxRect;
	
	@Before
	public function setup():Void
	{
		squareViewPort = new FlxRect( 0, 0, 100, 100 );
		wideContent = new FlxRect( -500, -500, 200, 100 );
		tallContent = new FlxRect( -500, -500, 100, 200 );
		destroyable = instance;
		resetGame();
	}
	
	@:access(ibwwg.FlxScrollableArea)
	@:access(flixel.input.mouse)
	@Test
	public function testHorizMouseWheelScroll():Void
	{
		instance = new FlxScrollableArea( squareViewPort, wideContent, ResizeMode.FIT_HEIGHT );
		Assert.areNotEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( ResizeMode.FIT_HEIGHT, instance.bestMode );
		Assert.areEqual( instance.scroll.x, instance.content.x );
		FlxG.mouse.playback(new MouseRecord(0, 0, FlxInputState.RELEASED, -1));
		instance._horizontalScrollbar.update(0); // for some reason, calling step() here does not accomplish the same thing
		Assert.isTrue( instance.scroll.x > instance.content.x );
		FlxG.mouse.playback(new MouseRecord(0, 0, FlxInputState.RELEASED, 1));
		instance._horizontalScrollbar.update(0); // for some reason, calling step() here does not accomplish the same thing
		Assert.areEqual( instance.scroll.x, instance.content.x );
	}

	@:access(ibwwg.FlxScrollableArea)
	@:access(flixel.input.mouse)
	@Test
	public function testVertMouseWheelScroll():Void
	{
		instance = new FlxScrollableArea( squareViewPort, tallContent, ResizeMode.FIT_WIDTH );
		Assert.areNotEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( ResizeMode.FIT_WIDTH, instance.bestMode );
		Assert.areEqual( instance.scroll.y, instance.content.y );
		FlxG.mouse.playback(new MouseRecord(0, 0, FlxInputState.RELEASED, -1));
		instance._verticalScrollbar.update(0); // for some reason, calling step() here does not accomplish the same thing
		Assert.isTrue( instance.scroll.y > instance.content.y );
		FlxG.mouse.playback(new MouseRecord(0, 0, FlxInputState.RELEASED, 1));
		instance._verticalScrollbar.update(0); // for some reason, calling step() here does not accomplish the same thing
		Assert.areEqual( instance.scroll.y, instance.content.y );
	}
	
	@After
	public function testDestroyingScrollableArea():Void
	{
		this.testDestroy();
	}
}