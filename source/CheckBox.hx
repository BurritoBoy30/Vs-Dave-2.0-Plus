package;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.text.FlxText;

class CheckBox extends FlxSprite
{
	var theSwitch:Bool = false;
	public var textTracker:FlxSprite;
	
	public function new(theSwitchData:Bool)
	{
		super();
		theSwitch = theSwitchData;
		
		loadGraphic(Paths.image('checkbox', 'shared'), true, 150, 150);
		
		animation.add('pressed', [1], 0, false, false);
		animation.add('notPressed', [0], 0, false, false);

		switchButton(theSwitchData);
		
		antialiasing = FlxG.save.data.antiAliasing;
	}
	
	public function switchButton(placeboolhere:Bool)
	{
		if (placeboolhere)
			animation.play('pressed');
		else
			animation.play('notPressed');
	}
	
	override function update(elapsed:Float)
	{
		if (textTracker != null)
			setPosition(textTracker.x + textTracker.width + 15, textTracker.y - 40);

		super.update(elapsed);
	}
}