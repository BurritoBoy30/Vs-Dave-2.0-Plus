package;

import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class BackgroundImg extends FlxSprite
{
	public function new(x:Float, y:Float, path:String = 'blank', scrollX:Float = 1, scrollY:Float = 1, antiAliasing:Bool = true, active:Bool = false)
	{
		super(x, y);
		loadGraphic(Paths.image(path, 'shared'));
		if (antiAliasing == true)
			antialiasing = FlxG.save.data.antiAliasing;
		else
			antialiasing = false;
		scrollFactor.set(scrollX, scrollY);
		this.active = active;
	}
	
	public function setImageSize(resize:Float = 1)
	{
		setGraphicSize(Std.int(width * resize));
		updateHitbox();
	}
}