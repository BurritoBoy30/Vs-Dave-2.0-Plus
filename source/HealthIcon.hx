package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import sys.FileSystem;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	
	var noAa:Array<String> = [
		'dave-angey',
		'bambi-3d',
		'bambi-unfair',
		'bf-pixel',
		'gf-pixel',
		'dave-split-3d',
		'bambi-piss-3d',
		'exbungo',
		'bombu',
		'bombai'
	];
	public var isPlayer:Bool;
	
	var char:String;
	
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{		
		super();
		this.isPlayer = isPlayer;
		createIcon(char);
		scrollFactor.set();
	}
	
	// fuck this
	// this kept me awake until 1:30 am because of this stupid "char" thing
	public function createIcon(char:String)
	{
		if (this.char != char)
		{
			var realChar:String;
			if (!FileSystem.exists(Paths.image('ui/icons/' + char, 'preload')))
			{
				switch (char)
				{
					case 'bf-christmas':
						realChar = 'bf';
					case 'chris-christmas':
						realChar = 'chris';
					case 'gf-christmas' | 'gf-standing' | 'gf-hot' | 'gf-hot-christmas' | 'gf-hot-funny' | 'gf-hot-standing':
						realChar = 'gf';
					case 'psyka-christmas' |  'psyka-standing':
						realChar = 'psyka';
					case 'cyan-christmas':
						realChar = 'cyan';
					case 'dave-annoyed', 'dave-splitathon':
						realChar = 'dave';
					case 'bambi' | 'bambi-splitathon':
						realChar = 'bambi-new';
					default:
						realChar = 'face';
				}
			}
			else
			{
				realChar = char;
			}
			
			loadGraphic(Paths.image('ui/icons/' + realChar, 'preload'), true, 150, 150);
			
			if (noAa.contains(char))
				antialiasing = false;
			else
				antialiasing = FlxG.save.data.antiAliasing;
				
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		offset.set(Std.int(FlxMath.bound(width - 150,0)),Std.int(FlxMath.bound(height - 150,0)));

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
	
	inline public function getChar():String
	{
		return char;
	}
}
