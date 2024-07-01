package;

import flixel.FlxG;

class CharacterSelectState extends MusicBeatState
{
	var boyfriendData:Array<SelectableChar> = [
		new SelectableChar(['bf','bf-christmas','bf-pixel'], ["Boyfriend", "Boyfriend (Christmas)", "Boyfriend (Pixel)"])
	];
	
	public var curBF:Int = 0;
	public var curFormBF:Int = 0;
	
	public var boyfriend:Boyfriend;
	
	var boyfriendText:FlxText;
	public var iconBF:HealthIcon;
	public var camHUD:FlxCamera;
	
	var selectedCharacter:Bool = false;
	
	override function create()
	{
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);
		
		FlxG.sound.playMusic(Paths.music("goodEnding"),1,true);
		
		FlxG.camera.zoom = 0.75;
				
		boyfriend = new Boyfriend(770, 450, boyfriendData[curBF].names[curFormBF]);
		add(boyfriend);
		
		boyfriendText = new FlxText(0, 0, FlxG.width, boyfriendData[curBF].displayNames[curFormBF], 16);
		boyfriendText.setFormat(Paths.font("comic.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		add(boyfriendText);
		boyfriendText.cameras = [camHUD];
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		super.update(elapsed);
		
		if (!selectedCharacter)
		{
			selectedCharacter = true;
			var heyAnimation:Bool = char.animation.getByName("hey") != null; 
			char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new FlxTimer().start(1.9, endIt);
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		if (boyfriend != null && curBeat % 2 == 0)
		{
			boyfriend.playAnim('idle', true);
		}
	}
	
	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		PlayState.boyfriendOverride = boyfriendData[curBF].names[curFormBF];
		LoadingState.loadAndSwitchState(new PlayState());
	}
}

class SelectableChar
{
	public var names:Array<String>;
	public var displayNames:Array<String>;

	public function new(namesData:Array<String>, displayNamesData:Array<String>)
	{
		names = namesData;
		displayNames = displayNamesData;
	}
}