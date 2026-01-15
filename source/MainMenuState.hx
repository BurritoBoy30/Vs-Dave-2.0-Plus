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
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var gameVer:String = "1.3";

	var magenta:FlxSprite;
	var bar:FlxBackdrop;
	
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
		add(bg);

		magenta = new FlxSprite().loadGraphic(bg.graphic);
		magenta.visible = false;
		magenta.antialiasing = FlxG.save.data.antiAliasing;
		add(magenta);
		
		bar = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), XY, 0, 0);
		bar.antialiasing = FlxG.save.data.antiAliasing;
		add(bar);
		
		var menufolks:Array<String> = ['dummyfriend', 'ema1', 'ema2', 'sarvente', 'duomi'];
		var dummyfriend:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hornyshit/main_menu_folks/' + menufolks[FlxG.random.int(0, menufolks.length - 1)], 'shared'));
		dummyfriend.antialiasing = FlxG.save.data.antiAliasing;
		dummyfriend.visible = FlxG.save.data.hornyALL;
		add(dummyfriend);
		
		var overlay:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgroundOverlay', 'preload'));
		overlay.antialiasing = FlxG.save.data.antiAliasing;
		add(overlay);
		
		var buttonposition:Array<Float> = [30, 30];
		playButton = new Button(buttonposition[0], buttonposition[1], Button.loadOffset('correction'), 'ui/mainmenu_buttons/' + FlxG.save.data.gameLanguage + '/mainmenu_play', 'preload', function()
		{
			if (!selectedSomethin)
				goToState('play', playButton, 0xFF8484FF);
		});
		add(playButton);
		
		optionsButton = new Button(buttonposition[0] + 145, buttonposition[1] + playButton.height + 30, Button.loadOffset('correction'), 'ui/mainmenu_buttons/' + FlxG.save.data.gameLanguage + '/mainmenu_options', 'preload', function()
		{
			if (!selectedSomethin)
				goToState('options', optionsButton, 0xFF878787);
		});
		add(optionsButton);
		
		creditsButton = new Button(buttonposition[0] + (145 * 2), buttonposition[1] + playButton.height + optionsButton.height + 60, Button.loadOffset('correction'), 'ui/mainmenu_buttons/' + FlxG.save.data.gameLanguage + '/mainmenu_credits', 'preload', function()
		{
			if (!selectedSomethin)
				goToState('credits', creditsButton, 0xFFFF84F2);
		});
		add(creditsButton);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 32, 0, "Burrito Engine v" + gameVer, 12);
		versionShit.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.borderSize = 1.5;
		versionShit.antialiasing = FlxG.save.data.antiAliasing;
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
		
		for(allbuttons in [playButton, optionsButton, creditsButton]) {
			allbuttons.setPermition = !selectedSomethin;
		}
		
		var scrollSpeed:Float = 100;
		bar.x += scrollSpeed * elapsed;

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
	
	function goToState(thestate:String, target:FlxSprite, flashcolor:FlxColor)
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		
		magenta.color = flashcolor;
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
		
		for (memb in [playButton, optionsButton, creditsButton])
		{
			if(memb == target)
				continue;

			FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
		}
		
		
		FlxG.mouse.visible = false;
	}
	
	public static function randomizeBG()
	{
		var bgs:Array<String> = ['mamakotomi', 'mantis', 'morie', 'Olyantwo', 'SUSSUS AMOGUS' , 'SwagnotrllyTheMod', 'T5mpler'];
		var chance:Int = FlxG.random.int(0, bgs.length - 1);
		
		return 'backgrounds/' + bgs[chance];
	}
}
