package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

class DispenserBurstState extends MusicBeatState
{
	public var bluDispenserBitch:FlxSprite;
	public var redDispenserBitch:FlxSprite;
	
	var bitchColor:String = 'blu';
	var bitchSize:Float = 1;
	//1, 2, 3
	var bitchType:String = "none";
	// none, red-blu, blu-red
	
	var buttonRed:Button;
	var buttonBlu:Button;
	
	var button1:Button;
	var button2:Button;
	var button3:Button;
	
	var buttonRedBlu:Button;
	var buttonBluRed:Button;
	
	var bitchFps:Int = 40;
	
	public var buttonNumber:Float = 0;
		
	override function create()
	{	
		FlxG.sound.playMusic(Paths.music('burstByKO3', 'shared'), 1, true);

		Conductor.changeBPM(150);
		
		bluDispenserBitch = new FlxSprite();
		bluDispenserBitch.frames = Paths.getSparrowAtlas('hornyshit/dispenser/none/size' + bitchSize + '_blu', 'shared');
		bluDispenserBitch.animation.addByIndices('danceLeft', "size" + bitchSize + '_blu idle', [28, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12], "", bitchFps, false);
		bluDispenserBitch.animation.addByIndices('danceRight', "size" + bitchSize + '_blu idle', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", bitchFps, false);
		bluDispenserBitch.screenCenter();
		bluDispenserBitch.scale.set(0.85, 0.85);
		bluDispenserBitch.antialiasing = FlxG.save.data.antiAliasing;
		add(bluDispenserBitch);
		
		redDispenserBitch = new FlxSprite();
		redDispenserBitch.frames = Paths.getSparrowAtlas('hornyshit/dispenser/none/size' + bitchSize + '_red', 'shared');
		redDispenserBitch.animation.addByIndices('danceLeft', "size" + bitchSize + '_red idle', [28, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12], "", bitchFps, false);
		redDispenserBitch.animation.addByIndices('danceRight', "size" + bitchSize + '_red idle', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", bitchFps, false);
		redDispenserBitch.screenCenter();
		redDispenserBitch.scale.set(0.85, 0.85);
		redDispenserBitch.antialiasing = FlxG.save.data.antiAliasing;
		add(redDispenserBitch);
		redDispenserBitch.visible = false;	
		
		bluDispenserBitch.animation.play('danceLeft', true);
		redDispenserBitch.animation.play('danceLeft', true);
		
		buttonBlu = new Button(bluDispenserBitch.width * 1.34, 10, 'blue_button', function()
		{
			changeBitchColor('blu');
		});
		add(buttonBlu);
		
		buttonRed = new Button(buttonBlu.x, buttonBlu.height + buttonBlu.y + 20, 'red_button', function(){changeBitchColor('red');});
		add(buttonRed);
		
		buttonBluRed = new Button(buttonBlu.x + buttonBlu.width + 10, buttonBlu.y, 'blue-red_typeButton', function(){changeBitchType('blu-red');});
		add(buttonBluRed);
		
		buttonRedBlu = new Button(buttonBluRed.x, buttonBluRed.y + buttonBluRed.height + 20, 'red-blue_typeButton', function(){changeBitchType('red-blu');});
		add(buttonRedBlu);
		
		button1 = new Button(196, 10, '1_button', function(){changeBitchSize(1);});
		add(button1);
		
		button2 = new Button(button1.x, button1.height + button1.y + 20, '2_button', function(){changeBitchSize(2);});
		add(button2);
		
		button3 = new Button(button2.x, button2.height + button2.y + 20, '3_button', function(){changeBitchSize(3);});
		add(button3);

		super.create();
	}
	
	var danced:Bool = false;
	
	override function beatHit()
	{
		super.beatHit();
		
		danced = !danced;
		
		redDispenserBitch.animation.play(danced ? 'danceRight' : 'danceLeft', true);
		bluDispenserBitch.animation.play(danced ? 'danceRight' : 'danceLeft', true);
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
		
		if (controls.BACK)
		{	
			FlxG.switchState(new ConsoleState());
		}
	}
	
	function changeBitchColor(cor:String)
	{
		var curColor:String = '';
		curColor = cor;
		
		if (bitchColor != curColor)
		{
			bluDispenserBitch.visible = curColor == 'blu';
			redDispenserBitch.visible = curColor == 'red';
			bitchColor = curColor;
			if (bitchType != 'none')
			{
				bitchType = 'none';
				reloadBitches();
			}
		}
	}
	
	function changeBitchType(type:String)
	{
		if (bitchType != type)
		{
			bitchType = type;
			bitchColor = 'mixed';
			bluDispenserBitch.visible = true;
			redDispenserBitch.visible = true;
			reloadBitches();
		}
	}
	
	function changeBitchSize(size:Float)
	{
		if (bitchSize != size)
		{
			bitchSize = size;
			reloadBitches();
		}
	}
	
	function reloadBitches()
	{
		var blufolder:String;
		var redfolder:String;
		
		if (bitchType == 'red-blu')
		{
			blufolder = 'half-left';
			redfolder = 'half-right';
		}
		else if (bitchType == 'blu-red')
		{
			blufolder = 'half-right';
			redfolder = 'half-left';
		}
		else
		{
			blufolder = 'none';
			redfolder = 'none';
		}
		bluDispenserBitch.frames = Paths.getSparrowAtlas('hornyshit/dispenser/' + blufolder + '/size' + bitchSize + '_blu', 'shared');
		bluDispenserBitch.animation.addByIndices('danceLeft', "size" + bitchSize + '_blu idle', [28, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12], "", bitchFps, false);
		bluDispenserBitch.animation.addByIndices('danceRight', "size" + bitchSize + '_blu idle', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", bitchFps, false);
		
		redDispenserBitch.frames = Paths.getSparrowAtlas('hornyshit/dispenser/' + redfolder + '/size' + bitchSize + '_red', 'shared');
		redDispenserBitch.animation.addByIndices('danceLeft', "size" + bitchSize + '_red idle', [28, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12], "", bitchFps, false);
		redDispenserBitch.animation.addByIndices('danceRight', "size" + bitchSize + '_red idle', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", bitchFps, false);
		
		danced = false;
		
		bluDispenserBitch.animation.play('danceLeft', true);
		redDispenserBitch.animation.play('danceLeft', true);
	}
}

class Button extends FlxSprite
{
	var callback:Void -> Void;
	
	public function new (x:Float, y:Float, buttonImg:String, callBack:Void -> Void)
	{
		super(x,y);
	
		loadGraphic(Paths.image('hornyshit/dispenser/' + buttonImg, 'shared'));
		antialiasing = FlxG.save.data.antiAliasing;
		
		callback = callBack;
	}
	
	override function update(elapsed:Float)
	{		
		super.update(elapsed);
		
		if (FlxG.mouse.overlaps(this)) 
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