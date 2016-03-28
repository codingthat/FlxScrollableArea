# FlxScrollableArea (haxelib name: scrollable-area)

For users of HaxeFlixel 4.1.0 (or the dev branch), a scrollable area with automatic scrollbars, intended for manual layout enthusiasts (i.e. users of `FlxG.scaleMode = new StageSizeScaleMode()`...this is the only way this has been tested, so far.)  It's possible that a normal scalemode could still be useful for something in the resize mode called NONE.

NEW: it also works on the default scale mode.

## How do I use it?

Install it:

```dos
haxelib install scrollable-area
```

Reference it in your Project.xml:

```xml
<haxelib name="scrollable-area" />
```

In a state where you want a scrollable area, import it:

```haxe
import gimmicky.FlxScrollableArea
```

Now, prepare the content of your scrollable area off-screen somewhere where no other camera will touch it.  Then in your `create()`:

```haxe
	_myScrollableThingie = new FlxScrollableArea( new FlxRect( 0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight ), // full-screen viewport
		new FlxRect( _offscreenX, 0, width_of_my_content, height_of_my_content ) );
	FlxG.cameras.add( _myScrollableThingie );
```

Pro tip: If you use a FlxSpriteGroup for your off-screen content, then in the constructor (and below in onResize), you can just use myOffscreenGroup.getHitbox() instead of making a new FlxRect yourself.

If you're not using StageSizeScaleMode, you're done.  Otherwise, in your state's `onResize()`, follow this basic pattern for each scrollable area:

```haxe
	_myScrollableThingie.viewPort = new FlxRect( 0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight ); // must be before .bestMode
	if (_myScrollableThingie.bestMode == FIT_WIDTH) {
		// resize your content so that it will fit the width of your newly resized viewport, minus _myScrollableThingie.verticalScrollbarWidth
	} else { // FIT_HEIGHT
		// resize your content so that it will fit the height of your newly resized viewport
	}
	_myScrollableThingie.content = new FlxRect( _offscreenX, 0, width_of_my_content, height_of_my_content );
```

Voila, you should have a sensibly drawn, functional vertical scrollbar, only when necessary.