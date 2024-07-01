package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import ComicSansText;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [
		"Ghost Tapping " + (FlxG.save.data.newInput ? "On" : "Off"),
		(FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'),
		"Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on"),
		"Change Keys"
	];

	private var grpControls:FlxTypedGroup<ComicSansText>;
	var versionShit:FlxText;
	override function create()
	{
		trace(controlsStrings);
		
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<ComicSansText>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:ComicSansText = new ComicSansText(0, (70 * i) + 30, controlsStrings[i]);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
		
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			switch(curSelected)
			{
				case 0:
					FlxG.save.data.newInput = !FlxG.save.data.newInput;
					grpControls.members[curSelected].text = "Ghost Tapping " + (FlxG.save.data.newInput ? "On" : "Off");
				case 1:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					grpControls.members[curSelected].text = (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll');
				case 2:
					FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
					grpControls.members[curSelected].text = "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
				case 3:
					FlxG.switchState(new ChangeKeysState());
			}
		}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
