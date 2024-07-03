package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

class CharacterSelectState extends MusicBeatState
{
	var boyfriendData:Array<SelectableChar> = [
		new SelectableChar(['bf','bf-christmas','bf-pixel'], ["Boyfriend", "Boyfriend (Christmas)", "Boyfriend (Pixel)"])
	];
	
	var girlfriendData:Array<SelectableChar> = [
		new SelectableChar(['gf','gf-christmas','gf-pixel'], ["Girlfriend", "Girlfriend (Christmas)", "Girlfriend (Pixel)"])
	];
	
	public var curBF:Int = 0;
	public var curFormBF:Int = 0;
	
	public var curGF:Int = 0;
	public var curFormGF:Int = 0;
	
	public var boyfriendChar:Boyfriend;
	public var girlfriendChar:Character;
	
	var boyfriendText:FlxText;
	var girlfriendText:FlxText;
	
	public var iconBF:HealthIcon;
	public var iconGF:HealthIcon;
	
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	
	var selectedCharacter:Bool = false;
	
	override function create()
	{
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxCamera.defaultCameras = [camGame];
		
		FlxG.sound.playMusic(Paths.music("goodEnding"),1,true);
		
		Conductor.changeBPM(110);
		
		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);
	
		var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills_night'));
		stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
		stageHills.updateHitbox();
		stageHills.antialiasing = true;
		stageHills.scrollFactor.set(1, 1);
		stageHills.active = false;
		add(stageHills);
	
		var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate_night'));
		gate.setGraphicSize(Std.int(gate.width * 1.2));
		gate.updateHitbox();
		gate.antialiasing = true;
		gate.scrollFactor.set(0.925, 0.925);
		gate.active = false;
		add(gate);
		
		var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass_night'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront);
		
		camGame.zoom = 0.75;
		
		boyfriendChar = new Boyfriend(670, 370, boyfriendData[curBF].names[curFormBF]);
		add(boyfriendChar);
		
		girlfriendChar = new Character(boyfriendChar.x - 400, boyfriendChar.y - 320, girlfriendData[curGF].names[curFormGF]);
		insert(members.indexOf(boyfriendChar), girlfriendChar);
		
		boyfriendText = new FlxText(0, -20, FlxG.width, boyfriendData[curBF].displayNames[curFormBF], 16);
		boyfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		boyfriendText.borderSize = 2;
		add(boyfriendText);
		boyfriendText.cameras = [camHUD];
		
		girlfriendText = new FlxText(0, boyfriendText.y + boyfriendText.height - 10, FlxG.width, girlfriendData[curGF].displayNames[curFormGF], 16);
		girlfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		girlfriendText.borderSize = 2;
		add(girlfriendText);
		girlfriendText.cameras = [camHUD];
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		super.update(elapsed);
		
		if (!selectedCharacter)
		{
			if (FlxG.keys.justPressed.LEFT)
				changeBoyfriend(-1);
			if (FlxG.keys.justPressed.RIGHT)
				changeBoyfriend(1);
			
			if (FlxG.keys.justPressed.UP)
				changeBoyfriendForm(-1);
			if (FlxG.keys.justPressed.DOWN)
				changeBoyfriendForm(1);
				
			if (FlxG.keys.justPressed.A)
				changeGirlfriend(-1);
			if (FlxG.keys.justPressed.D)
				changeGirlfriend(1);
			
			if (FlxG.keys.justPressed.W)
				changeGirlfriendForm(-1);
			if (FlxG.keys.justPressed.S)
				changeGirlfriendForm(1);
			
			if (controls.BACK)
				FlxG.switchState(new FreeplayState());
			
			if (FlxG.keys.justPressed.ENTER)
			{
				selectedCharacter = true;
				
				var heyAnimation:Bool = boyfriendChar.animation.getByName("hey") != null; 
				boyfriendChar.playAnim(heyAnimation ? 'hey' : 'singUP', true);
				
				var cheerAnimation:Bool = girlfriendChar.animation.getByName("cheer") != null; 
				girlfriendChar.playAnim(cheerAnimation ? 'cheer' : 'danceLeft', true);
				
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music('gameOverEnd'));
				new FlxTimer().start(1.9, endIt);
			}
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		if (boyfriendChar != null && curBeat % 2 == 0)
		{
			boyfriendChar.playAnim('idle', true);
		}
		
		if (girlfriendChar != null)
		{
			girlfriendChar.dance();
		}
	}
	
	function changeBoyfriend(beep:Int = 0)
	{
		curBF += beep;
		curFormBF = 0;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if (curBF < 0)
			curBF = boyfriendData.length - 1;
		if (curBF >= boyfriendData.length)
			curBF = 0;
		
		UpdateBF();
	}
	
	function changeBoyfriendForm(beep:Int = 0)
	{
		curFormBF += beep;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if (curFormBF < 0)
			curFormBF = boyfriendData[curBF].names.length - 1;
		if (curFormBF >= boyfriendData[curBF].names.length)
			curFormBF = 0;
		
		UpdateBF();
	}
	
	public function UpdateBF()
	{
		boyfriendText.text = boyfriendData[curBF].displayNames[curFormBF];
		boyfriendChar.destroy();
		boyfriendChar = new Boyfriend(570, 350, boyfriendData[curBF].names[curFormBF]);
		add(boyfriendChar);
	}
	
	function changeGirlfriend(ahmp:Int = 0)
	{
		curGF += ahmp;
		curFormGF = 0;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if (curGF < 0)
			curGF = girlfriendData.length - 1;
		if (curGF >= girlfriendData.length)
			curGF = 0;
		
		UpdateGF();
	}
	
	function changeGirlfriendForm(ahmp:Int = 0)
	{
		curFormGF += ahmp;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if (curFormGF < 0)
			curFormGF = girlfriendData[curGF].names.length - 1;
		if (curFormGF >= girlfriendData[curGF].names.length)
			curFormGF = 0;
		
		UpdateGF();
	}
	
	public function UpdateGF()
	{
		girlfriendText.text = girlfriendData[curGF].displayNames[curFormGF];
		girlfriendChar.destroy();
		girlfriendChar = new Character(boyfriendChar.x - 400, boyfriendChar.y - 320, girlfriendData[curGF].names[curFormGF]);
		insert(members.indexOf(boyfriendChar), girlfriendChar);
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