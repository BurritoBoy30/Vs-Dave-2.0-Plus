package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;

class ComboNumbersState extends MusicBeatState
{
	private var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	private var camTransition:FlxCamera;
	
	public var gf:Girlfriend;
	public var boyfriend:Boyfriend;
	
	override function create()
	{
		FlxG.mouse.visible = true;
		
		camGame = new FlxCamera();
		camTransition = new FlxCamera();
		camTransition.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camTransition, false);
		
		Transition.nextCamera = camTransition;
		
		FlxG.sound.playMusic(Paths.music("goodEnding"),1,true);
		
		Conductor.changeBPM(110);
		
		camGame.zoom = 0.8;
		
		var shittyY:Float = -50;
		
		var bg:BackgroundImg = new BackgroundImg(-600, -200 + shittyY, 'stages/default/stageback', 0.9);
		add(bg);

		var stageFront:BackgroundImg = new BackgroundImg(-650, 600 + shittyY, 'stages/default/stagefront', 0.9, 1.1);
		add(stageFront);

		var stageCurtains:BackgroundImg = new BackgroundImg(-500, -200 + shittyY, 'stages/default/stagecurtains', 1.3, 0.9);
		add(stageCurtains);
		
		gf = new Girlfriend(400, 30, FlxG.save.data.hornyALL ? 'gf-hot' : 'gf');
		add(gf);
		
		boyfriend = new Boyfriend(770, 350, 'bf');
		add(boyfriend);

		super.create();
		
		Transition.nextCamera = camTransition;
	}
	
	override function beatHit()
	{
		super.beatHit();

		if (curBeat % 2 == 0)
		{
			boyfriend.dance();
		}
		gf.dance();
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		super.update(elapsed);
		
		if (controls.BACK)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new OptionsMenu());
		}
	}
}