package;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANS
class ComicSansText extends FlxText
{
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;
	
	public function new(x:Float, y:Float, textInput:String = "", autoSizeOn:Bool = false, theAlingment:FlxTextAlign = LEFT)
	{
		super(x, y);
		
		text = textInput;
		font = 'Comic Sans MS Bold';
		autoSize = autoSizeOn;
		size = 90;
		fieldWidth = FlxG.width;
		alignment = theAlingment;
		borderStyle = FlxTextBorderStyle.OUTLINE;
		borderColor = FlxColor.BLACK;
		borderSize = 4;
	}
	
	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.40), 0.16);
			x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16);
		}
		
		antialiasing = true;

		super.update(elapsed);
	}
}