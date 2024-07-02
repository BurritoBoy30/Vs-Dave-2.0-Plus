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
	
	var noAa:Array<String> = ['dave-angey', 'bambi-3d', 'bf-pixel', 'senpai','senpai-angry','spirit'];
	var isReallyPlayer:Bool = false;
	
	var iconList:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		
		isReallyPlayer = isPlayer;

		addIcon('bf', [0, 1]);
		addIcon('bf-car', [0, 1]);
		addIcon('bf-christmas', [0, 1]);
		addIcon('bf-pixel', [21, 21]);
		addIcon('spooky', [2, 3]);
		addIcon('pico', [4, 5]);
		addIcon('mom', [6, 7]);
		addIcon('mom-car', [6, 7]);
		addIcon('tankman', [8, 9]);
		addIcon('face', [10, 11]);
		addIcon('dad', [12, 13]);
		addIcon('senpai', [22, 22]);
		addIcon('senpai-angry', [22, 22]);
		addIcon('spirit', [23, 23]);
		addIcon('bf-old', [14, 15]);
		addIcon('gf', [16]);
		addIcon('parents-christmas', [17]);
		addIcon('monster', [19, 20]);
		addIcon('monster-christmas', [19, 20]);
		
		playAnimation(char);
		scrollFactor.set();
		
		//trace(iconList);
	}
	
	function addIcon(target:String, phases:Array<Int>)
	{
		animation.add(target, phases, 0, false, isReallyPlayer);
		iconList += target;
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
