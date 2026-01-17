package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class Button extends FlxSprite
{
	var buttonAxis:Array<Dynamic>;
	public var callback:Void -> Void;
	var buttonPressed:Bool = false;
	public var setPermition:Bool = true;

	public function new (x:Float, y:Float, notButtonAxis:Array<Dynamic>, buttonImg:String, ?folder:String = 'shared',?callBack:Void -> Void)
	{
		super(x,y);
		
		loadGraphic(Paths.image(buttonImg, folder));
		antialiasing = FlxG.save.data.antiAliasing;
		
		buttonAxis = notButtonAxis;
		
		callback = callBack;
	}
	
	override function update(elapsed:Float)
	{		
		super.update(elapsed);
		
		// i need to do this kind of checking otherwise it fucking glitches out on zooms
		if ((FlxG.mouse.x > (x + 100 + buttonAxis[0][0]) && FlxG.mouse.x < (x + width + 100 + buttonAxis[0][1]))
		 && (FlxG.mouse.y > (y + 100 + buttonAxis[1][0]) && FlxG.mouse.y < (y + height + 100 + buttonAxis[1][1])) && setPermition)
		{
			color = 0xFF878787;
			
			if (FlxG.mouse.justPressed && !buttonPressed)
			{
				isPressed(this);
				
				if (callback != null)
					callback();
			}
		}
		else
			color = FlxColor.WHITE;
	}
	
	function isPressed(target:FlxSprite)
	{
		buttonPressed = true;
		target.scale.set(0.95, 0.95);
		FlxTween.tween(target, {'scale.x': 1, 'scale.y': 1}, 0.1, {onComplete: function(twn:FlxTween)
		{
			buttonPressed = false;
		}});
	}
	
	public function reloadImage(img:String = 'blank', folder:String = 'shared')
	{
		loadGraphic(Paths.image(img, folder));
	}
	
	public static function loadOffset(file:String)
	{
		var xOffsets:Array<Float> = [0, 0];
		var yOffsets:Array<Float> = [0, 0];
		var	buttonsoffsets:Array<Dynamic> = [[0, 0], [0, 0]];
		
		var offsetStuffs:Array<String> = CoolUtil.coolTextFile(Paths.txt('buttons/' + file, 'preload'));
		
		for (charText in offsetStuffs)
		{
			var charInfo:Array<String> = charText.split(": ");
			
			switch (charInfo[0])
			{
				case 'x':
					var XoffsetInfo:Array<String> = charInfo[1].split(', ');
					xOffsets = [Std.parseFloat(XoffsetInfo[0]), Std.parseFloat(XoffsetInfo[1])];
					
				case 'y':
					var YoffsetInfo:Array<String> = charInfo[1].split(', ');
					yOffsets = [Std.parseFloat(YoffsetInfo[0]), Std.parseFloat(YoffsetInfo[1])];
			}
		}
		
		buttonsoffsets = [xOffsets, yOffsets];
		
		return buttonsoffsets;
	}
}