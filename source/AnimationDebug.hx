package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;

/**
	*DEBUG MODE
 */
class AnimationDebug extends MusicBeatState
{
	private var camGame:FlxCamera;
	private var camTransition:FlxCamera;
	private var camHUD:FlxCamera;
	
	var gridBG:FlxSprite;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var charLayer:FlxTypedGroup<Character>;
	var curAnim:Int = 0;
	var isDad:Bool = true;
	public var daAnim:String;
	var camFollow:FlxObject;
	
	var UI_box:FlxUITabMenu;
	var characterList:Array<String> = [];
	
	public var bfList:Array<String> = [];
	public var gfList:Array<String> = [];
	public var dadList:Array<String> = [];
	
	public static var cameViaSong:Bool = false;

	public function new(daAnim:String = 'bf')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();
		FlxG.mouse.visible = true;
		
		camGame = new FlxCamera();
		camTransition = new FlxCamera();
		camTransition.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camTransition);
		
		FlxCamera.defaultCameras = [camGame];
		
		camGame.zoom = 1;
		
		Transition.nextCamera = camTransition;
	
		bfList = CoolUtil.coolTextFile(Paths.txt('boyfriendList'));
		gfList = CoolUtil.coolTextFile(Paths.txt('girlfriendList'));
		dadList = CoolUtil.coolTextFile(Paths.txt('dadList'));

		gridBG = FlxGridOverlay.create(10, 10, FlxG.width * 4, FlxG.height * 4);
		gridBG.x = -(FlxG.width * 1.5);
		gridBG.y = -(FlxG.height * 1.5);
		gridBG.scrollFactor.set();
		add(gridBG);
		
		charLayer = new FlxTypedGroup<Character>();
		add(charLayer);
		
		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
		FlxG.camera.follow(camFollow);

		loadChar(daAnim);

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);
		dumbTexts.cameras = [camHUD];
		
		textAnim = new FlxText(-320, 20, FlxG.width, '', 16);
		textAnim.size = 26;
		textAnim.alignment = RIGHT;
		textAnim.borderStyle = OUTLINE;
		textAnim.borderColor = FlxColor.BLACK;
		textAnim.borderSize = 2;
		textAnim.scrollFactor.set();
		add(textAnim);
		textAnim.cameras = [camHUD];

		genBoyOffsets();
		
		UI_box = new FlxUITabMenu(null, [{name: "Stuff", label: 'Stuff'}], true);
		UI_box.resize(250, 100);
		UI_box.x = (FlxG.width / 2) + 350;
		UI_box.y = 20;
		UI_box.scrollFactor.set();
		add(UI_box);
		
		addStuffUI();
		
		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
		FlxG.camera.follow(camFollow);
		
		camFollow.setPosition(char.getMidpoint().x, char.getMidpoint().y);

		super.create();
		
		Transition.nextCamera = camTransition;
	}
	
	var curCharDropDown:FlxUIDropDownMenu;
	function addStuffUI():Void
	{
		var tab_stuff_song = new FlxUI(null, UI_box);
		tab_stuff_song.name = "Stuff";
		
		var check_flip_x = new FlxUICheckBox(10, 40, null, null, "Flip X", 40);
		check_flip_x.checked = false;
		check_flip_x.callback = function()
		{
			char.flipX = !char.flipX;
		};
		
		curCharDropDown = new FlxUIDropDownMenu(10, 10, FlxUIDropDownMenu.makeStrIdLabelArray([''], true), function(character:String)
		{
			daAnim = characterList[Std.parseInt(character)];
			reloadCharacterDropDown();
		});
		curCharDropDown.selectedLabel = daAnim;
		
		var loadChar:FlxButton = new FlxButton(150, 10, "Reload", function()
		{
			loadChar(daAnim);
			camFollow.setPosition(char.getMidpoint().x, char.getMidpoint().y);
			genBoyOffsets();
			reloadCharacterDropDown();
		});
		reloadCharacterDropDown();
	
		tab_stuff_song.add(check_flip_x);
		tab_stuff_song.add(loadChar);
		tab_stuff_song.add(curCharDropDown);

		UI_box.addGroup(tab_stuff_song);
	}

	function genBoyOffsets()
	{
		var daLoop:Int = 0;
		
		var i:Int = dumbTexts.members.length-1;
		while(i >= 0) {
			var memb:FlxText = dumbTexts.members[i];
			if(memb != null) {
				memb.kill();
				dumbTexts.remove(memb);
				memb.destroy();
			}
			--i;
		}
		dumbTexts.clear();
		
		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			daLoop++;
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.E)
			camGame.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			camGame.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			var laVelocidad:Float = 90 * 3.5;
			
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -laVelocidad;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = laVelocidad;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -laVelocidad;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = laVelocidad;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}
		
		if (char.animationsArray.length > 0)
		{
			if (FlxG.keys.justPressed.W)
			{
				curAnim -= 1;
			}

			if (FlxG.keys.justPressed.S)
			{
				curAnim += 1;
			}
			
			if (curAnim < 0)
				curAnim = char.animationsArray.length - 1;

			if (curAnim >= char.animationsArray.length)
				curAnim = 0;
		
			if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W)
			{	
				char.playAnim(char.animationsArray[curAnim], true);
				genBoyOffsets();
			}
			textAnim.text = char.animation.curAnim.name;
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(char.animationsArray[curAnim], true);
		}
		
		if (controls.BACK)
		{
			FlxG.mouse.visible = false;
			
			if (cameViaSong)
			{
				cameViaSong = false;
				FlxG.switchState(new PlayState());
			}
			else
			{	
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.switchState(new MainMenuState());
			}
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var multiplier:Float = 1;
		if (FlxG.keys.pressed.SHIFT)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			if (upP)
				addOffsetToChar(1, 1 * multiplier);
			if (downP)
				addOffsetToChar(1, -1 * multiplier);
			if (leftP)
				addOffsetToChar(0, 1 * multiplier);
			if (rightP)
				addOffsetToChar(0, -1 * multiplier);
		}
		
		super.update(elapsed);
	}

	function loadChar(daDude:String = 'bf')
	{
		var i:Int = charLayer.members.length-1;
		while(i >= 0) {
			var memb:Character = charLayer.members[i];
			if(memb != null) {
				memb.kill();
				charLayer.remove(memb);
				memb.destroy();
			}
			--i;
		}
		charLayer.clear();
		
		// i fucked myself so i gotta do this instead
		var charType:String = '';
		
		if (dadList.contains(daDude))
		{
			charType = 'dad';
		}
		else if (gfList.contains(daDude))
		{
			charType = 'gf';
		}
		else if (bfList.contains(daDude))
		{
			charType = 'bf';
		}

		char = new Character(0, 0, daDude, charType);
		if(char.animationsArray != null) {
			char.playAnim(char.animationsArray[0], true);
		}
		char.screenCenter();
		char.debugMode = true;
		charLayer.add(char);
		char.setPosition(char.charOffset[0], char.charOffset[1]);
	}
	
	function reloadCharacterDropDown()
	{
		characterList = [];
		for (i in 0...bfList.length)
		{
			characterList.push(bfList[i]);
		}
		for (i in 0...gfList.length)
		{
			characterList.push(gfList[i]);
		}
		for (i in 0...dadList.length)
		{
			characterList.push(dadList[i]);
		}
		curCharDropDown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(characterList, true));
		curCharDropDown.selectedLabel = daAnim;
		curAnim = 0;
	}
	
	
	function addOffsetToChar(layer:Int, offset:Float)
	{		
		char.animOffsets.get(char.animationsArray[curAnim])[layer] += offset;
		genBoyOffsets();
		char.playAnim(char.animationsArray[curAnim], true);
	}
}
