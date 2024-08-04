package;

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
	
	var controlsStrings:Array<Dynamic> = [
		["Ghost Tapping", FlxG.save.data.newInput],
		['Downscroll', FlxG.save.data.downscroll],
		["Accuracy Display", FlxG.save.data.accuracyDisplay],
		["Naughtiness", FlxG.save.data.hornyALL],
		["Change Keys", false],
		["Fullscreen", FlxG.save.data.fullScreen],
		["Eye Sores",FlxG.save.data.eyesoreson]
	];
	private var grpControls:FlxTypedGroup<ComicSansText>;
	private var checkArray:Array<CheckBox> = [];
	
	override function create()
	{		
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.color = 0xFFea71fd;
		menuBG.antialiasing = true;
		add(menuBG);
		
		var hornyBitches:FlxSprite = new FlxSprite(0, 0);
		hornyBitches.frames = Paths.getSparrowAtlas('hornyshit/rebecca', 'shared');
		hornyBitches.animation.addByPrefix('idle', "rebecca idle", 30);
		hornyBitches.screenCenter(X);
		hornyBitches.color = 0xFFea71fd;
		hornyBitches.animation.play('idle');
		hornyBitches.antialiasing = true;
		if (FlxG.save.data.hornyALL) add(hornyBitches);
		
		grpControls = new FlxTypedGroup<ComicSansText>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:ComicSansText = new ComicSansText(0, (70 * i) + 30, controlsStrings[i][0]);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			controlLabel.yAdd = 20;
			grpControls.add(controlLabel);
			
			var controlCheckBox:CheckBox = new CheckBox(controlsStrings[i][1]);
			controlCheckBox.textTracker = controlLabel;
			checkArray.push(controlCheckBox);
			add(controlCheckBox);
		}
		
		checkArray[4].visible = false;
		
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
					checkArray[curSelected].switchButton(FlxG.save.data.newInput);
				case 1:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					checkArray[curSelected].switchButton(FlxG.save.data.downscroll);
				case 2:
					FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
					checkArray[curSelected].switchButton(FlxG.save.data.accuracyDisplay);
				case 3:
					FlxG.save.data.hornyALL = !FlxG.save.data.hornyALL;
					checkArray[curSelected].switchButton(FlxG.save.data.hornyALL);
				case 4:
					FlxG.switchState(new ChangeKeysState());
				case 5:
					FlxG.save.data.fullScreen = !FlxG.save.data.fullScreen;
					checkArray[curSelected].switchButton(FlxG.save.data.fullScreen);
					FlxG.fullscreen = FlxG.save.data.fullScreen;
				case 6:
					FlxG.save.data.eyesoreson = !FlxG.save.data.eyesoreson;
					checkArray[curSelected].switchButton(FlxG.save.data.eyesoreson);
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
		
		for (i in 0...checkArray.length)
		{
			checkArray[i].alpha = 0.6;
		}

		checkArray[curSelected].alpha = 1;
		
		for (fuckerItem in grpControls.members)
		{
			fuckerItem.targetY = bullShit - curSelected;
			bullShit++;

			fuckerItem.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (fuckerItem.targetY == 0)
			{
				fuckerItem.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
