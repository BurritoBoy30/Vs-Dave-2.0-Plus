package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class WarningState extends MusicBeatState
{
	var cantPress:Bool = false;
	var versionShit:FlxText;
	
	override function create()
	{
		versionShit = new FlxText(0, 0, FlxG.width,
			"WARNING!" + '\n' +
			"This mod contains content that might make people unconfortable." + "\n" +
			"(Most BF and GF skins are really mature)" + "\n" + "\n" +
			"Press Y if you like to keep them on" + "\n" +
			"Press N if you like to diable them" + "\n" +
			"(You can change in the settings later)"
		, 12);
		versionShit.setFormat("Comic Sans MS Bold", 45, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.borderSize = 1.5;
		versionShit.antialiasing = FlxG.save.data.antiAliasing;
		versionShit.screenCenter();
		add(versionShit);
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if ((FlxG.keys.justPressed.Y || FlxG.keys.justPressed.N) && !cantPress)
		{
			cantPress = true;
			FlxG.save.data.seenWarning = true;
			
			if (FlxG.keys.justPressed.Y)
				FlxG.save.data.hornyALL = true;
			
			if (FlxG.keys.justPressed.N)
				FlxG.save.data.hornyALL = false;
			
			versionShit.visible = false;
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(new TitleState());
			});
		}	
	}
}