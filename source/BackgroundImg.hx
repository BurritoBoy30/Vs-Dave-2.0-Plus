package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class BackgroundImg extends FlxSprite
{	
	public function new(x:Float, y:Float, path:String = 'blank', animations:Array<Dynamic> = null, folder:String = 'shared', scroll:Float = 1, antiAliasing:Bool = true, active:Bool = false, imageSize:Float = 1)
	{
		super(x, y);
		reloadImage(path, animations, folder, scroll, antiAliasing, active, imageSize);
	}
	
	public function reloadImage(path:String = 'blank', animations:Array<Dynamic> = null, folder:String = 'shared', scroll:Float = 1, antiAliasing:Bool = true, active:Bool = false, imageSize:Float = 1)
	{
		if (animations != null)
		{
			frames = Paths.getSparrowAtlas(path, folder);
			for (i in 0...animations.length)
			{
				if (animations[i][0] == 'prefix')	
				{
					animation.addByPrefix(animations[i][1], animations[i][2], animations[i][3], animations[i][4]);
				}
				else if (animations[i][0] == 'indices')
				{
					animation.addByIndices(animations[i][1], animations[i][2], animations[i][3], "", animations[i][4], animations[i][5]);
				}
			}
		}
		else
			loadGraphic(Paths.image(path, folder));

		if (antiAliasing == true)
			antialiasing = FlxG.save.data.antiAliasing;
		else
			antialiasing = false;
			
		scrollFactor.set(scroll, scroll);
		if (animations != null)
		{
			this.active = true;
		}
		else
			this.active = active;
		
		setGraphicSize(Std.int(width * imageSize));
		updateHitbox();
	}
}