package;

import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class BackgroundImg extends FlxSprite
{
	public function new(x:Float, y:Float, path:String = 'blank', folder:String = 'shared', scroll:Float = 1, antiAliasing:Bool = true, active:Bool = false, imageSize:Float = 1)
	{
		super(x, y);
		reloadImage(path, scroll, antiAliasing, active, imageSize);
	}
	
	public function reloadImage(path:String = 'blank', folder:String = 'shared', scroll:Float = 1, antiAliasing:Bool = true, active:Bool = false, imageSize:Float = 1)
	{
		loadGraphic(Paths.image(path, folder));
		if (antiAliasing == true)
			antialiasing = FlxG.save.data.antiAliasing;
		else
			antialiasing = false;
		scrollFactor.set(scroll, scroll);
		this.active = active;
		
		setGraphicSize(Std.int(width * imageSize));
		updateHitbox();
	}
	
	public function setImageSize(resize:Float = 1)
	{
		setGraphicSize(Std.int(width * resize));
		updateHitbox();
	}
}