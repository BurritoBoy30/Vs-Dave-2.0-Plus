package;

import flixel.FlxG;

using StringTools;

class ReturnLanguage
{
	// im lazy enough to not make a function to read .txt files but im competent enough to hard code it to the game
	public static function text(curText:String)
	{
		switch (FlxG.save.data.gameLanguage)
		{	
			case 'pt-br':
				var returnString:String;
				
				switch (curText)
				{
					//playstate
					case 'time':			returnString = 'Tempo';
					case 'score':			returnString = 'Pontuação: ';
					case 'misses':			returnString = 'Falhas: ';
					case 'accuracy':		returnString = 'Precisão: ';
					case 'songcredit':		returnString = 'Música por ';
					
					//freeplay
					case 'personalbest':	returnString = 'RECORDE PESSOAL: ';
					case 'easy':			returnString = 'Fácil';
					case 'normal':			returnString = 'Normal';
					case 'hard':			returnString = 'Difícil';
					case 'extreme':			returnString = 'Extremo';
					case 'stupid':			returnString = 'Estúpido';
					case 'fucked':			returnString = "Você está fudido";
					
					//pause
					case 'resume':			returnString = 'Resumir';
					case 'restart':			returnString = 'Reiniciar Música';
					case 'botplay':			returnString = 'Botplay';
					case 'exit':			returnString = 'Sair para o Menu';
					
					//options
					case 'ghosttapping':	returnString = "Ghost Tapping";
					case 'downscroll':		returnString = 'Downscroll';
					case 'accdisplay':		returnString = 'Display de Precisão';
					case 'naughtiness':		returnString = 'Safadeza';
					case 'changekeys':		returnString = 'Trocar Binds';
					case 'fullscreen':		returnString = 'Fullscreen';
					case 'eyesores':		returnString = 'Efeitos Vibrantes';
					case 'changelang':		returnString = 'Mudar Idioma';
					case 'antialiasing':	returnString = 'Anti Aliasing';
					case 'cammove':			returnString = 'Movimento da Câmera';
					
					//placeholder	
					default:				returnString = 'placeholder';
				}
				
				return returnString;
			default:
				var returnString:String;
				
				switch (curText)
				{
					//playstate
					case 'time':			returnString = 'Time';
					case 'score':			returnString = 'Score: ';
					case 'misses':			returnString = 'Misses: ';
					case 'accuracy':		returnString = 'Accuracy: ';
					case 'songcredit':		returnString = 'Song by ';
					
					//freeplay
					case 'personalbest':	returnString = 'PERSONAL BEST: ';
					case 'easy':			returnString = 'Easy';
					case 'normal':			returnString = 'Normal';
					case 'hard':			returnString = 'Hard';
					case 'extreme':			returnString = 'Extreme';
					case 'stupid':			returnString = 'Stupid';
					case 'fucked':			returnString = "You're fucked";
					
					//pause
					case 'resume':			returnString = 'Resume';
					case 'restart':			returnString = 'Restart Song';
					case 'botplay':			returnString = 'Botplay';
					case 'exit':			returnString = 'Exit to Menu';
					
					//options
					case 'ghosttapping':	returnString = "Ghost Tapping";
					case 'downscroll':		returnString = 'Downscroll';
					case 'accdisplay':		returnString = 'Accuracy Display';
					case 'naughtiness':		returnString = 'Naughtiness';
					case 'changekeys':		returnString = 'Change Binds';
					case 'fullscreen':		returnString = 'Fullscreen';
					case 'eyesores':		returnString = 'Eyesores';
					case 'changelang':		returnString = 'Change Language';
					case 'antialiasing':	returnString = 'Anti Aliasing';
					case 'cammove':			returnString = 'Camera Movement';
					
					//placeholder	
					default:				returnString = 'placeholder';
				}
				
				return returnString;
		}
	}
	
	public static function char(curText:String)
	{
		switch (FlxG.save.data.gameLanguage)
		{
			case 'pt-br':
				var returnString:String;
				
				switch (curText)
				{
					//bf skins
					case 'bf': 					returnString = 'Boyfriend';
					case 'bf-christmas':		returnString = 'Boyfriend (Natal)';
					case 'bf-pixel':			returnString = 'Boyfriend (Pixel)';
					case 'bf-with-gf':			returnString = 'Boyfriend com Girlfriend';
					case 'bf-with-cyan':		returnString = 'Boyfriend com Cyan';
					case 'gf-player':			returnString = 'Girlfriend (Jogável)';
					case 'rapper-gf':			returnString = 'Girlfriend Rapper';
					case 'oruta':				returnString = 'Oruta';
					
					//gf skins
					case 'gf': 					returnString = 'Girlfriend';
					case 'gf-christmas':		returnString = 'Girlfriend (Natal)';
					case 'gf-standing':			returnString = 'Girlfriend (Em Pé)';
					case 'gf-pixel':			returnString = 'Girlfriend (Pixel)';
					case 'psyka':				returnString = 'Psyka';
					case 'psyka-christmas':		returnString = 'Psyka (Natal)';
					case 'psyka-standing':		returnString = 'Psyka (Em Pé)';
					case 'cyan':				returnString = 'Cyan';
					case 'cyan-christmas':		returnString = 'Cyan (Natal)';
					
					//horny gf skins
					case 'gf-hot':				returnString = 'Girlfriend Gostosa';
					case 'gf-hot-funny':		returnString = 'Girlfriend Gostosa (Sex Mod)';
					case 'gf-hot-christmas':	returnString = 'Girlfriend Gostosa (Natal)';
					case 'gf-hot-standing':		returnString = 'Girlfriend Gostosa (Em Pé)';
					case 'gf-massive':			returnString = 'Girlfriend Massiva';
					case 'three-gfs':			returnString = 'Trio Girlfriend';
					case 'gf-trepidation':		returnString = 'Girlfriend Trepidation';
					case 'skyblue':				returnString = 'Skyblue';
					case 'tails-doll':			returnString = 'Tails Doll Peituda';
					
					//placeholder
					default:					returnString = 'Cara';
				}
				
				return returnString;
			default:
				var returnString:String;
				
				switch (curText)
				{
					//bf skins
					case 'bf': 					returnString = 'Boyfriend';
					case 'bf-christmas':		returnString = 'Boyfriend (Christmas)';
					case 'bf-pixel':			returnString = 'Boyfriend (Pixel)';
					case 'bf-with-gf':			returnString = 'Boyfriend w/ Girlfriend';
					case 'bf-with-cyan':		returnString = 'Boyfriend w/ Cyan';
					case 'gf-player':			returnString = 'Girlfriend (Playable)';
					case 'rapper-gf':			returnString = 'Rapper Girlfriend';
					case 'oruta':				returnString = 'Oruta';
					
					//gf skins
					case 'gf': 					returnString = 'Girlfriend';
					case 'gf-christmas':		returnString = 'Girlfriend (Christmas)';
					case 'gf-standing':			returnString = 'Girlfriend (Standing)';
					case 'gf-pixel':			returnString = 'Girlfriend (Pixel)';
					case 'psyka':				returnString = 'Psyka';
					case 'psyka-christmas':		returnString = 'Psyka (Christmas)';
					case 'psyka-standing':		returnString = 'Psyka (Standing)';
					case 'cyan':				returnString = 'Cyan';
					case 'cyan-christmas':		returnString = 'Cyan (Christmas)';
					
					//horny gf skins
					case 'gf-hot':				returnString = 'Hot Girlfriend';
					case 'gf-hot-funny':		returnString = 'Hot Girlfriend (Sex Mod)';
					case 'gf-hot-christmas':	returnString = 'Hot Girlfriend (Christmas)';
					case 'gf-hot-standing':		returnString = 'Hot Girlfriend (Standing)';
					case 'gf-massive':			returnString = 'Massive Girlfriend';
					case 'three-gfs':			returnString = 'The Three Girlfriends';
					case 'gf-trepidation':		returnString = 'Trepidation Girlfriend';
					case 'skyblue':				returnString = 'Skyblue';
					case 'tails-doll':			returnString = 'Busty Tails Doll';
					
					//placeholder
					default:					returnString = 'Face';
				}
				
				return returnString;
		}
	}	
}