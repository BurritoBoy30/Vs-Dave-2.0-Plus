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
		'bombai',
		'hell-expunged'
	];
	public var isPlayer:Bool;
	
	var char:String;
	var state:String;
	
	public var whosthisfucker:String = '';
	public var realSize:Float = 1;
	
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{		
		super();
		this.isPlayer = isPlayer;
		createIcon(char);
		whosthisfucker = char;
		scrollFactor.set();
	}
	
	// fuck this
	// this kept me awake until 1:30 am because of this stupid "char" thing
	public function createIcon(char:String)
	{
		if (this.char != char)
		{
			if (char == 'ohungi')
			{
				frames = Paths.getSparrowAtlas('ui/icon_ohungi', 'preload');
				animation.addByPrefix('normal', "NORMAL", 24, true);
				animation.addByPrefix('losing', "LOSE", 24, true);
				animation.play('normal');
				whosthisfucker = 'ohungi';
				realSize = 0.75;
			}
			else
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
						case 'dave-splitathon':
							realChar = 'dave-annoyed';
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
				animation.add(char, [0, 1], 0, false, isPlayer);
				animation.play(char);
				whosthisfucker = char;
			}
			scale.set(realSize,realSize);
			
			if (noAa.contains(char))
				antialiasing = false;
			else
				antialiasing = FlxG.save.data.antiAliasing;		
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (sprTracker != null)
		{
			var ohungiOffset:Array<Float> = [0, 0];
			
			if (whosthisfucker == 'ohungi')
				ohungiOffset = [-40, -50];
				
			setPosition(sprTracker.x + sprTracker.width + 10 + ohungiOffset[0], sprTracker.y - 30 + ohungiOffset[1]);
		}
	}
	
	public function changeState(charState:String)
	{
		switch (charState)
		{
			case 'normal':
				if (whosthisfucker == 'ohungi')
					animation.play('normal');
				else
					animation.curAnim.curFrame = 0;
					
			case 'losing':
				if (whosthisfucker == 'ohungi')
					animation.play('losing');
				else
					animation.curAnim.curFrame = 1;
		}
		state = charState;
	}
	
	public function getState()
	{
		return state;
	}
	
	inline public function getChar():String
	{
		return char;
	}
}
