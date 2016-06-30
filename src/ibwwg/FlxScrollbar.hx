package ibwwg;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * Simple scrollbar.  Draws itself and also handles dragging.  (It's up to you to use the provided data to update whatever you're scrolling.)
 * @author In the Beginning was the Word Game
 */
class FlxScrollbar extends FlxSpriteGroup
{
	private var _orientation:FlxScrollbarOrientation;
	private var _colour:FlxColor;
	private var _minProportion:Float = 0.1; // smallest barProportion of the track that the bar can be
	private var _track:FlxSprite; // Sits under the bar, and takes up the whole side.
	private var _bar:FlxSprite;
	private var _stale:Bool = true;
	private var _state:FlxState;
	private var _camera:FlxScrollableArea;
	private var _dragStartedAt:FlxPoint = null; // null signifying that we are not currently dragging, this is the mousedown spot
	private var _dragStartedWhenBarWasAt:Float; // the x or y (depending on orientation) of the bar at drag start (also for whole page movements)
	private var _trackClickCountdown:Float; // timer until you start getting repeated whole-page-movements when holding down the mouse button
	private var _mouseWheelMultiplier:Int;
	/**
	 * Create a new scrollbar graphic.  You'll have to hide it yourself when needed.
	 * 
	 * @param	X						As with any sprite.
	 * @param	Y						"
	 * @param	Width					"
	 * @param	Height					"
	 * @param	Orientation				Whether it's meant to operate vertically or horizontally.  (This is not assumed from the width/height.)
	 * @param	Colour					The colour of the draggable part of the scrollbar.  The rest of it will be the same colour added to FlxColor.GRAY.
	 * @param	Camera					The parent scrollable area to control with this scrollbar.
	 * @param	InitiallyVisible		Bool to set .visible to.
 	 * @param	State					Which state to add the scrollbar(s) to.  If you're in a FlxSubState with its parent paused, pass it in here.
	 * @param	MouseWheelMultiplier	How much to multiply mouse wheel deltas by.  Set to 0 to disable mouse wheeling.  Default 100.
	 */
	public function new( X:Float, Y:Float, Width:Float, Height:Float, Orientation:FlxScrollbarOrientation, Colour:FlxColor, Camera:FlxScrollableArea, ?InitiallyVisible:Bool=false, ?State:FlxState, ?MouseWheelMultiplier:Int=100 ) 
	{
		super( X, Y );

		_state = State;
		if (_state == null)
			_state = FlxG.state;

		_orientation = Orientation;
		_colour = Colour;
		_camera = Camera;
		_mouseWheelMultiplier = MouseWheelMultiplier;
		
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
			if (_orientation == HORIZONTAL) {
				barProportion = FlxMath.bound( _track.width / _camera.content.width, _minProportion );
				_bar.makeGraphic( Std.int( _track.width * barProportion ), Std.int( _track.height ), _colour, true );
				if (_camera.content.width == _track.width)
					scrolledProportion = 0;
				else
					scrolledProportion = FlxMath.bound( ( _camera.scroll.x - _camera.content.x ) / ( _camera.content.width - _track.width ), 0, 1 );
				_bar.x = x + scrolledProportion * (_track.width * (1 - barProportion));
			} else {
				barProportion = FlxMath.bound( _track.height / _camera.content.height, _minProportion );
				_bar.makeGraphic( Std.int( _track.width ), Std.int( _track.height * barProportion ), _colour, true );
				if (_camera.content.height == _track.height)
					scrolledProportion = 0;
				else
					scrolledProportion = FlxMath.bound( ( _camera.scroll.y - _camera.content.y ) / ( _camera.content.height - _track.height ), 0, 1 );
				_bar.y = y + scrolledProportion * (_track.height * (1 - barProportion));
			}
			_stale = false;
		}
		super.draw();
	}
	override public function update(elapsed:Float)
	{
		if (!visible)
			return;
		var mousePosition = FlxG.mouse.getScreenPosition();
		var tryToScrollPage = false;
		if (FlxG.mouse.justPressed) {
			if (_bar.overlapsPoint( mousePosition )) {
				_dragStartedAt = mousePosition;
				if (_orientation == HORIZONTAL) {
					_dragStartedWhenBarWasAt = _bar.x;
				} else {
					_dragStartedWhenBarWasAt = _bar.y;					
				}
			} else if (_track.overlapsPoint( mousePosition )) {
				_trackClickCountdown = 0.5;
				if (_orientation == HORIZONTAL) {
					_dragStartedWhenBarWasAt = _bar.x;
				} else {
					_dragStartedWhenBarWasAt = _bar.y;					
				}
				tryToScrollPage = true;
			}
		} else if (FlxG.mouse.pressed) {
			_trackClickCountdown -= elapsed;
			if (_trackClickCountdown < 0 && !_bar.overlapsPoint(mousePosition) && _track.overlapsPoint(mousePosition))
				tryToScrollPage = true;
		}
		if (_dragStartedAt != null) {
			if (_orientation == HORIZONTAL) {
				if (mousePosition.y < (_camera.y + _camera.height / 2)) // allow 50% of height away before jumping back to original position
					mousePosition.x = _dragStartedAt.x;
				_bar.x = FlxMath.bound( _dragStartedWhenBarWasAt + (mousePosition.x - _dragStartedAt.x), _track.x, _track.x + _track.width - _bar.width );
			} else { // VERTICAL
				if (mousePosition.x < (_camera.x + _camera.width / 2)) // allow 50% of width away before jumping back to original position
					mousePosition.y = _dragStartedAt.y;
				_bar.y = FlxMath.bound( _dragStartedWhenBarWasAt + (mousePosition.y - _dragStartedAt.y), _track.y, _track.y + _track.height - _bar.height );
			}
			updateViewScroll();
		} else if (tryToScrollPage) {
			/**
			* Tries to scroll a whole viewport width/height toward wherever the mousedown on the track is.
			* 
			* "Tries" because (to emulate standard scrollbar behaviour) you only scroll in one direction while holding the mouse button down.
			* 
			* E.g. on a vertical scrollbar, if you click & hold below the bar, it scrolls down, but if, while still holding, you move to above the bar, nothing happens.
			*/
			var whichWayToScroll:Int = 0; // 0: don't; 1: positive along axis; 2: negative along axis
			if (_orientation == HORIZONTAL) {
				if (_bar.x > _dragStartedWhenBarWasAt) { // scrolling right
					if (mousePosition.x > _bar.x + _bar.width) // and far enough right to scroll more
						whichWayToScroll = 1;
				} else if (_bar.x > _dragStartedWhenBarWasAt) { // scrolling left
					if (mousePosition.x < _bar.x) // and far enough left to scroll more
						whichWayToScroll = -1;
				} else { // first scroll...which way?
					if (mousePosition.x < _bar.x) // left of bar
						whichWayToScroll = -1;
					else // either right of bar, or on the bar; but if on the bar, execution shouldn't reach here in the first place
						whichWayToScroll = 1; // start scrolling right
				}
				if (whichWayToScroll == 1)
					_bar.x = FlxMath.bound(_bar.x + _bar.width, null, _track.x + _track.width - _bar.width);
				else if (whichWayToScroll == -1)
					_bar.x = FlxMath.bound(_bar.x - _bar.width, _track.x);
			} else { // VERTICAL
				if (_bar.y > _dragStartedWhenBarWasAt) { // scrolling down
					if (mousePosition.y > _bar.y + _bar.height) // and far enough down to scroll more
						whichWayToScroll = 1;
				} else if (_bar.y > _dragStartedWhenBarWasAt) { // scrolling up
					if (mousePosition.y < _bar.y) // and far enough up to scroll more
						whichWayToScroll = -1;
				} else { // first scroll...which way?
					if (mousePosition.y < _bar.y) // up of bar
						whichWayToScroll = -1;
					else // either down of bar, or on the bar; but if on the bar, execution shouldn't reach here in the first place
						whichWayToScroll = 1; // start scrolling down
				}
				if (whichWayToScroll == 1)
					_bar.y = FlxMath.bound(_bar.y + _bar.height, null, _track.y + _track.height - _bar.height);
				else if (whichWayToScroll == -1)
					_bar.y = FlxMath.bound(_bar.y - _bar.height, _track.y);
			}
			if (whichWayToScroll != 0)
				updateViewScroll();
		} else if (FlxG.mouse.wheel != 0) {
			if (_orientation == HORIZONTAL) {
				_bar.x = FlxMath.bound(_bar.x - FlxG.mouse.wheel * _mouseWheelMultiplier, _track.x, _track.x + _track.width - _bar.width);
			} else { // VERTICAL
				_bar.y = FlxMath.bound(_bar.y - FlxG.mouse.wheel * _mouseWheelMultiplier, _track.y, _track.y + _track.height - _bar.height);
			}
			updateViewScroll();
		}
		if (FlxG.mouse.justReleased)
			_dragStartedAt = null;
		super.update(elapsed);
	}
	/**
	 * Updates the view's scroll.  Should be done from the outside if there's a resize.
	 */
	public function updateViewScroll() {
		var scrolledProportion:Float;
		if (_orientation == HORIZONTAL) {
			if (_track.width == _bar.width)
				scrolledProportion = 0;
			else
				scrolledProportion = FlxMath.bound( (_bar.x - x) / (_track.width - _bar.width), 0, 1 );
			_camera.scroll.x = _camera.content.x + (_camera.content.width - _track.width) * scrolledProportion;
		} else {
			if (_track.height == _bar.height)
				scrolledProportion = 0;
			else
				scrolledProportion = FlxMath.bound( (_bar.y - y) / (_track.height - _bar.height), 0, 1 );
			_camera.scroll.y = _camera.content.y + (_camera.content.height - _track.height) * scrolledProportion;
		}
	}
	override private function set_width(Value:Float):Float {
		if (_track != null && _track.width != Value) {
			_track.makeGraphic( Std.int( Value ), Std.int( height ), FlxColor.add( FlxColor.GRAY, _colour ), true );
			_stale = true;
		}
		return super.set_width(Value);
	}
	override private function set_height(Value:Float):Float 
	{
		if (_track != null && _track.height != Value) {
			_track.makeGraphic( Std.int( width ), Std.int( Value ), FlxColor.add( FlxColor.GRAY, _colour ), true );
			_stale = true;
		}
		return super.set_height(Value);
	}
	override private function set_x(Value:Float):Float 
	{
		if (_track != null && x != Value) {
			_stale = true;
		}
		return super.set_x(Value);
	}
	override private function set_y(Value:Float):Float 
	{
		if (_track != null && y != Value) {
			_stale = true;
		}
		return super.set_y(Value);
	}
	override private function set_visible(value:Bool):Bool {
		if (visible != value) {
			if (visible == false) { // becoming visible: make sure we're on top
				for ( piece in [_track, _bar] ) {
					FlxG.state.remove( piece );
					FlxG.state.add( piece );
				}
			}
			return super.set_visible( value );
		} else
			return value;
	}
}
enum FlxScrollbarOrientation {
	VERTICAL;
	HORIZONTAL;
}