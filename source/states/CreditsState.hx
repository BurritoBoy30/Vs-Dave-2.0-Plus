package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;

class CreditsState extends MusicBeatState
{
	var goToBuild:Button;
	var goToDevs:Button;
	
	var buildArray:Array<CreditsTexts> = [
		new CreditsTexts("Burrito", "coded this whole thing"),
		new CreditsTexts("MsCyan", 'Cyan and Tails Doll sprites'),
		new CreditsTexts("DeliriousPersona", "Psyka sprites"),
		new CreditsTexts("RedstyPhoenix & VoidEyedPanda", "Playable GF sprites"),
		new CreditsTexts("ZinoMan", "Rapper GF sprites"),
		new CreditsTexts("MikuLazo", "Massive GF and Trepidation GF sprites"),
		new CreditsTexts("lennyfaic", "Hot GF sprites"),
		new CreditsTexts("skyblueanon", "Skyblue sprites"),
		new CreditsTexts("proteincuMbar", "The GF Trio sprites"),
		new CreditsTexts("MizanPloz", "Kaity and Chris sprites")
	];
	
	var devsArray:Array<CreditsTexts> = [
		new CreditsTexts("MoldyGH", "Director, Creator, Programmer, Musician, Main Developer"),
		new CreditsTexts("MissingTextureMan101", "Secondary Developer and Programmer"),
		new CreditsTexts("rapperep lol", 'Main Artist'),
		new CreditsTexts("TheBuilderXD", "Secondary Artist"),
		new CreditsTexts("T5mpler", "Programmer & Assistor"),
		new CreditsTexts("Erizur", "New Main Menu Programmer, Artist & Spanish Translator"),
		new CreditsTexts("Billy Bobbo", "Moral Support & Idea Suggesting"),
		new CreditsTexts("pointy", "Artist & Charter"),
		new CreditsTexts("Zmac", "3D Backgrounds, Intro text help")
	];
	
	var grpCredits:FlxTypedGroup<CreditListing>;

	
	override function create()
	{	
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image(MainMenuState.randomizeBG(), 'preload'));
		menuBG.screenCenter();
		menuBG.color = 0xFF00CECE;
		menuBG.antialiasing = FlxG.save.data.antiAliasing;
		add(menuBG);
		
		var sidebar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('creditbar', 'preload'));
		sidebar.antialiasing = FlxG.save.data.antiAliasing;
		add(sidebar);
		
		grpCredits = new FlxTypedGroup<CreditListing>();
		add(grpCredits);
		
		goToBuild = new Button(5, 5, Button.loadOffset('correction'), 'creditbutton_build', 'preload', function()
		{
			camoffset = 0;
			for (item in grpCredits.members)
			{
				item.destroy();
			}
			
			generateCreditList(buildArray, 1300);
		});
		add(goToBuild);
		
		goToDevs = new Button(5, goToBuild.height + goToBuild.y + 10, Button.loadOffset('correction'), 'creditbutton_devs', 'preload', function()
		{
			camoffset = 0;
			for (item in grpCredits.members)
			{
				item.destroy();
			}
			
			generateCreditList(devsArray, 1050);
		});
		add(goToDevs);
		
		generateCreditList(buildArray, 1300);
		
		FlxG.mouse.visible = true;
		
		super.create();
	}
	
	function generateCreditList(dullArray:Array<CreditsTexts>, limit:Float)
	{
		for (i in 0...dullArray.length)
		{
			var devSegment:CreditListing = new CreditListing(140, (200 * i), dullArray[i]);
			grpCredits.add(devSegment);
		}
		
		camoffsetLimit = -limit;
	}
	
	var camoffset:Float = 0;
	var camoffsetLimit:Float = 0;
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.UP)
		{
			if (camoffset != 0)
				camoffset += 10;
		}
		else if (FlxG.keys.pressed.DOWN)
		{
			if (camoffset != camoffsetLimit)
				camoffset -= 10;
		}
		else
			camoffset += 0;
			
		for (item in grpCredits.members)
		{
			item.y = camoffset;
		}
			
		if (controls.BACK)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(new MainMenuState());
		}
	}
}

class CreditsTexts
{
	public var devNames:String = '';
	public var devDescs:String = '';
	
	public function new(textData:String, descText:String)
	{
		devNames = textData;
		devDescs = descText;
	}
}

class CreditListing extends FlxSpriteGroup
{
	public function new(x:Float, y:Float, getNames:CreditsTexts)
	{
		super(x, y);
		
		var devIcon:FlxSprite = new FlxSprite(x, y + 30).loadGraphic(Paths.image('crediticons/' + getNames.devNames.toLowerCase(), 'preload'));
		devIcon.antialiasing = FlxG.save.data.antiAliasing;
		add(devIcon);
		
		var devname:FlxText = new FlxText(x + 180, y + 25, FlxG.width, getNames.devNames, 12);
		devname.setFormat("Comic Sans MS Bold", 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		devname.borderSize = 2;
		devname.antialiasing = FlxG.save.data.antiAliasing;
		add(devname);
		
		var devdesc:FlxText = new FlxText(x + 180, y + 95, FlxG.width, getNames.devDescs, 12);
		devdesc.setFormat("Comic Sans MS Bold", 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		devname.borderSize = 2;
		devdesc.antialiasing = FlxG.save.data.antiAliasing;
		add(devdesc);
	}
}