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
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'credits'];
	public static var gameVer:String = "1.3";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	
	var thingText:FlxText;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(randomizeBG());
		bg.antialiasing = FlxG.save.data.antiAliasing;
		bg.color = 0xFFFDE871;
		bg.scrollFactor.set();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

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

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(50 - (i * 75), 100 + (i * 210));
			menuItem.frames = Paths.getSparrowAtlas('ui/main_menu_icons');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(1, 1);
			menuItem.antialiasing = FlxG.save.data.antiAliasing;
		}

		FlxG.camera.follow(camFollow, null, 0.1);
		
		thingText = new FlxText(0, 0, 0, "", 12);
		thingText.setFormat("Comic Sans MS Bold", 100, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		thingText.borderSize = 3;
		thingText.antialiasing = FlxG.save.data.antiAliasing;
		add(thingText);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 32, 0, "Dave Engine+ v" + gameVer, 12);
		versionShit.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.borderSize = 1.5;
		versionShit.antialiasing = FlxG.save.data.antiAliasing;
		versionShit.scrollFactor.set();
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

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
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}
			
			if (FlxG.keys.justPressed.SEVEN)
			{
				FlxG.switchState(new AnimationDebug());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(thingText, 1, 0.06, false, false);
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];
							
							switch (daChoice)
							{
								case 'story mode':
									FlxG.switchState(new StoryMenuState());
								case 'freeplay':
									FlxG.switchState(new FreeplayState());
								case 'options':
									FlxG.switchState(new OptionsMenu());
								case 'credits':
									FlxG.switchState(new CreditsState());
							}
						});
					}
				});
			}
		}

		super.update(elapsed);
	}
	
	public static function randomizeBG()
	{
		var bgs:Array<String> = ['mamakotomi', 'mantis', 'morie', 'Olyantwo', 'SUSSUS AMOGUS' , 'SwagnotrllyTheMod', 'T5mpler'];
		var chance:Int = FlxG.random.int(0, bgs.length - 1);
		
		return Paths.image('backgrounds/' + bgs[chance]);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x + 325, spr.getGraphicMidpoint().y);
				thingText.text = ReturnLanguage.getLine(optionShit[curSelected]);
				thingText.setPosition(spr.x + spr.width + 20, spr.y + 20);
			}
		});
	}
}
