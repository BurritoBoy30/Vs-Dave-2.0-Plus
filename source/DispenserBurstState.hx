package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;

class DispenserBurstState extends MusicBeatState
{
	public var bluDispenserBitch:DispenserBitch;
	public var redDispenserBitch:DispenserBitch;
	
	var bitchColor:String = 'blu';
	var bitchSize:Float = 1;
	//1, 2, 3
	var bitchType:String = "none";
	// none, red-blu, blu-red
	var bitchFolder:String = 'tf2';
	// tf2, jaiden
	var swapBitchFolder:Bool = false;
	
	var movingBar:FlxBackdrop;
	var joggingBitchesBackground:FlxSprite;
	
	// this might be unnecessary i think???
	var buttonRed:Button;
	var buttonBlu:Button;
	var button1:Button;
	var button2:Button;
	var button3:Button;
	var buttonRedBlu:Button;
	var buttonBluRed:Button;
	var buttonSwitch:Button;
	
	var buttonList:Array<Button> = [];
	var buttonFileList:Array<String> = ['red', 'blue', 'red-blue', 'blue-red'];
	
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Fucking the Dispenser Bitch", null);
		#end
		
		FlxG.mouse.visible = true;
		
		FlxG.sound.playMusic(Paths.music('burstByKO3', 'shared'), 1, true);

		Conductor.changeBPM(150);
		
		joggingBitchesBackground = new FlxSprite().loadGraphic(Paths.image('hornyshit/dispenser/jaiden/backgrounds/blue', 'preload'));
		joggingBitchesBackground.screenCenter();
		joggingBitchesBackground.antialiasing = FlxG.save.data.antiAliasing;
		add(joggingBitchesBackground);
		
		movingBar = new FlxBackdrop(Paths.image('hornyshit/dispenser/jaiden/movingBar', 'preload'), XY, 0, 0);
		movingBar.antialiasing = FlxG.save.data.antiAliasing;
		add(movingBar);
		
		bluDispenserBitch = new DispenserBitch(bitchSize, 'blu', 'none');
		add(bluDispenserBitch);
		
		redDispenserBitch = new DispenserBitch(bitchSize, 'red', 'none');
		add(redDispenserBitch);
		
		redDispenserBitch.visible = false;
		
		var correctAxis:Array<Dynamic> = Button.loadOffset('correction');
		
		buttonSwitch = new Button(10, 10, correctAxis, 'hornyshit/dispenser/button_jaiden', 'preload', function()
		{
			swapBitchFolder =! swapBitchFolder;
			
			if (swapBitchFolder)
				changeEverythingTo('jaiden');
			else
				changeEverythingTo('tf2');
		});
		add(buttonSwitch);
		
		var offset:Float = 65;
		buttonBlu = new Button((bluDispenserBitch.width * 1.34) + offset, 10, correctAxis, 'hornyshit/dispenser/tf2/blue_button', 'preload', function()
		{
			changeBitchColor('blu');
		});
		add(buttonBlu);
		
		buttonRed = new Button(buttonBlu.x, buttonBlu.height + buttonBlu.y + 5, correctAxis, 'hornyshit/dispenser/tf2/red_button', 'preload', function()
		{
			changeBitchColor('red');
		});
		add(buttonRed);
		
		buttonBluRed = new Button(buttonBlu.x + buttonBlu.width + 5, buttonBlu.y, correctAxis, 'hornyshit/dispenser/tf2/blue-red_button', 'preload', function()
		{
			changeBitchType('blu-red');
		});
		add(buttonBluRed);
		
		buttonRedBlu = new Button(buttonBluRed.x, buttonBluRed.y + buttonBluRed.height + 5, correctAxis, 'hornyshit/dispenser/tf2/red-blue_button', 'preload', function()
		{
			changeBitchType('red-blu');
		});
		add(buttonRedBlu);
		
		button1 = new Button(196, 10, correctAxis, 'hornyshit/dispenser/tf2/1_button', 'preload', function()
		{
			changeBitchSize(1);
		});
		add(button1);
		
		button2 = new Button(button1.x, button1.height + button1.y + 20, correctAxis, 'hornyshit/dispenser/tf2/2_button', 'preload', function()
		{
			changeBitchSize(2);
		});
		add(button2);
		
		button3 = new Button(button2.x, button2.height + button2.y + 20, correctAxis, 'hornyshit/dispenser/tf2/3_button', 'preload', function()
		{
			changeBitchSize(3);
		});
		add(button3);
		
		buttonList = [buttonRed, buttonBlu, buttonRedBlu, buttonBluRed];

		super.create();
	}
	
	var danced:Bool = false;
	
	override function beatHit()
	{
		super.beatHit();
		
		danced = !danced;
		
		if (bitchFolder == 'tf2')
		{
			redDispenserBitch.animation.play(danced ? 'danceRight' : 'danceLeft', true);
			bluDispenserBitch.animation.play(danced ? 'danceRight' : 'danceLeft', true);
		}
		else if (bitchFolder == 'jaiden')
		{
			redDispenserBitch.animation.play('idle', true);
			bluDispenserBitch.animation.play('idle', true);
		}
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		var scrollSpeed:Float = 100;
		movingBar.x += scrollSpeed * elapsed;
		
		movingBar.visible = bitchFolder == 'jaiden';
		joggingBitchesBackground.visible = bitchFolder == 'jaiden';
		
		if (controls.BACK)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(new FreeplayState());
		}
		
		super.update(elapsed);
	}
	
	function reloadJoggingBitchesBackground()
	{
		var fileName:String = '';
		switch (bitchColor)
		{
			case 'red':
				fileName = 'red';
			case 'blu':
				fileName = 'blue';
			case 'mixed':
				if (bitchType == 'blu-red')
					fileName = 'blue-red';
				else if (bitchType == 'red-blu')
					fileName = 'red-blue';
		}
		
		joggingBitchesBackground.loadGraphic(Paths.image('hornyshit/dispenser/jaiden/backgrounds/' + fileName, 'preload'));
	}
	
	function changeBitchColor(cor:String)
	{
		if (bitchColor != cor)
		{
			bluDispenserBitch.visible = cor == 'blu';
			redDispenserBitch.visible = cor == 'red';
			bitchColor = cor;
			if (bitchType != 'none')
			{
				bitchType = 'none';
				reloadBitches();
			}
			reloadJoggingBitchesBackground();
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
			reloadJoggingBitchesBackground();
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
		
		danced = false;
		
		bluDispenserBitch.reloadBitch(bitchSize, 'blu', blufolder, bitchFolder);
		redDispenserBitch.reloadBitch(bitchSize, 'red', redfolder, bitchFolder);
	}
	
	function changeEverythingTo(folder:String)
	{
		bitchFolder = folder;
		
		var opposite:String = '';
		if (folder == 'tf2')
			opposite = 'jaiden';
		else if (folder == 'jaiden')
			opposite = 'tf2';
			
		buttonSwitch.reloadImage('hornyshit/dispenser/button_' + opposite, 'preload');
		
		for (memb in [button1, button2, button3])
		{
			memb.visible = bitchFolder == 'tf2';
			memb.setPermition = bitchFolder == 'tf2';
		}
		
		for (i in 0...buttonList.length)
		{
			buttonList[i].reloadImage(fileName(folder, buttonFileList[i]), 'preload');
		}
		
		reloadBitches();
	}
	
	function fileName(folder:String, whatis:String)
	{
		return 'hornyshit/dispenser/' + folder + '/' + whatis + '_button';
	}
}

class DispenserBitch extends FlxSprite
{
	public function new (size:Float, type:String, folder:String)
	{
		super();
		reloadBitch(size, type, folder, 'tf2');
		screenCenter();
		scale.set(0.85, 0.85);
		antialiasing = FlxG.save.data.antiAliasing;
		
		animation.play('danceLeft', true);
	}
	
	public function reloadBitch(size:Float, type:String, folder:String, fandom:String)
	{
		var fuckingBitchSize:Float = 0;
		
		if (fandom == 'tf2')
			fuckingBitchSize = size;
		else if (fandom == 'jaiden')
			fuckingBitchSize = 1;
			
		frames = Paths.getSparrowAtlas('hornyshit/dispenser/' + fandom + '/' + folder + '/size' + fuckingBitchSize + '_' + type, 'preload');
		if (fandom == 'tf2')
		{
			screenCenter();
			scale.set(0.85, 0.85);
			
			animation.addByIndices('danceLeft', "size" + fuckingBitchSize + '_' + type + ' idle', [28, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12], "", 30, false);
			animation.addByIndices('danceRight', "size" + fuckingBitchSize + '_' + type + ' idle', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 30, false);
			animation.play('danceLeft', true);
		}
		else if (fandom == 'jaiden')
		{
			screenCenter();
			scale.set(0.8, 0.8);
			
			animation.addByPrefix('idle', "size" + fuckingBitchSize + '_' + type + ' idle', 12, false);
			animation.play('idle', true);
		}
	}
}