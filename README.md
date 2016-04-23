# FlxScrollableArea (haxelib name: scrollable-area)

For users of HaxeFlixel 4.0.0+, a scrollable area with automatic scrollbars, originally created for manual layout enthusiasts (i.e. users of `FlxG.scaleMode = new StageSizeScaleMode()`) to solve [age-old problems when resizing with scrollbars](http://inthebeginningwasthewordgame.blogspot.ch/2016/01/scrollbar-merry-go-round.html), but it works with the default scalemode too.
	
[See here for screenshots.](http://inthebeginningwasthewordgame.blogspot.ch/2016/01/huzzah-scrollbars-drawn.html)

This has been tested mostly on desktop targets and only with OpenFL legacy.  OpenFL 3.6.1 + Lime 2.9.1 work, but some older versions should work, too.

Please note that I am phasing out the `gimmicky` classpath, so if you're upgrading to 0.1.0 or beyond, you'll need to search any replace `gimmicky.` with `ibwwg.`.

## How do I use it?

Install it:

```dos
haxelib install scrollable-area
```

Or the dev version:

```dos
haxelib git scrollable-area https://github.com/IBwWG/FlxScrollableArea
```


Reference it in your Project.xml:

```xml
<haxelib name="scrollable-area" />
```

In a state where you want a scrollable area, import it:

```haxe
import ibwwg.FlxScrollableArea
```

Now, prepare the content of your scrollable area off-screen somewhere where no other camera will reach it.  Then in your state's `create()`:

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