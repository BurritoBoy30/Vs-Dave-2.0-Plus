package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.system.FlxSound;

class GameOverTailsDoll extends MusicBeatSubstate
{
	var tailsDoll:FlxSprite;
	var stageSuffix:String = "";
	var endStatic:FlxSprite;
	var pauseMusic:FlxSound;
	
	var stayStillLine:FlxSound;
	
	var tailsCamera:FlxCamera;

	public function new()
	{
		super();
		trace('did it enter the gameover?');
		
		pauseMusic = new FlxSound().loadEmbedded(Paths.music('static'), true, true);
		pauseMusic.volume = 0.3;
		FlxG.sound.list.add(pauseMusic);
		
		tailsCamera = new FlxCamera();
		tailsCamera.bgColor.alpha = 0;
		FlxG.cameras.add(tailsCamera);
		tailsCamera.zoom = 1;
		
		tailsDoll = new FlxSprite(0, -300);
		tailsDoll.frames = Paths.getSparrowAtlas('tailsDolldeath/tails_doll', 'shared');
		tailsDoll.animation.addByPrefix('scare', 'tails_doll scare', 14, false);
		tailsDoll.antialiasing = FlxG.save.data.antiAliasing;
		tailsDoll.scrollFactor.set();
		tailsDoll.animation.play('scare');
		add(tailsDoll);
		
		endStatic = new FlxSprite(0,0);
		endStatic.visible = false;
		endStatic.frames = Paths.getSparrowAtlas('tailsDolldeath/deathStatic', 'shared');
		endStatic.animation.addByPrefix('static', 'static', 24, true);
		endStatic.antialiasing = FlxG.save.data.antiAliasing;
		endStatic.scrollFactor.set();
		endStatic.animation.play('static');
		add(endStatic);
		
		stayStillLine = new FlxSound().loadEmbedded(Paths.sound('stayStill', 'shared'));
		stayStillLine.volume = 1;
		FlxG.sound.list.add(stayStillLine);
		stayStillLine.play();
		
		tailsDoll.cameras = [tailsCamera];
		endStatic.cameras = [tailsCamera];
		
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

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if (tailsDoll.animation.curAnim.name == 'scare')
		{
			if(tailsDoll.animation.curAnim.curFrame == 5)
			{
				FlxG.sound.play(Paths.sound('unsheathe', 'shared'));
			}
			if (tailsDoll.animation.curAnim.curFrame == 12)//if (tailsDoll.animation.curAnim.finished)
			{
				stayStillLine.destroy();
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
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
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
