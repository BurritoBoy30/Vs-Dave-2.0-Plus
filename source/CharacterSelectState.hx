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
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

// all code here is all made by me
// t5mpler pls dont kill me
class CharacterSelectState extends MusicBeatState
{
	var boyfriendData:Array<SelectableChar> = [];
	var girlfriendData:Array<SelectableChar> = [];
	
	public var curBF:Int = 0;
	public var curFormBF:Int = 0;
	
	public var curGF:Int = 0;
	public var curFormGF:Int = 0;
	
	public var boyfriendChar:Boyfriend;
	public var girlfriendChar:Girlfriend;
	
	var boyfriendText:FlxText;
	var girlfriendText:FlxText;
	
	public var iconBF:HealthIcon;
	public var iconGF:HealthIcon;
	
	private var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	private var camTransition:FlxCamera;
	
	var selectedCharacter:Bool = false;
	
	var changeInfoImg:FlxSprite;
	
	var saveBox:UIButton;
	var loadBox:UIButton;
	var tailsBox:UIButton;
	
	var hornyGfBG:FlxSprite;
	var hornyGfBOX:FlxUICheckBox;
	
	var saveOffset:Array<Float>;
	var loadOffset:Array<Float>;
	
	var buttonPressed:Bool = false;
	var noTextPop:Bool = false;
	
	var overlay:FlxSprite;
	
	public static var noGfChar:Array<String> = ['bf-with-gf', 'bf-with-cyan', 'gf-player', 'rapper-gf', 'oruta'];
	public static var singleBop:Array<String> = ['skyblue', 'tails-doll', 'gefe-twerk'];
	public static var hornyGFs:Array<String> = ['gf-hot', 'gf-hot-funny', 'gf-hot-christmas', 'gf-hot-standing', 'gf-massive',
		'three-gfs', 'gf-trepidation', 'skyblue', 'tails-doll', 'gefe', 'gefe-busty', 'gefe-twerk'];
	
	public var noMorePresses:Bool = false;
	
	var isTails:Bool = false;
	public var buttonNumber:Float = 0;
	public var previewMode:Bool = false;
	
	override function create()
	{
		CharacterSelectData.initSave();
		
		boyfriendData = [
			new SelectableChar(['bf', 'bf-christmas', 'bf-pixel']),
			new SelectableChar(['bf-with-gf', 'bf-with-cyan']),
			new SelectableChar(['chris', 'chris-christmas']),
			new SelectableChar(['gf-player']),
			new SelectableChar(['rapper-gf'])
		];
		
		if (FlxG.save.data.hornyGF && FlxG.save.data.hornyALL)
			boyfriendData.push(new SelectableChar(['oruta']));
			
		loadGirlfriendListing(FlxG.save.data.hornyGF && FlxG.save.data.hornyALL);
		
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
		
		var bg:BackgroundImg = new BackgroundImg(-600, -200, 'stages/sky_night', 0.7);
		add(bg);
		
		var stageHills:BackgroundImg = new BackgroundImg(-834, -159, 'stages/house/night/hills');
		add(stageHills);
		
		var grassbg:BackgroundImg = new BackgroundImg(-1205, 580, 'stages/house/night/grass bg');
		add(grassbg);
		
		var gate:BackgroundImg = new BackgroundImg(-755, 250, 'stages/house/night/gate');
		add(gate);
		
		var stageFront:BackgroundImg = new BackgroundImg(-832, 505, 'stages/house/night/grass');
		add(stageFront);

		camGame.zoom = 0.75;
		
		boyfriendText = new FlxText(-70, 0, FlxG.width, boyfriendData[curBF].displayNames[curFormBF], 16);
		boyfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		boyfriendText.borderSize = 3;
		boyfriendText.antialiasing = FlxG.save.data.antiAliasing;
		add(boyfriendText);
		boyfriendText.cameras = [camHUD];
		
		girlfriendText = new FlxText(-70, boyfriendText.y + boyfriendText.height, FlxG.width, girlfriendData[curGF].displayNames[curFormGF], 16);
		girlfriendText.setFormat(Paths.font("comic.ttf"), 75, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		girlfriendText.borderSize = 3;
		girlfriendText.antialiasing = FlxG.save.data.antiAliasing;
		add(girlfriendText);
		girlfriendText.cameras = [camHUD];
		
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
		
		changeInfoImg = new FlxSprite(0, 0).loadGraphic(Paths.image('charselect/' + FlxG.save.data.gameLanguage + '/changeInfo'));
		changeInfoImg.y = FlxG.height - changeInfoImg.height;
		changeInfoImg.antialiasing = FlxG.save.data.antiAliasing;
		add(changeInfoImg);
		changeInfoImg.cameras = [camHUD];
		
		hornyGfBG = new FlxSprite(FlxG.width - 305, FlxG.height - 105).loadGraphic(Paths.image('charselect/' + FlxG.save.data.gameLanguage + '/hornygf_bg'));
		hornyGfBG.antialiasing = FlxG.save.data.antiAliasing;
		add(hornyGfBG);
		hornyGfBG.cameras = [camHUD];
		
		hornyGfBOX = new FlxUICheckBox(hornyGfBG.x + (hornyGfBG.width / 1.5), hornyGfBG.y, Paths.image('charselect/hornygf_box'), Paths.image('charselect/hornygf_boxCheck'), "", 100);
		hornyGfBOX.callback = function()
		{
			getHorny();
		};
		hornyGfBOX.checked = FlxG.save.data.hornyGF;
		hornyGfBOX.boxAntialias = true;
		add(hornyGfBOX);
		hornyGfBOX.cameras = [camHUD];
		
		hornyGfBG.visible = FlxG.save.data.hornyALL;
		hornyGfBOX.visible = FlxG.save.data.hornyALL;
		
		if (!FlxG.save.data.hornyALL)
		{
			saveOffset = [110, 82];
			loadOffset = [110, 100];
		}
		else
		{
			saveOffset = [110, 52];
			loadOffset = [110, 67];
		}
		
		loadBox = new UIButton(hornyGfBG.x, 0, loadOffset, 'charselect/' + FlxG.save.data.gameLanguage + '/loadchar_box', load);
		if (!FlxG.save.data.hornyALL)
			loadBox.y = FlxG.height - loadBox.height - 5;
		else
			loadBox.y = hornyGfBG.y - 43;
		add(loadBox);
		loadBox.cameras = [camHUD];
		
		saveBox = new UIButton(loadBox.x, 0, saveOffset, 'charselect/' + FlxG.save.data.gameLanguage + '/savechar_box', save);
		saveBox.y = loadBox.y - loadBox.height - 5;
		add(saveBox);
		saveBox.cameras = [camHUD];
		
		tailsBox = new UIButton(saveBox.x, saveBox.y - saveBox.height - 5, [110, 41], 'charselect/tailsdoll_box', loadTailsDoll);
		add(tailsBox);
		tailsBox.cameras = [camHUD];
		
		overlay = new FlxSprite(0, 0).makeGraphic(1, 1);
		overlay.scrollFactor.set();
		add(overlay);
		
		UpdateBF();
		UpdateGF();
		
		super.create();
		
		Transition.nextCamera = camTransition;
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		super.update(elapsed);
		
		tailsBox.visible = FlxG.save.data.hornyGF && FlxG.save.data.hornyALL && !noGfChar.contains(boyfriendChar.curCharacter);
		girlfriendChar.visible = !noGfChar.contains(boyfriendChar.curCharacter);
		
		if (!selectedCharacter)
		{
			if (FlxG.keys.justPressed.P)
			{
				previewMode = !previewMode;
				
				if (!previewMode)
				{
					if (!boyfriendChar.canDance) {
						boyfriendChar.canDance = true;
						boyfriendChar.dance();
					}
					if (!girlfriendChar.canDance) {
						if (gfString()) {
							girlfriendChar.canDance = true;
							girlfriendChar.dance();
						}
					}
				}
			}
				
			camHUD.visible = !previewMode;
				
			if (previewMode)
			{					
				if (controls.LEFT_P)
					charAnim('singLEFT');
				if (controls.DOWN_P)
					charAnim('singDOWN');
				if (controls.UP_P)
					charAnim('singUP');
				if (controls.RIGHT_P)
					charAnim('singRIGHT');
				
				if (FlxG.keys.justPressed.SPACE)
				{
					boyfriendChar.canDance = true;
					boyfriendChar.dance();
					if (gfString()) {
						girlfriendChar.canDance = true;
						girlfriendChar.dance();
					}
				}
			}
			else
			{	
				if (!noMorePresses)
				{
					if (FlxG.keys.justPressed.LEFT)
						changeBoyfriend(-1);
					if (FlxG.keys.justPressed.RIGHT)
						changeBoyfriend(1);
					
					if (boyfriendData[curBF].names.length > 1)
					{
						if (FlxG.keys.justPressed.UP)
							changeBoyfriendForm(-1);
						if (FlxG.keys.justPressed.DOWN)
							changeBoyfriendForm(1);
					}
					
					if (!noGfChar.contains(boyfriendChar.curCharacter))
					{
						if (FlxG.keys.justPressed.A && !isTails)
							changeGirlfriend(-1);
						if (FlxG.keys.justPressed.D && !isTails)
							changeGirlfriend(1);
						
						if (girlfriendData[curGF].names.length > 1)
						{
							if (FlxG.keys.justPressed.W && !isTails)
								changeGirlfriendForm(-1);
							if (FlxG.keys.justPressed.S && !isTails)
								changeGirlfriendForm(1);
						}
					}
				}
				
				if (controls.BACK)
				{	
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					FlxG.switchState(new FreeplayState());
				}
					
				if (FlxG.keys.justPressed.R)
				{
					curBF = 0;	
					curFormBF = 0;
					curGF = 0;
					curFormGF = 0;

					UpdateBF();
					UpdateGF();	
					updateGfUI();
				}
				
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
						girlfriendChar.playAnim(singleBop.contains(girlfriendChar.curCharacter) ? 'singUP' : cheerAnimation ? 'cheer' : (girlfriendChar.curCharacter == 'gf-trepidation') ? 'danceLeft1' : 'danceLeft', true);
					}
					
					FlxG.sound.music.stop();
					FlxG.sound.play(Paths.music('gameOverEnd'));
					FlxG.mouse.visible = false;
					new FlxTimer().start(1.9, endIt);
				}
			}
		}
	}
	
	function gfString()
	{
		return Character.tutorialGFs.contains(girlfriendChar.curCharacter);
	}
	
	function charAnim(anim:String)
	{
		boyfriendChar.canDance = false;
		boyfriendChar.playAnim(anim, true);
		if (gfString()) {
			girlfriendChar.canDance = false;
			girlfriendChar.playAnim(anim, true);
		}
	}
	
	function save()
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
	
	function load()
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
	
	function loadTailsDoll()
	{
		if (tailsBox.visible)
		{
			isPressed(tailsBox);
			isTails = !isTails;
		
			UpdateGF(isTails);	
			updateGfUI();
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
		
		if (girlfriendChar != null && curBeat % (singleBop.contains(girlfriendChar.curCharacter) ? 2 : 1) == 0)
			girlfriendChar.dance();
	}
	
	function getHorny()
	{
		if (FlxG.save.data.hornyALL)
		{
			if (!isTails)
			{
				FlxG.save.data.hornyGF = !FlxG.save.data.hornyGF;
				curGF = 0;
				curFormGF = 0;
		
				loadGirlfriendListing(FlxG.save.data.hornyGF);
				UpdateGF();
			}
			else
			{
				popUpText('Tails Doll is On!');
				FlxG.sound.play(Paths.sound('missnote1'));
				hornyGfBOX.checked = true;
			}
		}
	}
	
	function loadGirlfriendListing(isHorny:Bool = false)
	{
		if (isHorny)
		{
			girlfriendData = [
				new SelectableChar(['gf-hot', 'gf-hot-funny', 'gf-hot-christmas', 'gf-hot-standing']),
				new SelectableChar(['gefe', 'gefe-busty', 'gefe-twerk']),
				new SelectableChar(['gf-massive']),
				new SelectableChar(['three-gfs']),
				new SelectableChar(['gf-trepidation']),
				new SelectableChar(['skyblue'])
			];
		}
		else
		{
			girlfriendData = [
				new SelectableChar(['gf', 'gf-christmas', 'gf-standing', 'gf-pixel']),
				new SelectableChar(['psyka', 'psyka-christmas', 'psyka-standing']),
				new SelectableChar(['cyan', 'cyan-christmas']),
				new SelectableChar(['kaity', 'kaity-christmas'])
			];
		}
	}
	
	function updateGfUI()
	{
		girlfriendText.visible = !noGfChar.contains(boyfriendChar.curCharacter);
		iconGF.visible = !noGfChar.contains(boyfriendChar.curCharacter);
		
		if (noGfChar.contains(boyfriendChar.curCharacter) || isTails) {
			changeInfoImg.loadGraphic(Paths.image('charselect/' + FlxG.save.data.gameLanguage + '/changeInfoNoGF'));
			changeInfoImg.y = FlxG.height - ((changeInfoImg.height / 2) + 23);
		} else {
			changeInfoImg.loadGraphic(Paths.image('charselect/' + FlxG.save.data.gameLanguage + '/changeInfo'));
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
		popTxt.antialiasing = FlxG.save.data.antiAliasing;
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
	
	var iconOffseet:Float = 15;
	var shitOffset:Array<Float> = [-130, -60];
	
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
		iconBF.createIcon(boyfriendChar.healthIcon);
		noMorePresses = false;
	}
	
	public function UpdateGF(isTails:Bool = false)
	{
		var displayName:String = '';
		var	name:String = '';
		
		if (isTails)
		{
			name = 'tails-doll';
			displayName = ReturnLanguage.getLine(name);
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
		
		girlfriendChar = new Girlfriend(400 + shitOffset[0], 130 + shitOffset[1], name);
		girlfriendChar.x += girlfriendChar.charOffset[0];
		girlfriendChar.y += girlfriendChar.charOffset[1];
		insert(members.indexOf(boyfriendChar), girlfriendChar);
		iconGF.createIcon(girlfriendChar.healthIcon);
		noMorePresses = false;
	}
		
	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		PlayState.girlfriendOverride = "none";
		PlayState.SONG.player1 = boyfriendData[curBF].names[curFormBF];
		PlayState.girlfriendOverride = isTails ? 'tails-doll' : girlfriendData[curGF].names[curFormGF];
		LoadingState.loadAndSwitchState(new PlayState());
	}
}

class SelectableChar
{
	public var names:Array<String> = [];
	public var displayNames:Array<String> = [];

	public function new(namesData:Array<String>)
	{
		names = namesData;
		for (i in 0...namesData.length)
		{
			displayNames.push(ReturnLanguage.getLine(namesData[i]));
		}
	}
}

class UIButton extends FlxSprite
{
	var buttonAxis:Array<Float>;
	var callback:Void -> Void;

	public function new (x:Float, y:Float, notButtonAxis:Array<Float>, buttonImg:String, callBack:Void -> Void)
	{
		super(x,y);
		
		loadGraphic(Paths.image(buttonImg, 'shared'));
		antialiasing = FlxG.save.data.antiAliasing;
		
		buttonAxis = notButtonAxis;
		
		callback = callBack;
	}
	
	function mouseOverButton(buttonX:Float, buttonY:Float)
	{
		return (FlxG.mouse.x > x + buttonX && FlxG.mouse.x < x + width + (buttonX * 1.9))
			&& (FlxG.mouse.y > y + buttonY && FlxG.mouse.y < y + height + (buttonY * 1.2) + 3);
	}
	
	override function update(elapsed:Float)
	{		
		super.update(elapsed);
		
		if (mouseOverButton(buttonAxis[0], buttonAxis[1]))
		{
			color = 0xFF878787;
			
			if (FlxG.mouse.justPressed)
			{
				if (callback != null)
					callback();
			}
		}
		else
		{
			color = FlxColor.WHITE;
		}
	}
}