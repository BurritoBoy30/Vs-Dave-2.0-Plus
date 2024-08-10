package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class CreditsState extends MusicBeatState
{
	override function create()
	{	
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.color = 0xFF00CECE;
		menuBG.antialiasing = true;
		add(menuBG);
		
		var versionShit:FlxText = new FlxText(0, 0, FlxG.width, "Not done yet :(", 12);
		versionShit.setFormat("Comic Sans MS Bold", 70, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.borderSize = 1.5;
		versionShit.antialiasing = true;
		versionShit.screenCenter();
		add(versionShit);
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
	}
}