package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var gameVer:String = "1.3";

	var magenta:FlxSprite;	
	
	var playButton:Button;
	var optionsButton:Button;
	var creditsButton:Button;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;
		
		FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image(randomizeBG(), 'preload'));
		bg.antialiasing = FlxG.save.data.antiAliasing;
		bg.color = 0xFFFDE871;
		bg.scrollFactor.set();
		add(bg);

		magenta = new FlxSprite().loadGraphic(bg.graphic);
		magenta.visible = false;
		magenta.antialiasing = FlxG.save.data.antiAliasing;
		magenta.color = 0xFFfd719b;
		magenta.scrollFactor.set();
		add(magenta);
		
		var menuside:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/Menu_Side', 'preload'));
		menuside.antialiasing = FlxG.save.data.antiAliasing;
		menuside.alpha = 0.8;
		menuside.scrollFactor.set();
		add(menuside);
		// magenta.scrollFactor.set();
		
		var buttonposition:Array<Float> = [20, 20];
		playButton = new Button(buttonposition[0], buttonposition[1], Button.loadOffset('correction'), 'ui/mainmenu_buttons/' + FlxG.save.data.gameLanguage + '/mainmenu_play', 'preload', !selectedSomethin, function()
		{
			if (!selectedSomethin)
				goToState('play', playButton);
		});
		add(playButton);
		
		optionsButton = new Button(buttonposition[0] + 135, buttonposition[1] + playButton.height + 20, Button.loadOffset('correction'), 'ui/mainmenu_buttons/' + FlxG.save.data.gameLanguage + '/mainmenu_options', 'preload', !selectedSomethin, function()
		{
			if (!selectedSomethin)
				goToState('options', optionsButton);
		});
		add(optionsButton);
		
		creditsButton = new Button(buttonposition[0] + (135 * 2), buttonposition[1] + playButton.height + optionsButton.height + 40, Button.loadOffset('correction'), 'ui/mainmenu_buttons/' + FlxG.save.data.gameLanguage + '/mainmenu_credits', 'preload', !selectedSomethin, function()
		{
			if (!selectedSomethin)
				goToState('credits', creditsButton);
		});
		add(creditsButton);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 32, 0, "Burrito Engine+ v" + gameVer, 12);
		versionShit.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.borderSize = 1.5;
		versionShit.antialiasing = FlxG.save.data.antiAliasing;
		versionShit.scrollFactor.set();
		add(versionShit);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}
			
			if (FlxG.keys.justPressed.SEVEN)
			{
				FlxG.switchState(new AnimationDebug());
			}
		}

		super.update(elapsed);
	}
	
	function goToState(thestate:String, target:FlxSprite)
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		FlxFlicker.flicker(magenta, 1.1, 0.15, false);

		FlxFlicker.flicker(target, 1, 0.06, false, false, function(flick:FlxFlicker)
		{			
			switch (thestate)
			{
				case 'play':
					FlxG.switchState(new FreeplayState());
				case 'options':
					FlxG.switchState(new OptionsMenu());
				case 'credits':
					FlxG.switchState(new CreditsState());
			}
		});
		
		FlxG.mouse.visible = false;
	}
	
	public static function randomizeBG()
	{
		var bgs:Array<String> = ['mamakotomi', 'mantis', 'morie', 'Olyantwo', 'SUSSUS AMOGUS' , 'SwagnotrllyTheMod', 'T5mpler'];
		var chance:Int = FlxG.random.int(0, bgs.length - 1);
		
		return 'backgrounds/' + bgs[chance];
	}
}
