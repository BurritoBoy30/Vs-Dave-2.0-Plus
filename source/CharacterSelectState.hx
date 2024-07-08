package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class CharacterSelectState extends MusicBeatState
{
	var boyfriendData:Array<SelectableChar> = [];
	
	var girlfriendData:Array<SelectableChar> = [];
	
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
	
	var saveBox:FlxSprite;
	var loadBox:FlxSprite;
	
	var buttonPressed:Bool = false;
	
	override function create()
	{		
		boyfriendData = [
			new SelectableChar(['bf','bf-christmas','bf-pixel'], ["Boyfriend", "Boyfriend (Christmas)", "Boyfriend (Pixel)"])
		];
		
		girlfriendData = [
			new SelectableChar(['gf','gf-christmas','gf-pixel'], ["Girlfriend", "Girlfriend (Christmas)", "Girlfriend (Pixel)"])
		];
		
		FlxG.mouse.visible = true;
		
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
		
		boyfriendText = new FlxText(0, -20, FlxG.width, boyfriendData[curBF].displayNames[curFormBF], 16);
		boyfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		boyfriendText.borderSize = 5;
		add(boyfriendText);
		boyfriendText.cameras = [camHUD];
		
		girlfriendText = new FlxText(0, boyfriendText.y + boyfriendText.height - 10, FlxG.width, girlfriendData[curGF].displayNames[curFormGF], 16);
		girlfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		girlfriendText.borderSize = 5;
		add(girlfriendText);
		girlfriendText.cameras = [camHUD];
		
		var changeInfoImg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('charselect/changeInfo'));
		changeInfoImg.antialiasing = true;
		add(changeInfoImg);
		changeInfoImg.cameras = [camHUD];
		
		saveBox = new FlxSprite(5, FlxG.height - 150).loadGraphic(Paths.image('charselect/savechar_box'));
		saveBox.antialiasing = true;
		add(saveBox);
		saveBox.cameras = [camHUD];
		
		loadBox = new FlxSprite(5, saveBox.y + saveBox.height + 5).loadGraphic(Paths.image('charselect/loadchar_box'));
		loadBox.antialiasing = true;
		add(loadBox);
		loadBox.cameras = [camHUD];
	
		UpdateBF();
		UpdateGF();
	
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		super.update(elapsed);
		
		if (!selectedCharacter)
		{
			if (FlxG.mouse.x > -100 && FlxG.mouse.x < (5 + saveBox.width - 100))
			{
				saveBox.color = 0xFF878787;
				
				if (FlxG.mouse.justPressed && !buttonPressed)
				{
					buttonPressed = true;
					saveBox.scale.set(0.9, 0.9);
					FlxTween.tween(saveBox, {'scale.x': 1, 'scale.y': 1}, 0.5, {onComplete: function(twn:FlxTween)
					{
						buttonPressed = false;
					}});
				}
			}
			else
			{
				saveBox.color = FlxColor.WHITE;
			}
			
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
				FlxG.mouse.visible = false;
				new FlxTimer().start(1.9, endIt);
			}
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		
		if (curBeat % 2 == 0)
		{
			if (boyfriendChar != null)
				boyfriendChar.dance();
			
			if (girlfriendChar != null)
				girlfriendChar.dance();
		}
	}
	
	function updateButton(target:FlxSprite)
	{
		if (FlxG.mouse.overlaps(target))
		{
			target.color = 0xFF878787;
			
			if (FlxG.mouse.justPressed)
			{
				target.scale.set(0.9, 0.9);
				FlxTween.tween(target, {'scale.x': 1, 'scale.y': 1}, 0.5, {ease: FlxEase.quadOut});
			}
		}
		else
		{
			target.color = FlxColor.WHITE;
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
	
	var shitOffset:Array<Float> = [-130, -60];
	
	public function UpdateBF()
	{
		boyfriendText.text = boyfriendData[curBF].displayNames[curFormBF];
		
		if (boyfriendChar != null)
			boyfriendChar.destroy();
		
		boyfriendChar = new Boyfriend(770 + shitOffset[0], 450 + shitOffset[1], boyfriendData[curBF].names[curFormBF]);
		boyfriendChar.x += boyfriendChar.charOffset[0];
		boyfriendChar.y += boyfriendChar.charOffset[1];
		add(boyfriendChar);
	}
	
	public function UpdateGF()
	{
		girlfriendText.text = girlfriendData[curGF].displayNames[curFormGF];
		
		if (girlfriendChar != null)
			girlfriendChar.destroy();
			
		girlfriendChar = new Character(400 + shitOffset[0], 130 + shitOffset[1], girlfriendData[curGF].names[curFormGF]);
		girlfriendChar.x += girlfriendChar.charOffset[0];
		girlfriendChar.y += girlfriendChar.charOffset[1];
		insert(members.indexOf(boyfriendChar), girlfriendChar);
	}
		
	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		PlayState.boyfriendOverride = boyfriendData[curBF].names[curFormBF];
		PlayState.girlfriendOverride = girlfriendData[curGF].names[curFormGF];
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