# FlxScrollableArea

For users of HaxeFlixel 4.0.0+, a scrollable area with automatic scrollbars, originally created for manual layout enthusiasts (i.e. users of `FlxG.scaleMode = new StageSizeScaleMode()`) to solve [age-old problems when resizing with scrollbars](http://inthebeginningwasthewordgame.blogspot.ch/2016/01/scrollbar-merry-go-round.html), but it works with the default scalemode too.
	
[See here for screenshots.](http://inthebeginningwasthewordgame.blogspot.ch/2016/01/huzzah-scrollbars-drawn.html)

[See here for an animated GIF.](https://twitter.com/wastheWordGame/status/738750646527119360)

This has been tested mostly on desktop targets and only with OpenFL legacy.  OpenFL 3.6.1 + Lime 2.9.1 work, but some older versions should work, too.  Let me know if other combinations work too!

## How do I use it?

Install it:

```dos
haxelib install flxscrollablearea
```

Reference it in your Project.xml:

```xml
<haxelib name="flxscrollablearea" />
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

If you're not using StageSizeScaleMode, you're done!

## StageSizeScaleMode

In your state's `onResize()`, follow this basic pattern for each scrollable area:

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

## Does it support FlxSubState with a paused parent state?

Yes.  Just pass your substate in the constructor so that it doesn't default to `FlxG.state`.  (This is so the scrollbars themselves, which get drawn outside the viewport by being added to the given FlxState, will still work when your parent state's drawing and/or updating is paused.)

# Special note for users of the deprecated "scrollable-area" haxelib

Please note that I phased out the `gimmicky` classpath, so if you're upgrading to 0.1.0 or beyond, you'll need to search and replace `gimmicky.` with `ibwwg.`.

I had trouble deprecating the old publishing name with haxelib, but then discoverd if you use git bisect, the name change will have broken your old builds.  If this is the case for you, first downgrade to pre-rename scrollable-area:

```
haxelib set scrollable-area 0.0.2-alpha
```

Then install and use the new one going forward.  (See "How do I use it?".)

Unfortunately if you used 0.1.1 for a few commits, those will still be broken.  But those before and those after will be good to go, which will hopefully be the majority.  Eventually, I suppose.  :)
