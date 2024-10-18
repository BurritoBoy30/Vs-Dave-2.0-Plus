package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

class ChangeLanguage extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	
	var optionShit:Array<String> = ['en-us', 'pt-br'];
	var camFollow:FlxObject;
	var langText:FlxText;
	
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image(MainMenuState.randomizeBG(), 'preload'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = FlxG.save.data.antiAliasing;
		menuBG.scrollFactor.set();
		add(menuBG);
		
		langText = new FlxText(0, 50, FlxG.width, "", 12);
		langText.setFormat("Comic Sans MS Bold", 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		langText.borderSize = 1.5;
		langText.antialiasing = FlxG.save.data.antiAliasing;
		langText.scrollFactor.set();
		add(langText);
		
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0 + (i * 1500), 150).loadGraphic(Paths.image('language/' + optionShit[i], 'shared'));
			menuItem.ID = i;
			menuItem.scale.set(0.7, 0.7);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(1, 0);
			menuItem.antialiasing = FlxG.save.data.antiAliasing;
		}
		
		FlxG.camera.follow(camFollow, null, 0.2);
		
		super.create();
		
		changeItem();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (controls.LEFT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(-1);
		}

		if (controls.RIGHT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(1);
		}
		
		if (controls.ACCEPT)
		{
			FlxG.save.data.gameLanguage = optionShit[curSelected];
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.switchState(new OptionsMenu());
		}
		
		if (controls.BACK)
			FlxG.switchState(new OptionsMenu());
	}
	
	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		
		switch (optionShit[curSelected])
		{
			case 'en-us':
				langText.text = 'English';
			case 'pt-br':
				langText.text = 'Portugûes';
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.alpha = 0.6;

			if (spr.ID == curSelected)
			{
				spr.alpha = 1;
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
		});
	}
}