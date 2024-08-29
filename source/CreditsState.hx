package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

class CreditsState extends MusicBeatState
{
	var buildArray:Array<CreditsTexts> = [
		new CreditsTexts("Levery", "coded this whole thing"),
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
		new CreditsTexts("MoldyGH", "placeholder"),
		new CreditsTexts("rapperep lol", 'placeholder'),
		new CreditsTexts("MissingTextureMan101", "placeholder"),
		new CreditsTexts("T5mpler", "placeholder"),
		new CreditsTexts("Erizur", "placeholder"),
		new CreditsTexts("Billy Bobbo", "placeholder"),
		new CreditsTexts("pointy", "placeholder"),
		new CreditsTexts("TheBuilderXD", "placeholder"),
		new CreditsTexts("Zmac", "placeholder")
	];
	
	var BuildButton:FlxSprite;
	var DevsButton:FlxSprite;
	
	var grpButtons:FlxTypedGroup<FlxSprite>;
	var grpCredits:FlxTypedGroup<CreditListing>;
	
	var currentState:String = 'selecting';
	var transition:Bool = false;
	
	override function create()
	{	
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
		menuBG.screenCenter();
		menuBG.color = 0xFF00CECE;
		menuBG.antialiasing = FlxG.save.data.antiAliasing;
		menuBG.scrollFactor.set();
		add(menuBG);
		
		grpButtons = new FlxTypedGroup<FlxSprite>();
		add(grpButtons);
		
		grpCredits = new FlxTypedGroup<CreditListing>();
		add(grpCredits);
		
		BuildButton = new FlxSprite(0, 10).loadGraphic(Paths.image('creditbutton_build', 'preload'));
		BuildButton.screenCenter(X);
		BuildButton.antialiasing = FlxG.save.data.antiAliasing;
		grpButtons.add(BuildButton);
		
		DevsButton = new FlxSprite(0, BuildButton.y + BuildButton.height +10).loadGraphic(Paths.image('creditbutton_devs', 'preload'));
		DevsButton.screenCenter(X);
		DevsButton.antialiasing = FlxG.save.data.antiAliasing;
		grpButtons.add(DevsButton);
		
		FlxG.mouse.visible = true;
		
		super.create();
	}
	
	var camoffset:Float = 0;
	var camoffsetLimit:Float = 0;

	function generateCreditList(dullArray:Array<CreditsTexts>)
	{
		for (i in 0...dullArray.length)
		{
			var devSegment:CreditListing = new CreditListing(30, (200 * i), dullArray[i]);
			grpCredits.add(devSegment);
		}
		camoffsetLimit = -(dullArray.length * 130);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (currentState == 'selecting')
		{
			if ((FlxG.mouse.overlaps(BuildButton) || FlxG.mouse.overlaps(DevsButton)) && FlxG.mouse.justPressed && !transition)
			{
				transition = true;
				for (item in grpButtons.members)
				{
					item.visible = false;
				}
				if (FlxG.mouse.overlaps(BuildButton))
					generateCreditList(buildArray);
				else if (FlxG.mouse.overlaps(DevsButton))
					generateCreditList(devsArray);
				currentState = 'reading';
				transition = false;
			}
			
			if (controls.BACK && !transition)
			{
				FlxG.mouse.visible = false;
				FlxG.switchState(new MainMenuState());
			}
		}
		else if (currentState == 'reading')
		{
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
			if (controls.BACK && !transition)
			{
				transition = true;
				for (item in grpButtons.members)
				{
					item.visible = true;
				}
				camoffset = 0;
				for (item in grpCredits.members)
				{
					item.destroy();
				}
				currentState = 'selecting';
				transition = false;
			}
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
		
		var devname:FlxText = new FlxText(x + 185, y + 30, FlxG.width, getNames.devNames, 12);
		devname.setFormat("Comic Sans MS Bold", 55, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		devname.borderSize = 2;
		devname.antialiasing = FlxG.save.data.antiAliasing;
		add(devname);
		
		var devdesc:FlxText = new FlxText(x + 185, y + 100, FlxG.width, getNames.devDescs, 12);
		devdesc.setFormat("Comic Sans MS Bold", 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		devname.borderSize = 2;
		devdesc.antialiasing = FlxG.save.data.antiAliasing;
		add(devdesc);
	}
}