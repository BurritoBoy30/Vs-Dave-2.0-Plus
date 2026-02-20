package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUICheckBox;

#if desktop
import Discord.DiscordClient;
#end
import options.*;

class OptionsMenuState extends MusicBeatState
{
	var menuBG:FlxSprite;
	
	var changekeys_hitbox:Button;
	var changelang_hitbox:Button;
	var combonum_hitbox:Button;
	
	var icon:HealthIcon;
	var selector_right:Button;
	var selector_left:Button;
	var pickYourGf:Bool = false;
	var allYourGfs:Array<String> = [];
	
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
		new Option('gfontitle'),
		new Option('preloader', FlxG.save.data.preloadAtAll)
	];
	
	var grpOptions:FlxTypedGroup<OptionListing>;
	
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
			menuBG.frames = Paths.getSparrowAtlas('lirabyjoaopereira', 'horny');
			menuBG.animation.addByPrefix("lira deepthroating pogo", "succ", 24);
			menuBG.screenCenter();
			menuBG.animation.play('lira deepthroating pogo');
			menuBG.antialiasing = FlxG.save.data.antiAliasing;
			add(menuBG);
		}
		menuBG.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
		
		var overlay:FlxSprite = new FlxSprite(FlxG.width / 2, 0).loadGraphic(Paths.image('optionbg', 'preload'));
		overlay.antialiasing = FlxG.save.data.antiAliasing;
		add(overlay);
		
		var correct:Float = FlxG.width - 180;
		changekeys_hitbox = new Button(correct, 0, Button.loadOffset('correction'), 'optionbutton', 'preload', function()
		{
			FlxG.switchState(new ChangeKeysState());
		});
		add(changekeys_hitbox);
		
		changelang_hitbox = new Button(correct, 0, Button.loadOffset('correction'), 'optionbutton', 'preload', function()
		{
			FlxG.switchState(new ChangeLanguage());
		});
		add(changelang_hitbox);
		
		combonum_hitbox = new Button(correct, 0, Button.loadOffset('correction'), 'optionbutton', 'preload', function()
		{
			LoadingState.loadAndSwitchState(new ComboNumbersState());
		});
		add(combonum_hitbox);
		
		grpOptions = new FlxTypedGroup<OptionListing>();
		add(grpOptions);
		
		for (i in 0...controlsStrings.length)
		{
			var theoptions:OptionListing = new OptionListing(20, 20 + (155 * i), controlsStrings[i], function()
			{
				chooseYourOptions(controlsStrings[i].returnOption);
			});
			grpOptions.add(theoptions);
		}
		
		// gf option
		icon = new HealthIcon(allYourGfs[FlxG.save.data.gfTitleNum]);
		add(icon);
		
		selector_right = new Button(0, 0, Button.loadOffset('correction'), 'ui/icon_selection', 'preload', function()
		{
			changeYourGF(1);
		});
		selector_right.antialiasing = FlxG.save.data.antiAliasing;
		add(selector_right);
		
		selector_left = new Button(0, 0, Button.loadOffset('correction'), 'ui/icon_selection', 'preload', function()
		{
			changeYourGF(-1);
		});
		selector_left.antialiasing = FlxG.save.data.antiAliasing;
		selector_left.flipX = true;
		add(selector_left);
		
		super.create();
	}
	
	var camoffset:Float = 0;
	var camoffsetLimit:Float = 1700;
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.mouse.wheel > 0)
		{
			if (camoffset < 0)
				camoffset += 100;
		}
		else if (FlxG.mouse.wheel < 0)
		{
			if (camoffset > -camoffsetLimit)
				camoffset -= 100;
		}
		else
			camoffset += 0;
			
		for (item in grpOptions.members)
		{
			item.y = camoffset;
		}
		
		icon.y = (155 * 13) + 30 + camoffset;
		icon.x = 1050;
		selector_left.setPosition(icon.x - selector_left.width, icon.y + 10);
		selector_right.setPosition(icon.x + icon.width, icon.y + 10);
		
		changekeys_hitbox.y = (155 * 5) + 20 + camoffset;
		changelang_hitbox.y = (155 * 8) + 20 + camoffset;
		combonum_hitbox.y = (155 * 12) + 20 + camoffset;
		
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
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
	
	function chooseYourOptions(thingsToReturn:String)
	{
		switch(thingsToReturn)
		{
			case 'ghosttapping':
				FlxG.save.data.newInput = !FlxG.save.data.newInput;
			case 'downscroll':
				FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
			case 'middlescroll':
				FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
			case 'accdisplay':
				FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
			case 'naughtiness':
				FlxG.save.data.hornyALL = !FlxG.save.data.hornyALL;
			case 'fullscreen':
				FlxG.save.data.fullScreen = !FlxG.save.data.fullScreen;
				FlxG.fullscreen = FlxG.save.data.fullScreen;
			case 'eyesores':
				FlxG.save.data.eyesoreson = !FlxG.save.data.eyesoreson;
			case 'antialiasing':
				FlxG.save.data.antiAliasing = !FlxG.save.data.antiAliasing;
			case 'cammove':
				FlxG.save.data.noteCamera = !FlxG.save.data.noteCamera;
			case 'gfsings':
				FlxG.save.data.gfCanSing = !FlxG.save.data.gfCanSing;
			case 'preloader':
				FlxG.save.data.preloadAtAll = !FlxG.save.data.preloadAtAll;
		}
	}
}

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

class OptionListing extends FlxSpriteGroup
{	
	public function new(x:Float, y:Float, getNames:Option, calledBack:Void -> Void)
	{
		super(x, y);
		
		var versionShit:FlxText = new FlxText(x, y, 0, getNames.names, 12);
		versionShit.setFormat("Comic Sans MS Bold", 90, FlxColor.WHITE, LEFT);
		versionShit.antialiasing = FlxG.save.data.antiAliasing;
		
		var versionShit_black:FlxText = new FlxText(x + 5, y + 5, 0, getNames.names, 12);
		versionShit_black.setFormat("Comic Sans MS Bold", 90, FlxColor.BLACK, LEFT);
		versionShit_black.antialiasing = FlxG.save.data.antiAliasing;
		
		if (!['changekeys','changelang', 'combonum', 'gfontitle'].contains(getNames.returnOption))
		{
			var thefuckingcheckbox = new FlxUICheckBox(FlxG.width - 200, y, Paths.image('box', 'preload'), Paths.image('check', 'preload'), "", 100);
			thefuckingcheckbox.callback = calledBack;
			thefuckingcheckbox.checked = getNames.selectors;
			thefuckingcheckbox.boxAntialias = true;
			add(thefuckingcheckbox);
		}
		
		add(versionShit_black);
		add(versionShit);
	}
}