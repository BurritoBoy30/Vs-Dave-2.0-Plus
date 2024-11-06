package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Button extends FlxSprite
{
	var buttonAxis:Array<Dynamic>;
	var callback:Void -> Void;

	public function new (x:Float, y:Float, notButtonAxis:Array<Dynamic>, buttonImg:String, callBack:Void -> Void)
	{
		super(x,y);
		
		loadGraphic(Paths.image(buttonImg, 'shared'));
		antialiasing = FlxG.save.data.antiAliasing;
		
		buttonAxis = notButtonAxis;
		
		callback = callBack;
	}
	
	function mouseOverButton()
	{
		return (FlxG.mouse.x > (x + 100 + buttonAxis[0][0]) && FlxG.mouse.x < (x + width + 100 + buttonAxis[0][1]))
			&& (FlxG.mouse.y > (y + 100 + buttonAxis[1][0]) && FlxG.mouse.y < (y + height + 100 + buttonAxis[1][1]));
	}
	
	override function update(elapsed:Float)
	{		
		super.update(elapsed);
		
		if (mouseOverButton())
		{
			color = 0xFF878787;
			
			if (FlxG.mouse.justPressed)
			{
				if (callback != null)
					callback();
			}
		}
		else
		{
			color = FlxColor.WHITE;
		}
	}
}