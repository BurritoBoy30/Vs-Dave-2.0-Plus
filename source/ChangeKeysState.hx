package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import Controls.Control;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;

class ChangeKeysState extends MusicBeatState
{	
	var curSelected:Int = 0;
	
	var keysText:FlxTypedGroup<FlxText>;
	
	var selectedBG:FlxSprite;
	
	var minorTxtBG:FlxSprite;
	var keyBindsTxtBG:FlxSprite;
	
	var minorTxt:FlxText;
	
	var arrowKeys:Array<String> = ['purple','blue','green','red'];
	var keyStyleArray:Array<String> = ['Solo','Duo','Custom'];
	var keys:Array<String> = ["","","",""];
	
	var state = 'select';
	
	var blacklist:Array<String> = ["ESCAPE", "ENTER", "BACKSPACE", "SPACE", "TAB"];
	
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(MainMenuState.randomizeBG());
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = FlxG.save.data.antiAliasing;
		add(menuBG);
		
		minorTxtBG = new FlxSprite(30, 20).makeGraphic(FlxG.width - 60, 100, 0xFF000000);
		minorTxtBG.alpha = 0.6;
		add(minorTxtBG);
		
		keyBindsTxtBG = new FlxSprite(30, minorTxtBG.y + minorTxtBG.height + 20).makeGraphic(FlxG.width - 60, 560, 0xFF000000);
		keyBindsTxtBG.alpha = 0.6;
		add(keyBindsTxtBG);
		
		selectedBG = new FlxSprite(30, 20).makeGraphic(FlxG.width - 60, 100, 0xFF000000);
		selectedBG.alpha = 0.6;
		add(selectedBG);
		
		minorTxt = new FlxText(0, 30, FlxG.width, "", 16);
		minorTxt.setFormat(Paths.font("comic.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		add(minorTxt);
		
		keysText = new FlxTypedGroup<FlxText>();
		add(keysText);
		
		changeKeyStyle();
		
		for (i in 0...arrowKeys.length)
		{
			var theNotes:FlxSprite = new FlxSprite(0, (keyBindsTxtBG.y - 8) + (i * 140));
			theNotes.frames = Paths.getSparrowAtlas('notes/NOTE_assets', 'shared');
			theNotes.animation.addByPrefix('note', arrowKeys[i] + '0', 1);
			theNotes.animation.play('note');
			theNotes.screenCenter(X);
			theNotes.x -= 60;
			theNotes.setGraphicSize(Std.int(theNotes.width * 0.75));
			theNotes.antialiasing = FlxG.save.data.antiAliasing;
			add(theNotes);
			
			var theKeys:FlxText = new FlxText(0, (keyBindsTxtBG.y - 8) + (i * 140), FlxG.width, keys[i], 12);
			theKeys.setFormat(Paths.font("comic.ttf"), 100, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			theKeys.x += 680;
			theKeys.ID = i;
			keysText.add(theKeys);
		}
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (state == 'select')
		{
			if (controls.BACK)
				FlxG.switchState(new OptionsMenu());
			
			if (FlxG.save.data.keyStyleChoice == 2)
			{
				if (FlxG.keys.justPressed.UP)
					changeSelection(-1);
				if (FlxG.keys.justPressed.DOWN)
					changeSelection(1);
			}
				
			if (curSelected == 0)
			{
				if (FlxG.keys.justPressed.LEFT)
				{
					changeKeyStyle(-1);
					keyTextSwap();
				}
				if (FlxG.keys.justPressed.RIGHT)
				{
					changeKeyStyle(1);
					keyTextSwap();
				}
			}
			
			if (curSelected != 0)
			{
				if (FlxG.keys.justPressed.ENTER)
				{
					keysText.members[curSelected - 1].text = "...";
					state = 'waiting';
				}
			}
		}
		else if (state == 'waiting')
		{
			if (FlxG.keys.justPressed.ANY)
			{
				addKey(FlxG.keys.getIsDown()[0].ID.toString());
				state = 'select';
			}
		}
	}
	
	function changeSelection(eek:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		curSelected += eek;
		
		if (curSelected < 0)
			curSelected = 0;
		if (curSelected >= arrowKeys.length + 1)
			curSelected = (arrowKeys.length + 1) - 1;
			
		switch (curSelected)
		{
			case 0:
				selectedBG.y = 20;
				selectedBG.makeGraphic(FlxG.width - 60, 100, 0xFF000000);
			
			case 1:
				selectedBG.y = minorTxtBG.y + minorTxtBG.height + 20;
				selectedBG.makeGraphic(FlxG.width - 60, 140, 0xFF000000);
			
			case 2:
				selectedBG.y = minorTxtBG.y + minorTxtBG.height + 20 + (keyBindsTxtBG.height / 4);
				selectedBG.makeGraphic(FlxG.width - 60, 140, 0xFF000000);
			
			case 3:
				selectedBG.y = minorTxtBG.y + minorTxtBG.height + 20 + (keyBindsTxtBG.height / 2);
				selectedBG.makeGraphic(FlxG.width - 60, 140, 0xFF000000);
				
			case 4:
				selectedBG.y = minorTxtBG.y + minorTxtBG.height + 20 + (keyBindsTxtBG.height - (keyBindsTxtBG.height / 4));
				selectedBG.makeGraphic(FlxG.width - 60, 140, 0xFF000000);
		}	
	}
	
	function changeKeyStyle(yes:Int = 0)
	{
		FlxG.save.data.keyStyleChoice += yes;
		
		if (FlxG.save.data.keyStyleChoice >= keyStyleArray.length)
			FlxG.save.data.keyStyleChoice = 0;
		if (FlxG.save.data.keyStyleChoice < 0)
			FlxG.save.data.keyStyleChoice = keyStyleArray.length - 1;
			
		switch (FlxG.save.data.keyStyleChoice)
		{
			case 0:
				controls.setKeyboardScheme(KeyboardScheme.Solo, true);
				keys = ["A","S","W","D"];
			case 1:
				controls.setKeyboardScheme(KeyboardScheme.Duo, true);
				keys = ["D","F","J","K"];
			case 2:
				controls.setKeyboardScheme(KeyboardScheme.Custom, true);
				keys = [FlxG.save.data.leftBind, FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
		}
		
		minorTxt.text = "< " + keyStyleArray[FlxG.save.data.keyStyleChoice] + " >";
	}
	
	function keyTextSwap()
	{
		for (i in 0...arrowKeys.length)
		{
			keysText.members[i].text = keys[i];
		}
	}
	
	function addKey(yee:String)
	{
		switch (curSelected)
		{
			case 1:
				if (blacklist.contains(yee))
				{
					var defaultKey:String = FlxG.save.data.leftBind;
					FlxG.save.data.leftBind = defaultKey;
				}
				else
				{
					FlxG.save.data.leftBind = yee;
				}
				keysText.members[0].text = FlxG.save.data.leftBind;
			case 2:
				if (blacklist.contains(yee))
				{
					var defaultKey:String = FlxG.save.data.downBind;
					FlxG.save.data.downBind = defaultKey;
				}
				else
				{
					FlxG.save.data.downBind = yee;
				}
				keysText.members[1].text = FlxG.save.data.downBind;
			case 3:
				if (blacklist.contains(yee))
				{
					var defaultKey:String = FlxG.save.data.upBind;
					FlxG.save.data.upBind = defaultKey;
				}
				else
				{
					FlxG.save.data.upBind = yee;
				}
				keysText.members[2].text = FlxG.save.data.upBind;
			case 4:
				if (blacklist.contains(yee))
				{
					var defaultKey:String = FlxG.save.data.rightBind;
					FlxG.save.data.rightBind = defaultKey;
				}
				else
				{
					FlxG.save.data.rightBind = yee;
				}
				keysText.members[3].text = FlxG.save.data.rightBind;
		}
	}
}