package ;

import flixel.FlxG;
import flixel.input.FlxInput.FlxInputState;
import flixel.math.FlxRect;
import flixel.system.replay.MouseRecord;
import flixel.util.FlxColor;
import gimmicky.FlxScrollbar;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import gimmicky.FlxScrollableArea;
import openfl.gl.GL;
import openfl.utils.UInt8Array;
import flixel.FlxTest;

class OffScrollbarClickTest extends FlxTest
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
		wideContent = new FlxRect( -500, -500, 200, 100 );
		tallContent = new FlxRect( -500, -500, 100, 200 );
		destroyable = instance;
		resetGame();
	}
	
	@:access(gimmicky.FlxScrollableArea)
	@:access(flixel.input.mouse)
	@Test
	public function testHorizOffScrollbarClick():Void
	{
		instance = new FlxScrollableArea( squareViewPort, wideContent, ResizeMode.FIT_HEIGHT );
		Assert.areNotEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( ResizeMode.FIT_HEIGHT, instance.bestMode );
		Assert.areEqual( instance.scroll.x, instance.content.x );
		FlxG.mouse.playback(new MouseRecord(Std.int(instance.viewPort.width * 0.75), Std.int(instance.viewPort.height - instance.horizontalScrollbarHeight / 2), FlxInputState.JUST_PRESSED, 0));
		instance._horizontalScrollbar.update(0); // for some reason, calling step() here does not accomplish the same thing
		Assert.areEqual( instance.scroll.x, instance.content.x + instance.content.width / 2 );
	}

	@:access(gimmicky.FlxScrollableArea)
	@:access(flixel.input.mouse)
	@Test
	public function testVertOffScrollbarClick():Void
	{
		instance = new FlxScrollableArea( squareViewPort, tallContent, ResizeMode.FIT_WIDTH );
		Assert.areNotEqual( instance.verticalScrollbarWidth, 0 );
		Assert.areEqual( instance.horizontalScrollbarHeight, 0 );
		Assert.areEqual( ResizeMode.FIT_WIDTH, instance.bestMode );
		Assert.areEqual( instance.scroll.y, instance.content.y );
		FlxG.mouse.playback(new MouseRecord(Std.int(instance.viewPort.width - instance.verticalScrollbarWidth / 2), Std.int(instance.viewPort.height * 0.75), FlxInputState.JUST_PRESSED, 0));
		instance._verticalScrollbar.update(0); // for some reason, calling step() here does not accomplish the same thing
		Assert.areEqual( instance.scroll.y, instance.content.y + instance.content.height / 2 );
	}
	
	@After
	public function testDestroyingScrollableArea():Void
	{
		this.testDestroy();
	}
}