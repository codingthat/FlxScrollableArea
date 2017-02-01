package;

import flixel.FlxG;
import flixel.FlxState;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRandom;

import flixel.math.FlxRect;
import ibwwg.FlxScrollableArea;

class DemoState extends FlxState
{
	override public function create():Void
	{
		super.create();

		// make a group of random boxes

		var group:FlxSpriteGroup = cast add(new FlxSpriteGroup());
		var random = new FlxRandom();
		for (i in 0...30) {
			var box = new FlxSprite();
			box.makeGraphic(100, 100, random.color());
			box.setPosition(random.int(0, 99), i * 50);
			group.add(box);
		}
		
		// put the group off-screen
		
		group.setPosition(-500, 0);
		
		// make a scrollbar-enabled camera for it (a FlxScrollableArea)
		
		var boxScroller = new FlxScrollableArea( new FlxRect( 0, 0, FlxG.width, FlxG.height ), group.getHitbox(), ResizeMode.NONE );
		FlxG.cameras.add( boxScroller );
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
