package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
import options.*;

class OptionsMenu extends MusicBeatState
{
	var menuBG:FlxSprite;
	var curSelected:Int = 0;
	var icon:HealthIcon;
	var selector:FlxSprite;
	
	var controlsStrings:Array<Option> = [
		new Option('ghosttapping', FlxG.save.data.newInput),
		new Option('downscroll', FlxG.save.data.downscroll),
		new Option('middlescroll', FlxG.save.data.middlescroll),
		new Option('accdisplay', FlxG.save.data.accuracyDisplay),
		new Option('naughtiness', FlxG.save.data.hornyALL),
		new Option('changekeys'),
		new Option('fullscreen', FlxG.save.data.fullScreen),
		new Option('eyesores', FlxG.save.data.eyesoreson),
		new Option('changelang'),
		new Option('antialiasing', FlxG.save.data.antiAliasing),
		new Option('cammove', FlxG.save.data.noteCamera),
		new Option('gfsings', FlxG.save.data.gfCanSing),
		new Option('combonum'),
		new Option('gfontitle')
	];
	
	var allYourGfs:Array<String> = [];
	
	private var grpControls:FlxTypedGroup<Alphabet>;
	private var checkArray:Array<CheckBox> = [];
		
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Option Menu", null);
		#end
		
		if (!FlxG.save.data.hornyALL)
		{	
			allYourGfs = ['gf', 'gf-pixel', 'psyka', 'cyan'];
			
			menuBG = new FlxSprite().loadGraphic(Paths.image(MainMenuState.randomizeBG(), 'preload'));
			menuBG.screenCenter();
			menuBG.antialiasing = FlxG.save.data.antiAliasing;
			add(menuBG);
		}
		else
		{
			allYourGfs = ['gf', 'gf-pixel', 'three-gfs', 'tails-doll'];
			
			menuBG = new FlxSprite();
			menuBG.frames = Paths.getSparrowAtlas('hornyshit/lirabyjoaopereira', 'preload');
			menuBG.animation.addByPrefix("lira deepthroating pogo", "succ", 24);
			menuBG.screenCenter();
			menuBG.animation.play('lira deepthroating pogo');
			menuBG.antialiasing = FlxG.save.data.antiAliasing;
			add(menuBG);
		}
		
		menuBG.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
		
		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (90 * i) + 30, controlsStrings[i].names, true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			controlLabel.yAdd = 50;
			controlLabel.menuStyle = 'options';
			grpControls.add(controlLabel);
			
			var controlCheckBox:CheckBox = new CheckBox(controlsStrings[i].selectors);
			controlCheckBox.textTracker = controlLabel;
			checkArray.push(controlCheckBox);
			add(controlCheckBox);
		}
		
		icon = new HealthIcon(allYourGfs[FlxG.save.data.gfTitleNum]);
		add(icon);
		
		selector = new FlxSprite().loadGraphic(Paths.image('ui/icon_selection', 'preload'));
		selector.antialiasing = FlxG.save.data.antiAliasing;
		add(selector);
		
		checkArray[5].visible = false;
		checkArray[8].visible = false;
		checkArray[12].visible = false;
		checkArray[13].visible = false;
		
		super.create();
		
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		icon.y = grpControls.members[13].y - 45;
		icon.x = FlxG.width - icon.width - 60;
		selector.y = icon.y;
		selector.x = icon.x - (selector.width / 5);
		
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
			
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
		
		if (controlsStrings[curSelected].returnOption == 'gfontitle')
		{
			if (controls.LEFT_P)
				changeYourGF(-1);
			if (controls.RIGHT_P)
				changeYourGF(1);
		}
		
		if (controls.ACCEPT)
		{
			switch(controlsStrings[curSelected].returnOption)
			{
				case 'ghosttapping':
					FlxG.save.data.newInput = !FlxG.save.data.newInput;
					checkArray[curSelected].switchButton(FlxG.save.data.newInput);
				case 'downscroll':
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					checkArray[curSelected].switchButton(FlxG.save.data.downscroll);
				case 'middlescroll':
					FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
					checkArray[curSelected].switchButton(FlxG.save.data.middlescroll);
				case 'accdisplay':
					FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
					checkArray[curSelected].switchButton(FlxG.save.data.accuracyDisplay);
				case 'naughtiness':
					FlxG.save.data.hornyALL = !FlxG.save.data.hornyALL;
					checkArray[curSelected].switchButton(FlxG.save.data.hornyALL);
				case 'changekeys':
					FlxG.switchState(new ChangeKeysState());
				case 'fullscreen':
					FlxG.save.data.fullScreen = !FlxG.save.data.fullScreen;
					checkArray[curSelected].switchButton(FlxG.save.data.fullScreen);
					FlxG.fullscreen = FlxG.save.data.fullScreen;
				case 'eyesores':
					FlxG.save.data.eyesoreson = !FlxG.save.data.eyesoreson;
					checkArray[curSelected].switchButton(FlxG.save.data.eyesoreson);
				case 'changelang':
					FlxG.switchState(new ChangeLanguage());
				case 'antialiasing':
					FlxG.save.data.antiAliasing = !FlxG.save.data.antiAliasing;
					checkArray[curSelected].switchButton(FlxG.save.data.antiAliasing);
				case 'cammove':
					FlxG.save.data.noteCamera = !FlxG.save.data.noteCamera;
					checkArray[curSelected].switchButton(FlxG.save.data.noteCamera);
				case 'gfsings':
					FlxG.save.data.gfCanSing = !FlxG.save.data.gfCanSing;
					checkArray[curSelected].switchButton(FlxG.save.data.gfCanSing);
				case 'combonum':
					LoadingState.loadAndSwitchState(new ComboNumbersState());
			}
		}
	}
	
	function changeYourGF(change:Int)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		FlxG.save.data.gfTitleNum += change;

		if (FlxG.save.data.gfTitleNum < 0)
			FlxG.save.data.gfTitleNum = allYourGfs.length - 1;
		if (FlxG.save.data.gfTitleNum >= allYourGfs.length)
			FlxG.save.data.gfTitleNum = 0;
			
		icon.createIcon(allYourGfs[FlxG.save.data.gfTitleNum]);
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
			checkArray[i].alpha = 0.4;
		}

		checkArray[curSelected].alpha = 1;
		
		for (fuckerItem in grpControls.members)
		{
			fuckerItem.targetY = bullShit - curSelected;
			bullShit++;

			fuckerItem.alpha = 0.4;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (fuckerItem.targetY == 0)
			{
				fuckerItem.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

// i love this
class Option
{
	public var names:String;
	public var selectors:Bool;
	
	public var returnOption:String;

	public function new(namesData:String, ?selectorsData:Bool = false)
	{
		names = ReturnLanguage.getLine(namesData);
		
		selectors = selectorsData;
		
		returnOption = namesData;
	}
}