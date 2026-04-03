package states;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;

class DispenserBurstStateRecode extends MusicBeatState
{
	public var bluDispenserBitch:DispenserBitch;
	public var redDispenserBitch:DispenserBitch;
	
	var leftBack:FlxSprite;
	var rightBack:FlxSprite;
	var movingBar:FlxBackdrop;
	
	var button1left:Button;
	var button2left:Button;
	var button3left:Button;
	
	var button1right:Button;
	var button2right:Button;
	var button3right:Button;
		
	var leftSize:Float = 1;
	var rightSize:Float = 1;
	
	override function create()
	{
		FlxG.sound.playMusic(Paths.music('doodle', 'horny'), 1, true);

		Conductor.changeBPM(160);
		
		leftBack = new FlxSprite().loadGraphic(Paths.image('dispenser-recode/backgrounds/' + leftSize, 'horny'));
		leftBack.antialiasing = FlxG.save.data.antiAliasing;
		add(leftBack);
		
		rightBack = new FlxSprite().loadGraphic(Paths.image('dispenser-recode/backgrounds/' + rightSize, 'horny'));
		rightBack.antialiasing = FlxG.save.data.antiAliasing;
		rightBack.flipX = true;
		add(rightBack);
		
		movingBar = new FlxBackdrop(Paths.image('dispenser-recode/movingBar', 'horny'), XY, 0, 0);
		movingBar.antialiasing = FlxG.save.data.antiAliasing;
		add(movingBar);
		
		bluDispenserBitch = new DispenserBitch('left', leftSize);
		add(bluDispenserBitch);
		
		redDispenserBitch = new DispenserBitch('right', rightSize);
		add(redDispenserBitch);
		
		var lineInBetween:FlxSprite = new FlxSprite(2.5, 0).loadGraphic(Paths.image('dispenser-recode/line', 'horny'));
		lineInBetween.antialiasing = FlxG.save.data.antiAliasing;
		add(lineInBetween);
		
		var listing:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('dispenser-recode/options_' + FlxG.save.data.gameLanguage, 'horny'));
		listing.x = FlxG.width - listing.width;
		listing.antialiasing = FlxG.save.data.antiAliasing;
		add(listing);
		
		var correctAxis:Array<Dynamic> = Button.loadOffset('correction');
		
		// left side
		button1left = new Button(FlxG.width - 185, 70, correctAxis, 'dispenser-recode/button1', 'horny', function()
		{
			if (leftSize != 1)
			{
				leftSize = 1;
				bluDispenserBitch.reloadBitch('left', leftSize);
				leftBack.loadGraphic(Paths.image('dispenser-recode/backgrounds/' + leftSize, 'horny'));
			}
		});
		add(button1left);
		
		button2left = new Button(button1left.x, button1left.height + button1left.y + 20, correctAxis, 'dispenser-recode/button2', 'horny', function()
		{
			if (leftSize != 2)
			{
				leftSize = 2;
				bluDispenserBitch.reloadBitch('left', leftSize);
				leftBack.loadGraphic(Paths.image('dispenser-recode/backgrounds/' + leftSize, 'horny'));
			}
		});
		add(button2left);
		
		button3left = new Button(button2left.x, button2left.height + button2left.y + 20, correctAxis, 'dispenser-recode/button3', 'horny', function()
		{
			if (leftSize != 3)
			{
				leftSize = 3;
				bluDispenserBitch.reloadBitch('left', leftSize);
				leftBack.loadGraphic(Paths.image('dispenser-recode/backgrounds/' + leftSize, 'horny'));
			}
		});
		add(button3left);
		
		
		// right side
		button1right = new Button(button1left.x + 100, button1left.y, correctAxis, 'dispenser-recode/button1', 'horny', function()
		{
			if (rightSize != 1)
			{
				rightSize = 1;
				redDispenserBitch.reloadBitch('right', rightSize);
				rightBack.loadGraphic(Paths.image('dispenser-recode/backgrounds/' + rightSize, 'horny'));
			}
		});
		add(button1right);
		
		button2right = new Button(button1right.x, button1right.height + button1right.y + 20, correctAxis, 'dispenser-recode/button2', 'horny', function()
		{
			if (rightSize != 2)
			{
				rightSize = 2;
				redDispenserBitch.reloadBitch('right', rightSize);
				rightBack.loadGraphic(Paths.image('dispenser-recode/backgrounds/' + rightSize, 'horny'));
			}
		});
		add(button2right);
		
		button3right = new Button(button2right.x, button2right.height + button2right.y + 20, correctAxis, 'dispenser-recode/button3', 'horny', function()
		{
			if (rightSize != 3)
			{
				rightSize = 3;
				redDispenserBitch.reloadBitch('right', rightSize);
				rightBack.loadGraphic(Paths.image('dispenser-recode/backgrounds/' + rightSize, 'horny'));
			}
		});
		add(button3right);
		
		var return_button:Button = new Button(5, 0, Button.loadOffset('correction'), 'freeplay/return_' + FlxG.save.data.gameLanguage, 'preload', function()
		{
			FlxG.switchState(new FreeplayState());
		});
		return_button.y = FlxG.height - return_button.height - 5;
		add(return_button);
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		var scrollSpeed:Float = 100;
		movingBar.x += scrollSpeed * elapsed;
	
		super.update(elapsed);
	}
	
	override function beatHit()
	{
		super.beatHit();
	
		redDispenserBitch.animation.play('idle', true);
		bluDispenserBitch.animation.play('idle', true);
	}
}

class DispenserBitch extends FlxSprite
{
	public function new (side:String, type:Float)
	{
		super();
		reloadBitch(side, type);
	}
	
	public function reloadBitch(side:String, type:Float)
	{
		frames = Paths.getSparrowAtlas('dispenser-recode/' + side + '/size' + type , 'horny');
		screenCenter();
		scale.set(0.8, 0.8);
		antialiasing = FlxG.save.data.antiAliasing;
			
		animation.addByPrefix('idle', "size" + type, 13.2, false);
		animation.play('idle', true);
	}
}