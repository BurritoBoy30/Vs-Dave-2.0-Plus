package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

using StringTools;

//msdos clone lmao
class ConsoleState extends MusicBeatState
{
	public var mainText:FlxText;
	var Textbox:FlxUIInputText;
	
	public var inputText:String;

	var startingUp:Bool = true;

	override function create()
	{
		FlxG.mouse.visible = true;

		mainText = new FlxText(5, 5, "");
		mainText.autoSize = false;
		mainText.size = 16;
		mainText.fieldWidth = 1280;
		mainText.alignment = FlxTextAlign.LEFT;
		add(mainText);

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			mainText.text = "\n" + "\n" + "\n" +"          Starting BurritoWorks VSD-SMS...";

			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
				mainText.text = "BurritoWorks(R)  VSD-SMS" + "\n"
				+ "(C) Copyright BurritoWorks Corp 2008-2024." + "\n" + "\n"
				+ "Click on the Text Bar to start typing!" + "\n"
				+ "Press ENTER to input your text as a command." + "\n"
				+ "Type /help to list all the possible commands." + "\n" + "\n"
				+ "/";

				Textbox = new FlxUIInputText(0, FlxG.height - 26, FlxG.width, "", 16);
				add(Textbox);

				startingUp = false;
			});
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!startingUp)
		{
			inputText = Textbox.text;
			  
			if (FlxG.keys.justPressed.ENTER && Textbox.text != "")
			{
				if (inputText.startsWith('run') && inputText.endsWith('.exe'))
				{
					checkForExe();
				}
				else
				{
					addNewLine("Invalid command."); 
				}
				clearTextBox();
			}
		}
	}
	
	function clearTextBox()
	{
		Textbox.clear();
	}

	function addNewLine(newTxt:String, stillTyping:Bool = true)
	{
		mainText.text += inputText + "\n" + newTxt + (stillTyping ? "\n" + "/" : "");
	}

	function checkForExe()
	{
		var returnText:String = "";
		returnText = inputText;
		returnText = returnText.replace("run" , "");
		returnText = returnText.replace(".exe" , "");

		switch (returnText)
		{
			default:
				addNewLine("Executable not found");
		}
	}
}