package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;

class ComboNumbersState extends MusicBeatState
{
	private var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	private var camTransition:FlxCamera;
	
	public var gf:Girlfriend;
	public var boyfriend:Boyfriend;
	
	var settingText:FlxText;
	var rating:FlxSprite;
	var comboNums:FlxSpriteGroup;
		
	var currentChanging = 'rating';
	
	var pointer:FlxSprite;
	
	override function create()
	{
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
		
		FlxG.sound.playMusic(Paths.music("offsetSong"),1,true);
		
		Conductor.changeBPM(128);
		
		camGame.zoom = 0.8;
		
		var shittyY:Float = -50;
		
		var bg:BackgroundImg = new BackgroundImg(-600, -200 + shittyY, 'stages/default/stageback', 0.9);
		add(bg);

		var stageFront:BackgroundImg = new BackgroundImg(-650, 600 + shittyY, 'stages/default/stagefront', 0.9, 1.1);
		add(stageFront);

		var stageCurtains:BackgroundImg = new BackgroundImg(-500, -200 + shittyY, 'stages/default/stagecurtains', 1.3, 0.9);
		add(stageCurtains);
		
		gf = new Girlfriend(300, 30, FlxG.save.data.hornyALL ? 'gf-hot' : 'gf');
		add(gf);
		
		boyfriend = new Boyfriend(670, 350, 'bf');
		add(boyfriend);
		
		settingText = new FlxText(10, 10, 0, '');
		settingText.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		settingText.borderSize = 3;
		settingText.antialiasing = FlxG.save.data.antiAliasing;
		add(settingText);
		settingText.cameras = [camHUD];
		
		pointer = new FlxSprite(0, 10).loadGraphic(Paths.image('UI/settings/pointer'));
		pointer.x = FlxG.width - 325;
		pointer.antialiasing = FlxG.save.data.antiAliasing;
		add(pointer);
		pointer.cameras = [camHUD];
		
		var ratingButton:Button = new Button(0, 10, [[-5, 54], [-189, -180]], 'UI/settings/rating_button', function()
		{
			currentChanging = 'rating';
			pointer.y = 10;
		});
		ratingButton.x = FlxG.width - (ratingButton.width + 10);
		add(ratingButton);
		ratingButton.cameras = [camHUD];
				
		var numbersButton:Button = new Button(0, ratingButton.y + ratingButton.height + 10, [[-5, 54], [-177, -160]], 'UI/settings/numbers_button', function()
		{
			currentChanging = 'numbers';
			pointer.y = ratingButton.y + ratingButton.height + 10;
		});
		numbersButton.x = FlxG.width - (numbersButton.width + 10);
		add(numbersButton);
		numbersButton.cameras = [camHUD];
		
		createScore();

		super.create();
		
		Transition.nextCamera = camTransition;
	}
	
	override function beatHit()
	{
		super.beatHit();

		if (curBeat % 2 == 0)
		{
			boyfriend.dance();
			gf.dance();
		}
	}
	
	var offsetterX:Float = 0; 
	var offsetterY:Float = 0;
	
	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		super.update(elapsed);
		
		if (FlxG.keys.pressed.LEFT)
			offsetterX = -2;
		else if (FlxG.keys.pressed.RIGHT)
			offsetterX = 2;
		else
			offsetterX = 0;
			
		if (FlxG.keys.pressed.UP)
			offsetterY = -2;
		else if (FlxG.keys.pressed.DOWN)
			offsetterY = 2;
		else
			offsetterY = 0;
		
		switch (currentChanging)
		{
			case 'rating':
				FlxG.save.data.comboRatingLocation[0] += offsetterX;
				FlxG.save.data.comboRatingLocation[1] += offsetterY;
			case 'numbers':
				FlxG.save.data.comboNumbersLocation[0] += offsetterX;
				FlxG.save.data.comboNumbersLocation[1] += offsetterY;
		}
		
		repositioning();
		
		settingText.text = 'Axis\nRating: [' +  FlxG.save.data.comboRatingLocation[0] + ", " + FlxG.save.data.comboRatingLocation[1] + ']'
			+ '\nNumbers: [' +  FlxG.save.data.comboNumbersLocation[0] + ", " + FlxG.save.data.comboNumbersLocation[1] + ']';
		
		if (controls.BACK)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new OptionsMenu());
		}
	}
	
	function createScore()
	{
		rating = new FlxSprite().loadGraphic(Paths.image('UI/sick'));
		rating.antialiasing = FlxG.save.data.antiAliasing;
		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.cameras = [camHUD];
		
		add(rating);

		comboNums = new FlxSpriteGroup();
		comboNums.cameras = [camHUD];
		add(comboNums);

		var seperatedScore:Array<Int> = [];
		for (i in 0...3)
		{
			seperatedScore.push(FlxG.random.int(0, 9));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite(43 * daLoop).loadGraphic(Paths.image('UI/num' + i));
			numScore.cameras = [camHUD];
			numScore.antialiasing = FlxG.save.data.antiAliasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();
			comboNums.add(numScore);
			daLoop++;
		}
		
		repositioning();
	}
	
	function repositioning()
	{
		rating.screenCenter();
		rating.x = (FlxG.width * 0.5) - 40 + FlxG.save.data.comboRatingLocation[0];
		rating.y += -60 + FlxG.save.data.comboRatingLocation[1];

		comboNums.screenCenter();
		comboNums.x = (FlxG.width * 0.5) - 45 + FlxG.save.data.comboNumbersLocation[0];
		comboNums.y += 40 + FlxG.save.data.comboNumbersLocation[1];
	}
}