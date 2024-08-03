package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.ui.FlxUICheckBox;

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
	
	var changeInfoImg:FlxSprite;
	var saveBox:FlxSprite;
	var loadBox:FlxSprite;
	var tailsBox:FlxSprite;
	var hornyGfBG:FlxSprite;
	var hornyGfBOX:FlxUICheckBox;
	
	var saveOffset:Array<Float>;
	var loadOffset:Array<Float>;
	
	var buttonPressed:Bool = false;
	var noTextPop:Bool = false;
	
	var overlay:FlxSprite;
	
	public static var noGfChar:Array<String> = ['bf-with-gf', 'bf-with-cyan', 'gf-player', 'rapper-gf', 'oruta'];
	public static var singleBop:Array<String> = ['skyblue', 'tails-doll'];
	
	public var noMorePresses:Bool = false;
	
	var isTails:Bool = false;
	
	override function create()
	{
		CharacterSelectData.initSave();
		
		boyfriendData = [
			new SelectableChar(['bf', 'bf-christmas', 'bf-pixel'], ["Boyfriend", "Boyfriend (Christmas)", "Boyfriend (Pixel)"]),
			new SelectableChar(['bf-with-gf', 'bf-with-cyan'], ["Boyfriend w/ Girlfriend", "Boyfriend w/ Cyan"]),
			new SelectableChar(['gf-player'], [" Girlfriend (Playable)"]) ,
			new SelectableChar(['rapper-gf'], ["Rapper Girlfriend"]),
			new SelectableChar(['oruta'], ["Oruta"]) 
		];
		
		if (FlxG.save.data.hornyGF && FlxG.save.data.hornyALL)
		{
			girlfriendData = [
				new SelectableChar(['gf-hot', 'gf-hot-funny', 'gf-hot-christmas', 'gf-hot-standing'], ["Hot Girlfriend", "Hot Girlfriend (Sex Mod)", "Hot Girlfriend (Christmas)", "Hot Girlfriend (Standing)"]),
				new SelectableChar(['gf-massive'], ["Massive Girlfriend"]),
				new SelectableChar(['skyblue'], ["Skyblue"])
			];
		}
		else
		{
			girlfriendData = [
				new SelectableChar(['gf', 'gf-christmas', 'gf-standing', 'gf-pixel'], ["Girlfriend", "Girlfriend (Christmas)", "Girlfriend (Standing)", "Girlfriend (Pixel)"]),
				new SelectableChar(['psyka', 'psyka-christmas', 'psyka-standing'], ["Psyka", "Psyka (Christmas)", "Psyka (Standing)"]),
				new SelectableChar(['cyan', 'cyan-christmas'], ["Cyan", "Cyan (Christmas)"])
			];
		}
		
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
		
		changeInfoImg = new FlxSprite(0, 0).loadGraphic(Paths.image('charselect/changeInfo'));
		changeInfoImg.y = FlxG.height - changeInfoImg.height;
		changeInfoImg.antialiasing = true;
		add(changeInfoImg);
		changeInfoImg.cameras = [camHUD];
		
		hornyGfBG = new FlxSprite(FlxG.width - 305, FlxG.height - 105).loadGraphic(Paths.image('charselect/hornygf_bg'));
		hornyGfBG.antialiasing = true;
		add(hornyGfBG);
		hornyGfBG.cameras = [camHUD];
		
		hornyGfBOX = new FlxUICheckBox(hornyGfBG.x + (hornyGfBG.width / 1.5), hornyGfBG.y, Paths.image('charselect/hornygf_box'), Paths.image('charselect/hornygf_boxCheck'), "", 100);
		hornyGfBOX.checked = FlxG.save.data.hornyGF;
		hornyGfBOX.boxAntialias = true;
		add(hornyGfBOX);
		hornyGfBOX.cameras = [camHUD];
		
		hornyGfBG.visible = FlxG.save.data.hornyALL;
		hornyGfBOX.visible = FlxG.save.data.hornyALL;
		
		loadBox = new FlxSprite(hornyGfBG.x, 0).loadGraphic(Paths.image('charselect/loadchar_box'));
		loadBox.antialiasing = true;
		add(loadBox);
		loadBox.cameras = [camHUD];
		
		saveBox = new FlxSprite(loadBox.x, 0).loadGraphic(Paths.image('charselect/savechar_box'));
		saveBox.antialiasing = true;
		add(saveBox);
		saveBox.cameras = [camHUD];
		
		if (!FlxG.save.data.hornyALL)
		{
			loadBox.y = FlxG.height - loadBox.height - 5;
			saveOffset = [110, 82];
			loadOffset = [110, 100];
		}
		else
		{
			loadBox.y = hornyGfBG.y - 43;
			saveOffset = [110, 52];
			loadOffset = [110, 67];
		}
		
		saveBox.y = loadBox.y - loadBox.height - 5;
		
		tailsBox = new FlxSprite(saveBox.x, saveBox.y - saveBox.height - 5).loadGraphic(Paths.image('charselect/tailsdoll_box'));
		tailsBox.antialiasing = true;
		add(tailsBox);
		tailsBox.cameras = [camHUD];
		
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
		
		trace('is not text');
			
		UpdateBF();
		UpdateGF();
		
		trace('is not chars');
	
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		super.update(elapsed);
		
		tailsBox.visible = FlxG.save.data.hornyGF && FlxG.save.data.hornyALL;
		
		if (!selectedCharacter)
		{			
			if (mouseOverButton(saveBox, saveOffset[0], saveOffset[1]))
			{
				saveBox.color = 0xFF878787;
				
				if (FlxG.mouse.justPressed && !buttonPressed)
				{
					isPressed(saveBox);
					if (!noTextPop)
					{
						if (isTails)
						{
							popUpText('Tails Doll is On!');
							FlxG.sound.play(Paths.sound('missnote1'));
						}
						else if (!isTails)
						{
							popUpText('Saved!');
							FlxG.sound.play(Paths.sound('confirmMenu'));
							
							FlxG.save.data.savedBfData = curBF;	
							FlxG.save.data.savedBfFormData = curFormBF;
							FlxG.save.data.savedGfData = curGF;
							FlxG.save.data.savedGfFormData = curFormGF;
						}
					}
				}
			} 
			else
				saveBox.color = FlxColor.WHITE;
			
			if (mouseOverButton(loadBox, loadOffset[0], loadOffset[1]))
			{
				loadBox.color = 0xFF878787;
				
				if (FlxG.mouse.justPressed && !buttonPressed)
				{
					isPressed(loadBox);
					if (!noTextPop)
					{
						if (isTails)
						{
							popUpText('Tails Doll is On!');
							FlxG.sound.play(Paths.sound('missnote1'));
						}
						else if (!isTails)
						{
							popUpText('Loaded!');
							FlxG.sound.play(Paths.sound('confirmMenu'));
							
							curBF = FlxG.save.data.savedBfData;	
							curFormBF = FlxG.save.data.savedBfFormData;
							curGF = FlxG.save.data.savedGfData;
							curFormGF = FlxG.save.data.savedGfFormData;
											
							UpdateBF();
							UpdateGF();	
							updateGfUI();
							trace('fully loaded');
						}
					}
				}
			} else
				loadBox.color = FlxColor.WHITE;
				
			if (mouseOverButton(tailsBox, 110, 41) && tailsBox.visible)
			{
				tailsBox.color = 0xFF878787;
				
				if (FlxG.mouse.justPressed && !buttonPressed)
				{
					isPressed(tailsBox);
					isTails = !isTails;
					
					UpdateGF(isTails);	
					updateGfUI();
				}
			} 
			else
				tailsBox.color = FlxColor.WHITE;
				
			if (FlxG.save.data.hornyALL)
			{
				hornyGfBOX.callback = function()
				{
					if (!isTails)
					{
						FlxG.save.data.hornyGF = !FlxG.save.data.hornyGF;
						updateGfListing();
						UpdateGF();
					}
					else
					{
						popUpText('Tails Doll is On!');
						FlxG.sound.play(Paths.sound('missnote1'));
						hornyGfBOX.checked = true;
					}
				};
			}
			
			if (!noMorePresses)
			{
				if (FlxG.keys.justPressed.LEFT)
					changeBoyfriend(-1);
				if (FlxG.keys.justPressed.RIGHT)
					changeBoyfriend(1);
				
				if (FlxG.keys.justPressed.UP)
					changeBoyfriendForm(-1);
				if (FlxG.keys.justPressed.DOWN)
					changeBoyfriendForm(1);
				
				if (!noGfChar.contains(boyfriendChar.curCharacter))
				{
					if (FlxG.keys.justPressed.A && !isTails)
						changeGirlfriend(-1);
					if (FlxG.keys.justPressed.D && !isTails)
						changeGirlfriend(1);
					
					if (FlxG.keys.justPressed.W && !isTails)
						changeGirlfriendForm(-1);
					if (FlxG.keys.justPressed.S && !isTails)
						changeGirlfriendForm(1);
				}
			}
			
			if (controls.BACK)
				FlxG.switchState(new FreeplayState());
			
			if (FlxG.keys.justPressed.ENTER)
			{
				selectedCharacter = true;
				boyfriendChar.canDance = false;
				girlfriendChar.canDance = false;
				
				var heyAnimation:Bool = boyfriendChar.animation.getByName("hey") != null; 
				boyfriendChar.playAnim(heyAnimation ? 'hey' : 'singUP', true);
				
				if (!noGfChar.contains(boyfriendChar.curCharacter))
				{
					var cheerAnimation:Bool = girlfriendChar.animation.getByName("cheer") != null; 
					girlfriendChar.playAnim(singleBop.contains(girlfriendChar.curCharacter) ? 'singUP' : cheerAnimation ? 'cheer' : 'danceLeft', true);
				}
				
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music('gameOverEnd'));
				FlxG.mouse.visible = false;
				new FlxTimer().start(1.9, endIt);
			}
		}
	}
	
	function mouseOverButton(target:FlxSprite, buttonX:Float, buttonY:Float)
	{
		return (FlxG.mouse.x > target.x + buttonX && FlxG.mouse.x < target.x + target.width + (buttonX * 1.9))
			&& (FlxG.mouse.y > target.y + buttonY && FlxG.mouse.y < target.y + target.height + (buttonY * 1.2) + 3);
	}
	
	override function beatHit()
	{
		super.beatHit();

		if (curBeat % 2 == 0)
		{
			if (boyfriendChar != null)
				boyfriendChar.dance();
		}
		
		if (girlfriendChar != null && curBeat % (singleBop.contains(girlfriendChar.curCharacter) ? 2 : 1) == 0)
			girlfriendChar.dance();
	}
	
	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
	}
	
	function updateGfListing()
	{
		curGF = 0;
		curFormGF = 0;
		
		if (FlxG.save.data.hornyGF)
		{
			girlfriendData = [
				new SelectableChar(['gf-hot', 'gf-hot-funny', 'gf-hot-christmas', 'gf-hot-standing'], ["Hot Girlfriend", "Hot Girlfriend (Sex Mod)", "Hot Girlfriend (Christmas)", "Hot Girlfriend (Standing)"]),
				new SelectableChar(['gf-massive'], ["Massive Girlfriend"]),
				new SelectableChar(['skyblue'], ["Skyblue"])
			];
		}
		else
		{
			girlfriendData = [
				new SelectableChar(['gf', 'gf-christmas', 'gf-standing', 'gf-pixel'], ["Girlfriend", "Girlfriend (Christmas)", "Girlfriend (Standing)", "Girlfriend (Pixel)"]),
				new SelectableChar(['psyka', 'psyka-christmas', 'psyka-standing'], ["Psyka", "Psyka (Christmas)", "Psyka (Standing)"]),
				new SelectableChar(['cyan', 'cyan-christmas'], ["Cyan", "Cyan (Christmas)"])
			];
		}
	}
	
	function updateGfUI()
	{
		girlfriendChar.visible = !noGfChar.contains(boyfriendChar.curCharacter);
		girlfriendText.visible = !noGfChar.contains(boyfriendChar.curCharacter);
		iconGF.visible = !noGfChar.contains(boyfriendChar.curCharacter);
		
		if (noGfChar.contains(boyfriendChar.curCharacter) || isTails) {
			changeInfoImg.loadGraphic(Paths.image('charselect/changeInfoNoGF'));
			changeInfoImg.y = FlxG.height - ((changeInfoImg.height / 2) - 5);
		} else {
			changeInfoImg.loadGraphic(Paths.image('charselect/changeInfo'));
			changeInfoImg.y = FlxG.height - changeInfoImg.height;
		}
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
		updateGfUI();
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
		updateGfUI();
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
	var iconOffseet:Float = 85;
	
	public function UpdateBF()
	{
		noMorePresses = true;
		if (boyfriendChar != null) {
			remove(boyfriendChar);
			iconBF.x -= (boyfriendText.textField.textWidth / 2) + iconOffseet;
		
		}
		boyfriendText.text = boyfriendData[curBF].displayNames[curFormBF];
		iconBF.x += (boyfriendText.textField.textWidth / 2) + iconOffseet;
		
		boyfriendChar = new Boyfriend(770 + shitOffset[0] - (noGfChar.contains(boyfriendData[curBF].names[curFormBF]) ? 200 : 0), 450 + shitOffset[1], boyfriendData[curBF].names[curFormBF]);
		boyfriendChar.x += boyfriendChar.charOffset[0];
		boyfriendChar.y += boyfriendChar.charOffset[1];
		insert(members.indexOf(overlay), boyfriendChar);
		iconBF.playAnimation(boyfriendData[curBF].names[curFormBF]);
		noMorePresses = false;
	}
	
	public function UpdateGF(isTails:Bool = false)
	{
		var displayName:String = '';
		var	name:String = '';
		
		if (isTails)
		{
			displayName = 'Busty Tails Doll';
			name = 'tails-doll';
		}
		else
		{
			displayName = girlfriendData[curGF].displayNames[curFormGF];
			name = girlfriendData[curGF].names[curFormGF];
		}
		
		noMorePresses = true;
		if (girlfriendChar != null) {
			remove(girlfriendChar);
			iconGF.x -= (girlfriendText.textField.textWidth / 2) + iconOffseet;
		}
		
		girlfriendText.text = displayName;
		iconGF.x += (girlfriendText.textField.textWidth / 2) + iconOffseet;
		
		girlfriendChar = new Character(400 + shitOffset[0], 130 + shitOffset[1], name);
		girlfriendChar.x += girlfriendChar.charOffset[0];
		girlfriendChar.y += girlfriendChar.charOffset[1];
		insert(members.indexOf(boyfriendChar), girlfriendChar);
		iconGF.playAnimation(name);
		noMorePresses = false;
	}
		
	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		PlayState.boyfriendOverride = boyfriendData[curBF].names[curFormBF];
		PlayState.girlfriendOverride = isTails ? 'tails-doll' : girlfriendData[curGF].names[curFormGF];
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