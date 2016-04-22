package ;

import flixel.math.FlxRect;
import flixel.util.FlxColor;
import gimmicky.FlxScrollableArea;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import gimmicky.FlxScrollbar;
import flixel.FlxTest;
import mockatoo.Mockatoo;
using mockatoo.Mockatoo;

/* Because of the way FlxScrollableArea is implemented, making its own two private scrollbars normally,
 * we duplicate each of them because we are only interested in covering draw and update anyway.
 */

class ScrollbarsDraggableTest extends FlxTest implements mockatoo.MockTest
{
	var areaMock = Mockatoo.mock( FlxScrollableArea ); // um...https://github.com/misprintt/mockatoo/issues/56
	//@:mock var areaMock:FlxScrollableArea;
	var instance:FlxScrollbar; 
	var randomInt:Int;
	var squareViewPort:FlxRect;
	var wideContent:FlxRect;
	var tallContent:FlxRect;
	
	@Before
	public function setup():Void
	{
		randomInt = Std.random( 89 ) + 1;
		squareViewPort = new FlxRect( 0, 0, 100, 100 );
		wideContent = new FlxRect( -500, -500, 400, 100 );
		tallContent = new FlxRect( -500, -500, 100, 400 );
		//areaMock = new FlxScrollableArea( squareViewPort, tallContent, ResizeMode.FIT_WIDTH );
		//instance = new FlxScrollbar( 80, 0, 20, 100, FlxScrollbarOrientation.VERTICAL, FlxColor.LIME, areaMock, true );
		destroyable = instance;
		resetGame();
	}
	
	@After
	public function tearDown():Void
	{
		//areaMock = null;
	}
	
	@Test
	public function testExample():Void
	{
		Assert.isTrue(false);
	}
}