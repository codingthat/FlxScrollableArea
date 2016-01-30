package flixel.addons;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * Simple scrollbar.  Draws itself and also handles dragging.  (It's up to you to use the provided data to update whatever you're scrolling.)
 * @author Gimmicky Apps
 */
class FlxScrollbar extends FlxSpriteGroup
{
	/**
	 * Width or height in pixels of the total content that this scrollbar is relevant to.
	 */
	@:isVar public var contentSize(get, set):Float = 0;
	/**
	 * Amount in pixels of the total content that has been scrolled.
	 */
	@:isVar public var contentScrolled(get, set):Float = 0;
	
	private var _orientation:FlxScrollbarOrientation;
	private var _colour:FlxColor;
	private var _minProportion:Float = 0.1; // smallest barProportion of the track that the bar can be
	private var _track:FlxSprite;
	private var _bar:FlxSprite;
	private var _stale:Bool = true;
	/**
	 * Create a new scrollbar graphic.  You'll have to hide it yourself when needed.
	 * 
	 * @param	X					As with any sprite.
	 * @param	Y					"
	 * @param	Width				"
	 * @param	Height				"
	 * @param	Orientation			Whether it's meant to operate vertically or horizontally.  (This is not assumed from the width/height.)
	 * @param	Colour				The colour of the draggable part of the scrollbar.  The rest of it will be the same colour added to FlxColor.GRAY.
	 * @param	InitiallyVisible	Bool to set .visible to.
	 */
	public function new( X:Float, Y:Float, Width:Float, Height:Float, Orientation:FlxScrollbarOrientation, Colour:FlxColor, ?InitiallyVisible:Bool=false ) 
	{
		super( X, Y );
		_orientation = Orientation;
		_colour = Colour;
		
		_track = new FlxSprite();
		_track.makeGraphic( Std.int( Width ), Std.int( Height ), FlxColor.add( FlxColor.GRAY, _colour ), true );
		add( _track );
		
		_bar = new FlxSprite();
		_bar.makeGraphic( Std.int( Width ), Std.int( Height ), _colour, true );
		add( _bar );
		
		visible = InitiallyVisible;
	}
	override public function draw() {
		if (_stale) {
			var barProportion:Float;
			var scrolledProportion:Float;
			var zeroContent:Bool = (contentSize == 0);
			if (zeroContent)
				contentSize = 1; // avoid div-by-zero below
			if ( _orientation == HORIZONTAL ) {
				barProportion = FlxMath.bound( _track.width / contentSize, _minProportion );
				_bar.makeGraphic( Std.int( _track.width * barProportion ), Std.int( _track.height ), _colour, true );
				if (contentSize == _track.width)
					scrolledProportion = 0;
				else
					scrolledProportion = FlxMath.bound( contentScrolled / ( contentSize - _track.width ), 0, 1 );
				_bar.x = scrolledProportion * (_track.width * (1 - barProportion));
			} else {
				barProportion = FlxMath.bound( _track.height / contentSize, _minProportion );
				_bar.makeGraphic( Std.int( _track.width ), Std.int( _track.height * barProportion ), _colour, true );
				if (contentSize == _track.height)
					scrolledProportion = 0;
				else
					scrolledProportion = FlxMath.bound( contentScrolled / ( contentSize - _track.height ), 0, 1 );
				_bar.y = scrolledProportion * (_track.height * (1 - barProportion));
			}
			if (zeroContent)
				contentSize = 0; // put it back
			_stale = false;
		}
		super.draw();
	}
	
	function get_contentScrolled():Float 
	{
		return contentScrolled;
	}
	
	function set_contentScrolled(value:Float):Float 
	{
		if (contentScrolled != value)
			_stale = true;
		return contentScrolled = value;
	}
	
	function get_contentSize():Float 
	{
		return contentSize;
	}
	
	function set_contentSize(value:Float):Float 
	{
		if (contentSize != value)
			_stale = true;
		return contentSize = value;
	}
	
	/**
	 * Use this instead of setting .width, in order to ensure the scrollbar is redrawn.
	 * @param	value	The new width.
	 * @return			The new width.
	 */
	public function resizeWidth(value:Float):Float 
	{
		if (_track.width != value) {
			_track.makeGraphic( Std.int( value ), Std.int( height ), FlxColor.add( FlxColor.GRAY, _colour ), true );
			_stale = true;
		}
		return value;
	}
	/**
	 * Use this instead of setting .height, in order to ensure the scrollbar is redrawn.
	 * @param	value	The new height.
	 * @return			The new height.
	 */
	public function resizeHeight(value:Float):Float 
	{
		if (_track.height != value) {
			_track.makeGraphic( Std.int( width ), Std.int( value ), FlxColor.add( FlxColor.GRAY, _colour ), true );
			_stale = true;
		}
		return value;
	}	
}
enum FlxScrollbarOrientation {
	VERTICAL;
	HORIZONTAL;
}