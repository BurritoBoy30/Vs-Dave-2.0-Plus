package;

import flixel.FlxG;

using StringTools;

class ReturnLanguage
{		
	public static function console(curText:String)
	{
		var returnString:String;
		
		switch (curText)
		{
			case 'startup':			returnString = txtString('console', 0);
			case 'startinfo':		returnString = txtString('console', 1);
			case 'invalid':			returnString = txtString('console', 2);
			case 'shutdown':		returnString = txtString('console', 3);
			case 'exenotfound':		returnString = txtString('console', 4);
			case 'dispenser':		returnString = txtString('console', 5);
			case 'notallowed':		returnString = txtString('console', 6);
			default:				returnString = curText;
		}
				
		return returnString;
	}
	
	public static function txtString(type:String, num:Int)
	{
		var file:Array<String> = [];
		switch (type)
		{
			case 'ui':
				file = CoolUtil.coolTextFile(Paths.txt('txt/ui'));
			case 'char':
				file = CoolUtil.coolTextFile(Paths.txt('txt/characters'));
			case 'console':
				file = CoolUtil.coolTextFile(Paths.txt('txt/console'));
		}
		
		var extraLine:Int = 0;
		if (FlxG.save.data.gameLanguage == 'pt-br')
			extraLine = 1;
			
		var returnedFile:String;
		returnedFile = file[(num * 2) + extraLine];
		returnedFile = returnedFile.replace(":break:" , "\n");
		return returnedFile;
	}
	
	public static function getLine(curText:String)
	{
		var textFile:Array<String> = CoolUtil.coolTextFile(Paths.txt('txt/linesText_' + FlxG.save.data.gameLanguage));
		
		var returnedString:String = '';
		for (i in 0...textFile.length)
		{
			var currentValue = textFile[i].trim().split('==');
			if (currentValue[0] != curText)
			{
				continue;
			}
			else
			{
				returnedString = currentValue[1];
			}
		}
		
		if (returnedString == '')
		{
			return curText;
		}
		else
		{
			returnedString = returnedString.replace(':break:', '\n');
			returnedString = returnedString.replace(':space:', ' ');
			return returnedString;
		}
	}
}