package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

/**
 * handles save data initialization
*/
class SaveDataHandler
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.eyesores == null)
			FlxG.save.data.eyesores = true;

		if (FlxG.save.data.donoteclick == null)
			FlxG.save.data.donoteclick = false;
			
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
    }
}