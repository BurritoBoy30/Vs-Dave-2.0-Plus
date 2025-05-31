package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.addons.transition.Transition;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['resume', 'restart', 'botplay', 'exit'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var bg:FlxBackdrop;
	var botplayText:FlxText;
	
	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var backBg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width + 5, FlxG.height + 5, FlxColor.BLACK);
		backBg.alpha = 0;
		backBg.scrollFactor.set();
		add(backBg);
		
		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.alpha = 0;
		bg.antialiasing = FlxG.save.data.antiAliasing;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("comic.ttf"), 34);
		levelInfo.antialiasing = FlxG.save.data.antiAliasing;
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, levelInfo.y + 32, 0, "", 32);
		//levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('comic.ttf'), 34);
		levelDifficulty.updateHitbox();
		levelDifficulty.antialiasing = FlxG.save.data.antiAliasing;
		add(levelDifficulty);
		
		botplayText = new FlxText(20, FlxG.height - 70, 0, "", 32);
		botplayText.text = ReturnLanguage.getLine('botplayScreen');
		botplayText.scrollFactor.set();
		botplayText.setFormat(Paths.font('comic.ttf'), 32);
		botplayText.x = FlxG.width - (botplayText.width + 30);
		botplayText.updateHitbox();
		botplayText.antialiasing = FlxG.save.data.antiAliasing;
		add(botplayText);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(backBg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, ReturnLanguage.getLine(menuItems[i]), true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.menuStyle = 'pause';
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		var scrollSpeed:Float = 50;
		bg.x -= scrollSpeed * elapsed;
		bg.y -= scrollSpeed * elapsed;
		
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		
		botplayText.visible = PlayState.botPlayOn;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "resume":
					if (PlayState.video != null)
					{
						PlayState.video.resume();
					}

					close();
				case "restart":
					if (PlayState.video != null)
					{
						PlayState.video.destroy();
					}
				
					Transition.nextCamera = transCamera;
					FlxG.resetState();
				case 'botplay':
					PlayState.botPlayOn = !PlayState.botPlayOn;
				case "exit":
					if (PlayState.video != null)
					{
						PlayState.video.destroy();
					}
					
					Transition.nextCamera = transCamera;
					PlayState.botPlayOn = false;
					
					PlayState.boyfriendOverride = "none";
					PlayState.girlfriendOverride = "none";
					
					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else
						FlxG.switchState(new FreeplayState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
