package;

import flixel.FlxG;
import Controls.KeyboardScheme;
import Controls.Control;

/**
 * handles save data initialization
*/
class SaveDataHandler
{
	public static var allYourGfs:Array<String> = [];
	
	public static function initSave()
	{		
		if (FlxG.save.data.preloadAtAll == null)
			FlxG.save.data.preloadAtAll = true;
			
		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;
			
		if (FlxG.save.data.middlescroll == null)
			FlxG.save.data.middlescroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.eyesores == null)
			FlxG.save.data.eyesores = true;

		if (FlxG.save.data.donoteclick == null)
			FlxG.save.data.donoteclick = false;
		
		if (FlxG.save.data.eyesoreson == null)
			FlxG.save.data.eyesoreson = true;
			
		// This is for the options
		if(FlxG.save.data.upBind == null)
			FlxG.save.data.upBind = "W";
			
		if(FlxG.save.data.downBind == null)
			FlxG.save.data.downBind = "S";
        
		if(FlxG.save.data.leftBind == null)
			FlxG.save.data.leftBind = "A";

		if(FlxG.save.data.rightBind == null)
			FlxG.save.data.rightBind = "D";

		if(FlxG.save.data.keyStyleChoice == null)
			FlxG.save.data.keyStyleChoice = 0;
			
		switch (FlxG.save.data.keyStyleChoice)
		{
			case 0:
				PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo, true);
			case 1:
				PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Duo, true);
			case 2:
				PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Custom, true);
		}
		
		if (FlxG.save.data.hornyALL == null)
			FlxG.save.data.hornyALL = false;
			
		if (FlxG.save.data.gfTitleNum == null)
			FlxG.save.data.gfTitleNum = 0;
			
		resetGfList();
		
		if (FlxG.save.data.fullScreen == null)
			FlxG.save.data.fullScreen = false;
			
		if (FlxG.save.data.seenWarning == null)
			FlxG.save.data.seenWarning = false;
		
		if (FlxG.save.data.gameLanguage == null)
			FlxG.save.data.gameLanguage = 'en-us';
			
		if (FlxG.save.data.antiAliasing == null)
			FlxG.save.data.antialiasing = true;
			
		if (FlxG.save.data.noteCamera == null)
			FlxG.save.data.noteCamera = true;
			
		if (FlxG.save.data.gfCanSing == null)
			FlxG.save.data.gfCanSing = false;
			
		if (FlxG.save.data.comboRatingLocation == null)
			FlxG.save.data.comboRatingLocation = [0, 0];
			
		if (FlxG.save.data.comboNumbersLocation == null)
			FlxG.save.data.comboNumbersLocation = [0, 0];
			
		if (FlxG.save.data.canIconBounce == null)
			FlxG.save.data.canIconBounce = true;
		
		if (FlxG.save.data.gfTitleTypeIsHorny == null)
			FlxG.save.data.gfTitleTypeIsHorny = true;
			
		if (FlxG.save.data.loadingSplashes == null)
			FlxG.save.data.loadingSplashes = true;
    }
	
	public static function resetGfList()
	{
		if (!FlxG.save.data.hornyALL)
		{	
			allYourGfs = ['gf', 'gf-pixel', 'psyka', 'cyan', 'kaity', 'aymara'];
		}
		else
		{
			if (FlxG.save.data.gfTitleTypeIsHorny)
				allYourGfs = ['gf-hot', 'gf-pixel-hot', 'three-gfs', 'cyan-hot', 'tails-doll'];
			else
				allYourGfs = ['gf', 'gf-pixel', 'psyka', 'cyan', 'kaity', 'aymara'];
		}
	}
}