package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

class DispenserBurstState extends MusicBeatState
{
	public var bluDispenserBitch:DispenserBitch;
	public var redDispenserBitch:DispenserBitch;
	
	var bitchColor:String = 'blu';
	var bitchSize:Float = 1;
	//1, 2, 3
	var bitchType:String = "none";
	// none, red-blu, blu-red
	
	// this might be unnecessary i think???
	var buttonRed:Button;
	var buttonBlu:Button;
	var button1:Button;
	var button2:Button;
	var button3:Button;
	var buttonRedBlu:Button;
	var buttonBluRed:Button;
	
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Fucking the Dispenser Bitch", null);
		#end
		
		FlxG.sound.playMusic(Paths.music('burstByKO3', 'shared'), 1, true);

		Conductor.changeBPM(150);
		
		bluDispenserBitch = new DispenserBitch(bitchSize, 'blu', 'none');
		add(bluDispenserBitch);
		
		redDispenserBitch = new DispenserBitch(bitchSize, 'red', 'none');
		add(redDispenserBitch);
		
		redDispenserBitch.visible = false;
		
		var correctAxis:Array<Dynamic> = Button.loadOffset('correction');
		
		buttonBlu = new Button(bluDispenserBitch.width * 1.34, 10, correctAxis, 'hornyshit/dispenser/blue_button', function()
		{
			changeBitchColor('blu');
		});
		add(buttonBlu);
		
		buttonRed = new Button(buttonBlu.x, buttonBlu.height + buttonBlu.y + 20, correctAxis, 'hornyshit/dispenser/red_button', function()
		{
			changeBitchColor('red');
		});
		add(buttonRed);
		
		buttonBluRed = new Button(buttonBlu.x + buttonBlu.width + 10, buttonBlu.y, correctAxis, 'hornyshit/dispenser/blue-red_typeButton', function()
		{
			changeBitchType('blu-red');
		});
		add(buttonBluRed);
		
		buttonRedBlu = new Button(buttonBluRed.x, buttonBluRed.y + buttonBluRed.height + 20, correctAxis, 'hornyshit/dispenser/red-blue_typeButton', function()
		{
			changeBitchType('red-blu');
		});
		add(buttonRedBlu);
		
		button1 = new Button(196, 10, correctAxis, 'hornyshit/dispenser/1_button', function()
		{
			changeBitchSize(1);
		});
		add(button1);
		
		button2 = new Button(button1.x, button1.height + button1.y + 20, correctAxis, 'hornyshit/dispenser/2_button', function()
		{
			changeBitchSize(2);
		});
		add(button2);
		
		button3 = new Button(button2.x, button2.height + button2.y + 20, correctAxis, 'hornyshit/dispenser/3_button', function()
		{
			changeBitchSize(3);
		});
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
		
		danced = false;
		
		bluDispenserBitch.reloadBitch(bitchSize, 'blu', blufolder);
		redDispenserBitch.reloadBitch(bitchSize, 'red', redfolder);
	}
}

class DispenserBitch extends FlxSprite
{
	public function new (size:Float, type:String, folder:String)
	{
		super();
		reloadBitch(size, type, folder);
		screenCenter();
		scale.set(0.85, 0.85);
		antialiasing = FlxG.save.data.antiAliasing;
		
		animation.play('danceLeft', true);
	}
	
	public function reloadBitch(size:Float, type:String, folder:String)
	{
		frames = Paths.getSparrowAtlas('hornyshit/dispenser/' + folder + '/size' + size + '_' + type, 'shared');
		animation.addByIndices('danceLeft', "size" + size + '_' + type + ' idle', [28, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12], "", 40, false);
		animation.addByIndices('danceRight', "size" + size + '_' + type + ' idle', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 40, false);
		animation.play('danceLeft', true);
	}
}