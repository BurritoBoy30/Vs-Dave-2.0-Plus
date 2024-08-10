package;

import flixel.FlxG;

using StringTools;

class ReturnLanguage
{
	public static function text(curText:String)
	{
		switch (FlxG.save.data.gameLanguage)
		{
			default:
				var returnString:String;
				
				switch (curText)
				{
					case 'score':
						returnString = 'Score: ';
					default:
						returnString = 'placeholder';
				}
				
				return returnString;
		}
	}
}