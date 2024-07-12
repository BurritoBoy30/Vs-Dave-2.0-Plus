package;

import flixel.FlxSprite;
import flixel.math.FlxMath;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	
	var noAa:Array<String> = ['dave-angey', 'bambi-3d', 'bf-pixel', 'gf-pixel'];
	var isReallyPlayer:Bool = false;
	
	var iconList:String = '';
	
	var repeatingIcons:Array<Dynamic> = [
		['bf', 'bf-christmas'],
		['gf', 'gf-christmas', 'gf-standing', 'gf-player'],
		['psyka', 'psyka-christmas', 'psyka-standing'],
		['cyan', 'cyan-christmas'],
		['dave', 'dave-annoyed', 'dave-splitathon'],
		['bambi', 'bambi-splitathon', 'bambi-new'],
		['bambi-stupid', 'bambi-old']
	];

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		
		isReallyPlayer = isPlayer;
		
		// bf
		addRepeatingIcon(repeatingIcons[0], [0, 1]);
		
		addIcon('bf-old', [2, 3]);
		addIcon('bf-pixel', [4, 5]);
		addIcon('bf-with-gf', [6, 7]);
		addIcon('rapper-gf', [8, 9]);
		addIcon('face', [10, 11]);
		
		// gf
		addRepeatingIcon(repeatingIcons[1], [12, 13]);
		
		addIcon('gf-pixel', [14, 15]);
		
		// psyka
		addRepeatingIcon(repeatingIcons[2], [16, 17]);
		
		// cyan
		addRepeatingIcon(repeatingIcons[3], [18, 19]);
		
		addIcon('gf-massive', [20, 21]);
		addIcon('skyblue', [22, 23]);
		
		// dave
		addRepeatingIcon(repeatingIcons[4], [24, 25]);
		
		addIcon('dave-angey', [26, 27]);
		
		// bambi
		addRepeatingIcon(repeatingIcons[5], [28, 29]);
		
		addIcon('tristan', [30, 31]);
		addIcon('the-duo', [32, 33]);
		
		// bambi-old
		addRepeatingIcon(repeatingIcons[6], [34, 35]);
		
		addIcon('bambi-3d', [36, 37]);
		addIcon('tristan-golden', [38, 39]);
		addIcon('bambi-angey', [40, 41]);
		addIcon('dave-alpha', [42, 43]);
		addIcon('bf-with-cyan', [44, 45]);
		
		playAnimation(char);
		scrollFactor.set();
		
		//trace(iconList);
	}
	
	function addIcon(target:String, phases:Array<Int>)
	{
		animation.add(target, phases, 0, false, isReallyPlayer);
		iconList += target;
	}
	
	function addRepeatingIcon(target:Array<String>, phases:Array<Int>)
	{
		for (i in 0...target.length)
		{
			addIcon(target[i], phases);
		}
	}
	
	public function playAnimation(curChar:String)
	{
		if (!iconList.contains(curChar))
		{
			animation.play('face');
		}
		else
			animation.play(curChar);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		antialiasing = !noAa.contains(animation.curAnim.name);
		
		offset.set(Std.int(FlxMath.bound(width - 150,0)),Std.int(FlxMath.bound(height - 150,0)));

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
