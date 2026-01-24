package flixel.system;

import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

class FlxSplash extends FlxState
{
	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = #if html5 true #else false #end;
		
	var one:FlxSprite;
	var two:FlxSprite;
	var three:FlxSprite;
	var four:FlxSprite;
	
	var five:FlxSprite;
	var bg:FlxSprite;
	var logo:FlxSprite;
	
	var everythingLoaded:Bool = false;
	
	var _times:Array<Float>;
	var _functions:Array<Void->Void>;
	var _curPart:Int = 0;
	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;
	
	var nextState:NextState;
	
	public function new(nextState:NextState)
	{
		super();
		this.nextState = nextState;
	}
	
	override public function create():Void
	{	
		_cachedBgColor = FlxG.cameras.bgColor;
		FlxG.cameras.bgColor = FlxColor.BLACK;

		// This is required for sound and animation to synch up properly
		_cachedTimestep = FlxG.fixedTimestep;
		FlxG.fixedTimestep = false;

		_cachedAutoPause = FlxG.autoPause;
		FlxG.autoPause = false;

		#if FLX_KEYBOARD
		FlxG.keys.enabled = false;
		#end

		_times = [0.041, 0.184, 0.334, 0.495, 0.636, 3];
		//_functions = [drawGreen, drawYellow, drawRed, drawBlue, drawLightBlue, finishDrawing];
		drawTailsDoll();
		
		for (time in _times)
		{
			new FlxTimer().start(time, timerCallback);
		}

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		#if FLX_SOUND_SYSTEM
		if (!muted)
		{
			FlxG.sound.load(Paths.sound("flixel", 'preload')).play();
		}
		#end
	}

	override public function destroy():Void
	{
		_times = null;
		_functions = null;
		super.destroy();
	}
	
	function complete()
	{
		FlxG.switchState(nextState);
	}
	
	function timerCallback(Timer:FlxTimer):Void
	{
		_functions[_curPart]();
		_curPart++;

		if (_curPart == 6 && everythingLoaded)
		{
			// Make the logo a tad bit longer, so our users fully appreciate our hard work :D
			FlxTween.tween(five, {alpha: 0}, 0.5, {ease: FlxEase.quadOut, onComplete: (_)->complete()});
			for (memb in [bg, logo])
			{
				FlxTween.tween(memb, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			}
		}
	}

	function drawTailsDoll()
	{
		_functions =[
			function() // adds the 4 parts of the tails doll
			{
				one = new FlxSprite(0, 100).loadGraphic(Paths.image('preloader/1', 'preload'));
				one.antialiasing = true;
				one.screenCenter(X);
				add(one);
			},
			function()
			{
				two = new FlxSprite(0, 100).loadGraphic(Paths.image('preloader/2', 'preload'));
				two.antialiasing = true;
				two.screenCenter(X);
				add(two);
			},
			function()
			{
				three = new FlxSprite(0, 100).loadGraphic(Paths.image('preloader/3', 'preload'));
				three.antialiasing = true;
				three.screenCenter(X);
				add(three);
			},
			function()
			{
				four = new FlxSprite(0, 100).loadGraphic(Paths.image('preloader/4', 'preload'));
				four.antialiasing = true;
				four.screenCenter(X);
				add(four);
			},
			function() // does the fancy transition for the whole splash screen
			{
				five = new FlxSprite(0, 100).loadGraphic(Paths.image('preloader/5', 'preload'));
				five.antialiasing = true;
				five.screenCenter(X);
				insert(members.indexOf(one), five);
				
				logo = new FlxSprite(0, five.y + five.height + 50).loadGraphic(Paths.image('preloader/logo', 'preload'));
				logo.antialiasing = true;
				logo.screenCenter(X);
				add(logo);
				
				bg = new FlxSprite().loadGraphic(Paths.image('preloader/back', 'preload'));
				bg.antialiasing = true;
				insert(members.indexOf(five), bg);
				
				five.visible = false;
				bg.visible = false;
				logo.visible = false;
				
				FlxG.camera.flash(FlxColor.WHITE, 1);
				
				for (memb in [one, two, three, four])
				{
					memb.destroy();
				}
				five.visible = true;
				bg.visible = true;
				logo.visible = true;
			},
			function() // safety precaution, to make sure it doesnt crash
			{
				everythingLoaded = true;
			}
		];
	}

	override function startOutro(onOutroComplete:() -> Void)
	{
		FlxG.cameras.bgColor = _cachedBgColor;
		FlxG.fixedTimestep = _cachedTimestep;
		FlxG.autoPause = _cachedAutoPause;
		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end
		
		super.startOutro(onOutroComplete);
	}
}
