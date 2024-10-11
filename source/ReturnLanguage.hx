package;

import flixel.FlxG;

using StringTools;

class ReturnLanguage
{		
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