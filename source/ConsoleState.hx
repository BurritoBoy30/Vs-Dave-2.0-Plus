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
	public var dummyText:FlxText;
	var ammountOfLines:Int = 0;
	
	public var inputText:String;

	var startingUp:Bool = true;
	
	var blacklist:Array<String> = ["ESCAPE", "TAB", "ENTER", "ALT", "SHIFT", "CONTROL", "BACKSLASH", "UP", "DOWN", "RIGHT", "LEFT"];

	override function create()
	{
		FlxG.mouse.visible = true;

		mainText = new FlxText(5, 5, "");
		mainText.autoSize = false;
		mainText.size = 16;
		mainText.fieldWidth = 1280;
		mainText.alignment = FlxTextAlign.LEFT;
		add(mainText);
		
		dummyText = new FlxText(5, 5, "");
		dummyText.visible = false;		

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			mainText.text = "\n" + "\n" + "\n" +"          Starting BurritoWorks VSD-SMS...";

			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
				startText();

				startingUp = false;
			});
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!startingUp)
		{
			inputText = dummyText.text;
			
			if (FlxG.keys.justPressed.ENTER && inputText != "")
			{
				if (inputText.startsWith('run') && inputText.endsWith('.exe'))
				{
					checkForExe();
				}
				else if (inputText == 'reset')
				{
					startText();
					ammountOfLines = 0;
					mainText.y = 0;
				}
				else if (inputText == 'exit')
				{
					startingUp = true;
					addNewLine("Shutting down...", false); 
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						FlxG.switchState(new MainMenuState());
					});
				}
				else
				{
					addNewLine("Invalid command."); 
				}
				reset();
			}
			
			if (FlxG.keys.justPressed.ANY)
			{
				changeText(FlxG.keys.getIsDown()[0].ID.toString().toLowerCase());
			}
		}
	}
	
	function changeText(shit:String)
	{
		if (!blacklist.contains(shit.toUpperCase()))
		{
			switch (shit)
			{
				// numbers
				case 'one' | 'numpadone': 			returnInput('1');
				case 'two' | 'numpadtwo':			returnInput('2');
				case 'three' | 'numpadthree': 		returnInput('3');
				case 'four' | 'numpadfour':			returnInput('4');
				case 'five' | 'numpadfive':			returnInput('5');
				case 'six' | 'numpadsix':			returnInput('6');
				case 'seven' | 'numpadseven':		returnInput('7');
				case 'eight' | 'numpadeight':		returnInput('8');
				case 'nine' | 'numpadnine':			returnInput('9');
				case 'zero' | 'numpadzero':			returnInput('0');
				
				//punctuation
				case 'comma':						returnInput(',');
				case 'period' | 'numpadperiod':		returnInput('.');
				case 'semicolon': 					returnInput(';');
				case 'plus' | 'numpadplus':			returnInput('+');
				case 'minus' | 'numpadminus':		returnInput('-');
				case 'lbracket':					returnInput('[');
				case 'rbracket':					returnInput(']');
				case 'quote':						returnInput('"');
					
				//misc
				case 'space':						returnInput(' ');
				case 'backspace':					backSpace();
				default:							returnInput(shit);
			}
		}
	}
	
	function returnInput(input:String)
	{
		mainText.text += input;
		dummyText.text += input;
	}
	
	function backSpace()
	{
		if (inputText != "")
		{
			mainText.text = mainText.text.substring(0, mainText.text.length - 1);
			dummyText.text = dummyText.text.substring(0, dummyText.text.length - 1);
		}
	}
	
	function reset()
	{
		dummyText.text = '';
		inputText = dummyText.text;
	}
	
	function startText()
	{
		mainText.text = "BurritoWorks(R)  VSD-SMS" + "\n"
			+ "(C) Copyright BurritoWorks Corp 2008-2024." + "\n" + "\n"
			+ "Press ENTER to input your text as a command." + "\n"
			+ 'Type "help" to list all the possible commands.' + "\n" + "\n"
			+ "/";
	}

	function addNewLine(newTxt:String, stillTyping:Bool = true)
	{
		mainText.text += "\n" + newTxt + (stillTyping ? "\n" + "/" : "");
		
		if (stillTyping)
			ammountOfLines += 2;
		else
			ammountOfLines += 1;
			
		if(ammountOfLines > 28)
			mainText.y -= 40;
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