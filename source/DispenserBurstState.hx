package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class DispenserBurstState extends MusicBeatState
{
	public var bluDispenserBitch:FlxSprite;
	public var redDispenserBitch:FlxSprite;
	
	var bitchColor:String = 'blu';
	var bitchSize:String = '1';
	//1, 2, 3
	var bitchType:String = "none";
	// none, red-blu, blu-red
	
	var buttonRed:FlxSprite;
	var buttonBlu:FlxSprite;
	
	var button1:FlxSprite;
	var button2:FlxSprite;
	var button3:FlxSprite;
	
	var buttonRedBlu:FlxSprite;
	var buttonBluRed:FlxSprite;
	
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
		
		buttonBlu = new FlxSprite(bluDispenserBitch.width * 1.34, 10).loadGraphic(Paths.image('hornyshit/dispenser/blue_button', 'shared'));
		buttonBlu.antialiasing = FlxG.save.data.antiAliasing;
		add(buttonBlu);
		
		buttonRed = new FlxSprite(buttonBlu.x, buttonBlu.height + buttonBlu.y + 20).loadGraphic(Paths.image('hornyshit/dispenser/red_button', 'shared'));
		buttonRed.antialiasing = FlxG.save.data.antiAliasing;
		add(buttonRed);
		
		buttonBluRed = new FlxSprite(buttonBlu.x + buttonBlu.width + 10, buttonBlu.y).loadGraphic(Paths.image('hornyshit/dispenser/blue-red_typeButton', 'shared'));
		buttonBluRed.antialiasing = FlxG.save.data.antiAliasing;
		add(buttonBluRed);
		
		buttonRedBlu = new FlxSprite(buttonBluRed.x, buttonBluRed.y + buttonBluRed.height + 20).loadGraphic(Paths.image('hornyshit/dispenser/red-blue_typeButton', 'shared'));
		buttonRedBlu.antialiasing = FlxG.save.data.antiAliasing;
		add(buttonRedBlu);
		
		button1 = new FlxSprite(196, 10).loadGraphic(Paths.image('hornyshit/dispenser/1_button', 'shared'));
		button1.antialiasing = FlxG.save.data.antiAliasing;
		add(button1);
		
		button2 = new FlxSprite(button1.x, button1.height + button1.y + 20).loadGraphic(Paths.image('hornyshit/dispenser/2_button', 'shared'));
		button2.antialiasing = FlxG.save.data.antiAliasing;
		add(button2);
		
		button3 = new FlxSprite(button2.x, button2.height + button2.y + 20).loadGraphic(Paths.image('hornyshit/dispenser/3_button', 'shared'));
		button3.antialiasing = FlxG.save.data.antiAliasing;
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
		
		buttonGetDark();
		
		if (FlxG.mouse.overlaps(buttonBlu))
		{
			buttonNumber = 1;
		}
		else if (FlxG.mouse.overlaps(buttonRed))
		{
			buttonNumber = 2;
		}
		else if (FlxG.mouse.overlaps(button1))
		{
			buttonNumber = 3;
		}
		else if (FlxG.mouse.overlaps(button2))
		{
			buttonNumber = 4;
		}
		else if (FlxG.mouse.overlaps(button3))
		{
			buttonNumber = 5;
		}
		else if (FlxG.mouse.overlaps(buttonBluRed))
		{
			buttonNumber = 6;
		}
		else if (FlxG.mouse.overlaps(buttonRedBlu))
		{
			buttonNumber = 7;
		}
		else
		{
			buttonNumber = 0;
		}
		
		if (FlxG.mouse.justPressed)
		{	
			buttonUI();
		}
	}
	
	function buttonGetDark()
	{
		if (FlxG.mouse.overlaps(buttonBlu))
			buttonBlu.color = 0xFF878787;
		else
			buttonBlu.color = FlxColor.WHITE;
			
		if (FlxG.mouse.overlaps(buttonRed))
			buttonRed.color = 0xFF878787;
		else
			buttonRed.color = FlxColor.WHITE;
			
		if (FlxG.mouse.overlaps(button1))
			button1.color = 0xFF878787;
		else
			button1.color = FlxColor.WHITE;
			
		if (FlxG.mouse.overlaps(button2))
			button2.color = 0xFF878787;
		else
			button2.color = FlxColor.WHITE;
			
		if (FlxG.mouse.overlaps(button3))
			button3.color = 0xFF878787;
		else
			button3.color = FlxColor.WHITE;
		
		if (FlxG.mouse.overlaps(buttonBluRed))
			buttonBluRed.color = 0xFF878787;
		else
			buttonBluRed.color = FlxColor.WHITE;
			
		if (FlxG.mouse.overlaps(buttonRedBlu))
			buttonRedBlu.color = 0xFF878787;		
		else
			buttonRedBlu.color = FlxColor.WHITE;
	}
	
	function buttonUI()
	{				
		switch (buttonNumber)
		{
			case 1:
				if (bitchColor != 'blu')
				{
					bitchColor = 'blu';
					bluDispenserBitch.visible = true;
					redDispenserBitch.visible = false;
					if (bitchType != 'none')
					{
						bitchType = 'none';
						reloadBitches();
					}
				}
			case 2:
				if (bitchColor != 'red')
				{
					bitchColor = 'red';
					bluDispenserBitch.visible = false;
					redDispenserBitch.visible = true;
					if (bitchType != 'none')
					{
						bitchType = 'none';
						reloadBitches();
					}
				}
			case 3:
				if (bitchSize != '1')
				{
					bitchSize = '1';
					reloadBitches();
				}
			case 4:
				if (bitchSize != '2')
				{
					bitchSize = '2';
					reloadBitches();
				}
			case 5:
				if (bitchSize != '3')
				{
					bitchSize = '3';
					reloadBitches();
				}
			case 6:
				if (bitchType != 'blu-red')
				{
					bitchType = 'blu-red';
					bitchColor = 'mixed';
					bluDispenserBitch.visible = true;
					redDispenserBitch.visible = true;
					reloadBitches();
				}
			case 7:
				if (bitchType != 'red-blu')
				{
					bitchType = 'red-blu';
					bitchColor = 'mixed';
					bluDispenserBitch.visible = true;
					redDispenserBitch.visible = true;
					reloadBitches();
				}
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