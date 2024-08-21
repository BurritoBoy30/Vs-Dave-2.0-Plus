package;

import flixel.FlxG;

using StringTools;

class ReturnLanguage
{
	public static function text(curText:String)
	{
		var returnString:String;
		
		switch (curText)
		{
			//playstate
			case 'time':			returnString = txtString('ui', 0);
			case 'score':			returnString = txtString('ui', 1) + " ";
			case 'misses':			returnString = txtString('ui', 2) + " ";
			case 'accuracy':		returnString = txtString('ui', 3) + " ";
			case 'songcredit':		returnString = txtString('ui', 4) + " ";
			
			//freeplay
			case 'personalbest':	returnString = txtString('ui', 5) + " ";
			case 'easy':			returnString = txtString('ui', 6);
			case 'normal':			returnString = txtString('ui', 7);
			case 'hard':			returnString = txtString('ui', 8);
			case 'extreme':			returnString = txtString('ui', 9);
			case 'stupid':			returnString = txtString('ui', 10);
			case 'fucked':			returnString = txtString('ui', 11);
			case 'dave':			returnString = txtString('ui', 26);
			case 'golden':			returnString = txtString('ui', 27);
			case 'joke':			returnString = txtString('ui', 28);
			case 'extra':			returnString = txtString('ui', 29);
			case 'console':			returnString = txtString('ui', 30);
			
			//pause
			case 'resume':			returnString = txtString('ui', 12);
			case 'restart':			returnString = txtString('ui', 13);
			case 'botplay':			returnString = txtString('ui', 14);
			case 'exit':			returnString = txtString('ui', 15);
			
			//options
			case 'ghosttapping':	returnString = txtString('ui', 16);
			case 'downscroll':		returnString = txtString('ui', 17);
			case 'accdisplay':		returnString = txtString('ui', 18);
			case 'naughtiness':		returnString = txtString('ui', 19);
			case 'changekeys':		returnString = txtString('ui', 20);
			case 'fullscreen':		returnString = txtString('ui', 21);
			case 'eyesores':		returnString = txtString('ui', 22);
			case 'changelang':		returnString = txtString('ui', 23);
			case 'antialiasing':	returnString = txtString('ui', 24);
			case 'cammove':			returnString = txtString('ui', 25);
			case 'gfsings':			returnString = txtString('ui', 31);
			
			//placeholder	
			default:				returnString = curText;
		}
		
		return returnString;
	}
	
	public static function char(curText:String)
	{
		var returnString:String;
		
		switch (curText)
		{
			//bf skins
			case 'bf': 					returnString = txtString('char', 0);
			case 'bf-christmas':		returnString = txtString('char', 1);
			case 'bf-pixel':			returnString = txtString('char', 2);
			case 'bf-with-gf':			returnString = txtString('char', 3);
			case 'bf-with-cyan':		returnString = txtString('char', 4);
			case 'gf-player':			returnString = txtString('char', 5);
			case 'rapper-gf':			returnString = txtString('char', 6);
			case 'oruta':				returnString = txtString('char', 7);
			
			//gf skins
			case 'gf': 					returnString = txtString('char', 8);
			case 'gf-christmas':		returnString = txtString('char', 9);
			case 'gf-standing':			returnString = txtString('char', 10);
			case 'gf-pixel':			returnString = txtString('char', 11);
			case 'psyka':				returnString = txtString('char', 12);
			case 'psyka-christmas':		returnString = txtString('char', 13);
			case 'psyka-standing':		returnString = txtString('char', 14);
			case 'cyan':				returnString = txtString('char', 15);
			case 'cyan-christmas':		returnString = txtString('char', 16);
			
			//horny gf skins
			case 'gf-hot':				returnString = txtString('char', 17);
			case 'gf-hot-funny':		returnString = txtString('char', 18);
			case 'gf-hot-christmas':	returnString = txtString('char', 19);
			case 'gf-hot-standing':		returnString = txtString('char', 20);
			case 'gf-massive':			returnString = txtString('char', 21);
			case 'three-gfs':			returnString = txtString('char', 22);
			case 'gf-trepidation':		returnString = txtString('char', 23);
			case 'skyblue':				returnString = txtString('char', 24);
			case 'tails-doll':			returnString = txtString('char', 25);
			
			//placeholder
			default:					returnString = curText;
		}
				
		return returnString;
	}
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
	
	public static function credit(curText:String)
	{
		var returnString:String;
		
		switch (curText)
		{
			case 'supernovae_cred':		returnString = txtString('songcred', 0);
			case 'glitch_cred':			returnString = txtString('songcred', 1);
			case 'cheating_cred':		returnString = txtString('songcred', 2);
			case 'unfairness_cred':		returnString = txtString('songcred', 3);
			case 'mealie_cred':			returnString = txtString('songcred', 4);
			case 'kabunga_cred':		returnString = txtString('songcred', 5);
			default:					returnString = curText;
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
}