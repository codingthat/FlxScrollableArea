# HaxeFlixelScrollableArea

A scrollable area with automatic scrollbars, intended for manual layout enthusiasts (i.e. users of `FlxG.scaleMode = new StageSizeScaleMode()`...this is the only way this has been tested, so far.)  It's possible that a normal scalemode could still be useful for something in the resize mode called DO_NOT.

## How do I use it?

Clone this into your project's source/flixel/addons directory.  (This doesn't seem the right way to do things; I was maybe too ambitious hoping this will make it into flixel-addons, but I'd love to hear The Right Way to Do Things.)

In a state where you want a scrollable area, prepare the content of your scrollable area off-screen somewhere where no other camera will touch it.  Then in your `create()`:

```haxe
	_myScrollableThingie = new FlxScrollableArea( new FlxRect( 0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight ), // full-screen viewport
		new FlxRect( _offscreenX, 0, width_of_my_content, height_of_my_content ) );
	FlxG.cameras.add( _myScrollableThingie );
```

Then in your state's `onResize()`, follow this basic pattern for each scrollable area:

```haxe
	_myScrollableThingie.viewPort = new FlxRect( 0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight ); // must be before .bestMode
	if (_myScrollableThingie.bestMode == FIT_WIDTH) {
		// resize your content so that it will fit the width of your newly resized viewport, minus _myScrollableThingie.verticalScrollbarWidth
	} else { // FIT_HEIGHT
		// resize your content so that it will fit the height of your newly resized viewport
	}
	_myScrollableThingie.content = new FlxRect( _offscreenX, 0, width_of_my_content, height_of_my_content );
```

Voila, you should have sensibly drawn, functional scrollbars.

## Caveat: dev branch only

I've only tested this using the dev branch of HaxeFlixel.  It's broken on stable due to such fundamental changes as `update()`'s signature, but the dev branch is supposed to be the new stable soonish, AFAICT.

(If you need it on stable, it probably wouldn't be a lot of work to port, but it may have, in general, more bugs, since stable has some strange behaviour with StageSizeScaleMode.  Hence the use of dev.)

## Caveat: fullscreen only

I've only tested this fullscreen, but hopefully it won't take many changes to work on smaller areas.

## Caveat: they aren't swipable yet

I'm still figuring out some general Android testing issues before I'll tackle that part, unless you want to.

However, meanwhile you can manually tell the area to scroll by `.set_scroll()`, if you want.