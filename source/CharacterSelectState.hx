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
	var noTextPop:Bool = false;
	
	var overlay:FlxSprite;	
	override function create()
	{
		CharacterSelectData.initSave();
		
		boyfriendData = [
			new SelectableChar(['bf', 'bf-christmas', 'bf-pixel'], ["Boyfriend", "Boyfriend (Christmas)", "Boyfriend (Pixel)"])
		];
		
		girlfriendData = [
			new SelectableChar(['gf', 'gf-christmas', 'gf-standing', 'gf-pixel'], ["Girlfriend", "Girlfriend (Christmas)", "Girlfriend (Standing)", "Girlfriend (Pixel)"]),
			new SelectableChar(['psyka', 'psyka-christmas', 'psyka-standing'], ["Psyka", "Psyka (Christmas)", "Psyka (Standing)"]),
			new SelectableChar(['cyan', 'cyan-christmas'], ["Cyan", "Cyan (Christmas)"])
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
		
		boyfriendText = new FlxText(0, 0, FlxG.width, boyfriendData[curBF].displayNames[curFormBF], 16);
		boyfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		boyfriendText.borderSize = 3;
		boyfriendText.antialiasing = true;
		add(boyfriendText);
		boyfriendText.cameras = [camHUD];
		
		girlfriendText = new FlxText(0, boyfriendText.y + boyfriendText.height, FlxG.width, girlfriendData[curGF].displayNames[curFormGF], 16);
		girlfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		girlfriendText.borderSize = 3;
		girlfriendText.antialiasing = true;
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
		
		iconBF = new HealthIcon(boyfriendData[curBF].names[curFormBF], false);
		iconBF.y = boyfriendText.y - 10;
		iconBF.screenCenter(X);
		add(iconBF);
		iconBF.cameras = [camHUD];

		iconGF = new HealthIcon(girlfriendData[curGF].names[curFormGF], false);
		iconGF.y = girlfriendText.y - 10;
		iconGF.screenCenter(X);
		add(iconGF);
		iconGF.cameras = [camHUD];
		
		overlay = new FlxSprite(0, 0).makeGraphic(1, 1);
		overlay.scrollFactor.set();
		add(overlay);	
			
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
			var offset:Float = 10;
			
			if ((FlxG.mouse.x > (saveBox.x - (offset * 21)) && FlxG.mouse.x < saveBox.x + saveBox.width + (offset * -11.5))
				&& (FlxG.mouse.y > (saveBox.y + (offset * 7)) && FlxG.mouse.y < (saveBox.y + saveBox.height + (offset * 8))))
			{
				saveBox.color = 0xFF878787;
				
				if (FlxG.mouse.justPressed && !buttonPressed)
				{
					isPressed(saveBox);
					if (!noTextPop) {
						popUpText('Saved!');
						
						FlxG.save.data.savedBfData = curBF;	
						FlxG.save.data.savedBfFormData = curFormBF;
						FlxG.save.data.savedGfData = curGF;
						FlxG.save.data.savedGfFormData = curFormGF;
					}
				}
			} else {
				saveBox.color = FlxColor.WHITE;
			}
			
			if ((FlxG.mouse.x > (loadBox.x - (offset * 21)) && FlxG.mouse.x < loadBox.x + loadBox.width + (offset * -11.5))
				&& (FlxG.mouse.y > (loadBox.y + (offset * 8)) && FlxG.mouse.y < (loadBox.y + loadBox.height + (offset * 9.5))))
			{
				loadBox.color = 0xFF878787;
				
				if (FlxG.mouse.justPressed && !buttonPressed)
				{
					isPressed(loadBox);
					if (!noTextPop) {
						popUpText('Loaded!');
						
						curBF = FlxG.save.data.savedBfData;	
						curFormBF = FlxG.save.data.savedBfFormData;
						curGF = FlxG.save.data.savedGfData;
						curFormGF = FlxG.save.data.savedGfFormData;
						
						UpdateBF();
						UpdateGF();
						trace('fully loaded');
					}
				}
			} else {
				loadBox.color = FlxColor.WHITE;
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
		}
		
		var singleBop:Array<String> = ['skyblue'];
		
		if (girlfriendChar != null && curBeat % (singleBop.contains(girlfriendChar.curCharacter) ? 2 : 1) == 0)
			girlfriendChar.dance();
	}
	
	function isPressed(target:FlxSprite)
	{
		buttonPressed = true;
		target.scale.set(0.9, 0.9);
		FlxTween.tween(target, {'scale.x': 1, 'scale.y': 1}, 0.1, {onComplete: function(twn:FlxTween)
		{
			buttonPressed = false;
		}});
	}
	
	function popUpText(string:String)
	{
		noTextPop = true;
		var popTxt:FlxText = new FlxText(0, (FlxG.height * 1.25), FlxG.width, string, 16);
		popTxt.setFormat(Paths.font("comic.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		popTxt.borderSize = 3;
		popTxt.antialiasing = true;
		popTxt.alpha = 0;
		add(popTxt);
		popTxt.cameras = [camHUD];
		
		FlxTween.tween(popTxt, {y: FlxG.height - 100, alpha: 1}, 0.2, {onComplete: function(twn:FlxTween)
		{
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				FlxTween.tween(popTxt, {y: (FlxG.height * 1.25), alpha: 0}, 0.5, {onComplete: function(twn:FlxTween)
				{
					popTxt.destroy();
					noTextPop = false;
				}});
			});
		}});
		
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
		var iconOffseet:Float = 85;
		
		if (boyfriendChar != null) {
			remove(boyfriendChar);
			iconBF.x -= (boyfriendText.textField.textWidth / 2) + iconOffseet;
		
		}
		boyfriendText.text = boyfriendData[curBF].displayNames[curFormBF];
		iconBF.x += (boyfriendText.textField.textWidth / 2) + iconOffseet;
		
		boyfriendChar = new Boyfriend(770 + shitOffset[0], 450 + shitOffset[1], boyfriendData[curBF].names[curFormBF]);
		boyfriendChar.x += boyfriendChar.charOffset[0];
		boyfriendChar.y += boyfriendChar.charOffset[1];
		insert(members.indexOf(overlay), boyfriendChar);
		iconBF.playAnimation(boyfriendData[curBF].names[curFormBF]);
	}
	
	public function UpdateGF()
	{
		var iconOffseet:Float = 85;
		
		if (girlfriendChar != null) {
			remove(girlfriendChar);
			iconGF.x -= (girlfriendText.textField.textWidth / 2) + iconOffseet;
		}
		
		girlfriendText.text = girlfriendData[curGF].displayNames[curFormGF];
		iconGF.x += (girlfriendText.textField.textWidth / 2) + iconOffseet;
		
		girlfriendChar = new Character(400 + shitOffset[0], 130 + shitOffset[1], girlfriendData[curGF].names[curFormGF]);
		girlfriendChar.x += girlfriendChar.charOffset[0];
		girlfriendChar.y += girlfriendChar.charOffset[1];
		insert(members.indexOf(boyfriendChar), girlfriendChar);
		iconGF.playAnimation(girlfriendData[curGF].names[curFormGF]);
		
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