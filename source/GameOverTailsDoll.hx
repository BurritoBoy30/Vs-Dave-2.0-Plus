package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.sound.FlxSound;
import flixel.graphics.frames.FlxAtlasFrames;

class GameOverTailsDoll extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var tailsDoll:FlxSprite;
	var endStatic:FlxSprite;
	var pauseMusic:FlxSound;	
	var tailsCamera:FlxCamera;

	public function new()
	{
		super();
		trace('did it enter the gameover?');
		
		pauseMusic = new FlxSound().loadEmbedded(Paths.music('static'), true, true);
		pauseMusic.volume = 0.3;
		FlxG.sound.list.add(pauseMusic);
		
		FlxG.sound.play(Paths.music('static'), 0);
		
		tailsCamera = new FlxCamera();
		tailsCamera.bgColor.alpha = 0;
		FlxG.cameras.add(tailsCamera);
		tailsCamera.zoom = 0.95;
		
		bg = new FlxSprite(0, -110).loadGraphic(Paths.image('tailsDolldeath/bg_lightsout', 'shared'));
		bg.screenCenter(X);
		bg.scale.set(0.7, 0.7);
		bg.scrollFactor.set();
		bg.antialiasing = FlxG.save.data.antiAliasing;
		add(bg);
		
		tailsDoll = new FlxSprite(0, -250);
		tailsDoll.frames = Paths.getSparrowAtlas('tailsDolldeath/tails_doll_lightsout', 'shared');
		tailsDoll.animation.addByPrefix('wating', 'tails_doll nolight', 24, false);
		tailsDoll.antialiasing = FlxG.save.data.antiAliasing;	
		tailsDoll.scrollFactor.set();
		tailsDoll.animation.play('wating');
		add(tailsDoll);
		
		var blackCutscene:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackCutscene.antialiasing = FlxG.save.data.antiAliasing;
		blackCutscene.scale.set(1.1, 1.1);
		blackCutscene.scrollFactor.set();
		add(blackCutscene);
		
		endStatic = new FlxSprite();
		endStatic.frames = Paths.getSparrowAtlas('tailsDolldeath/deathStatic', 'shared');
		endStatic.animation.addByPrefix('static', 'static', 24, true);
		endStatic.scale.set(1.1, 1.1);
		endStatic.antialiasing = FlxG.save.data.antiAliasing;
		endStatic.scrollFactor.set();
		endStatic.visible = false;
		endStatic.animation.play('static');
		add(endStatic);
		
		bg.cameras = [tailsCamera];
		tailsDoll.cameras = [tailsCamera];
		blackCutscene.cameras = [tailsCamera];
		endStatic.cameras = [tailsCamera];
		
		//FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix, 'shared'));
		
		//start up cutscene
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxTween.tween(blackCutscene, {alpha: 0}, 2, {ease: FlxEase.quadOut});
			
			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				bg.loadGraphic(Paths.image('tailsDolldeath/bg', 'shared'));
				
				tailsDoll.frames = Paths.getSparrowAtlas('tailsDolldeath/tails_doll', 'shared');
				tailsDoll.animation.addByPrefix('scare', 'tails_doll scare', 24, false);
				tailsDoll.animation.addByIndices('staring', 'tails_doll scare', [0, 1], "", 24, true);
				tailsDoll.animation.play('staring');
				
				FlxG.sound.play(Paths.sound('spotlightOn', 'shared'));

				new FlxTimer().start(4, function(tmr:FlxTimer)
				{
					tailsDoll.animation.play('scare');
				});
			});
		});
		
		Conductor.songPosition = 0;
	}
	
	var canEnd:Bool = false;
	
	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && canEnd)
		{
			endBullshit();
		}

		if (controls.BACK && canEnd)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new FreeplayState());
		}

		if (tailsDoll.animation.curAnim.name == 'scare')
		{
			if(tailsDoll.animation.curAnim.curFrame == 2)
			{
				FlxG.sound.play(Paths.sound('unsheathe', 'shared'));
			}
			
			if (tailsDoll.animation.curAnim.curFrame == 3)
			{
				FlxG.sound.play(Paths.sound('tailsScream', 'shared'));
			}
			
			if (tailsDoll.animation.curAnim.finished)
			{
				pauseMusic.play();
				endStatic.visible = true;
				canEnd = true;
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				tailsCamera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
