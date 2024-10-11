package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float, char:String)
	{
		super();
		trace('did it enter the gameover?');
		var daBf:String = '';
		switch (char)
		{
			case 'bf-pixel':
			//	stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'rapper-gf':
				daBf = 'rapper-gf-dead';
			default:
				daBf = char;
		}

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		if(bf.animation.getByName('firstDeath') == null)
		{
			bf = new Boyfriend(x, y, "bf");
		}
		add(bf);
		trace('is it an asset problem?');
		
		var cameraOffset:Array<Float> = [0, 0];
		switch (daBf)
		{	
			case 'rapper-gf-dead':
				cameraOffset[1] = 150;
		}

		camFollow = new FlxPoint(bf.getGraphicMidpoint().x + cameraOffset[0], bf.getGraphicMidpoint().y + cameraOffset[1]);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix, 'shared'));
		Conductor.changeBPM(100);
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
		
		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (controls.ACCEPT)
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

		if (bf.animation.curAnim.name == 'firstDeath')
		{
			if(bf.animation.curAnim.curFrame == 12)
			{
				FlxG.camera.follow(camFollowPos, LOCKON, 1);
				updateCamera = true;
			}

			if (bf.animation.curAnim.finished)
			{
				coolStartDeath();
				bf.startedDeath = true;
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}
	
	function coolStartDeath()
	{
		FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
	}

	override function beatHit()
	{
		super.beatHit();
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
