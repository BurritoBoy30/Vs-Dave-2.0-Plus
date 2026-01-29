package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;

class CharacterSelectSettings extends MusicBeatSubstate
{	
	var titleText:FlxText;
	
	var tailsDoll:FlxUICheckBox;
	var autoLoad:FlxUICheckBox;
	
	var labels:Array<String> = ["Enable Tails Doll", "Enable Auto Load Characters"];
	
	public function new(funnyCam:FlxCamera)
	{
		super();
		
		var backBg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		backBg.alpha = 0.6;
		backBg.scrollFactor.set();
		add(backBg);
		backBg.cameras = [funnyCam];
		
		titleText = new FlxText(0, -15, FlxG.width, "Settings", 16);
		titleText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		titleText.borderSize = 3;
		titleText.antialiasing = FlxG.save.data.antiAliasing;
		add(titleText);
		titleText.cameras = [funnyCam];
		
		tailsDoll = new FlxUICheckBox(100, 100, Paths.image('charselect/hornygf_box'), Paths.image('charselect/hornygf_boxCheck'), "", 100);
		tailsDoll.callback = function()
		{
			FlxG.save.data.canTailsDoll = !FlxG.save.data.canTailsDoll;
		};
		tailsDoll.checked = FlxG.save.data.canTailsDoll;
		tailsDoll.boxAntialias = true;
		add(tailsDoll);
		tailsDoll.cameras = [funnyCam];
		
		autoLoad = new FlxUICheckBox(100, 200, Paths.image('charselect/hornygf_box'), Paths.image('charselect/hornygf_boxCheck'), "", 100);
		autoLoad.callback = function()
		{
			FlxG.save.data.canAutoLoad = !FlxG.save.data.canAutoLoad;
		};
		autoLoad.checked = FlxG.save.data.canAutoLoad;
		autoLoad.boxAntialias = true;
		add(autoLoad);
		autoLoad.cameras = [funnyCam];
		
		for (i in 0...labels.length)
		{
			var labelText:FlxText = new FlxText(200, 105 + (100 * i), FlxG.width, labels[i], 16);
			labelText.setFormat(Paths.font("comic.ttf"), 55, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			labelText.borderSize = 2;
			labelText.antialiasing = FlxG.save.data.antiAliasing;
			add(labelText);
			labelText.cameras = [funnyCam];
		}
	}
	
	override function update(elapsed:Float)
	{	
		super.update(elapsed);
		
		if (controls.BACK)
		{	
			close();
		}
	}
}