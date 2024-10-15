package;

import flixel.FlxG;

class CharacterSelectData
{
	public static function initSave()
    {
        if (FlxG.save.data.savedBfData == null)
			FlxG.save.data.savedBfData = 0;
			
		if (FlxG.save.data.savedBfFormData == null)
			FlxG.save.data.savedBfFormData = 0;
			
		if (FlxG.save.data.savedGfData == null)
			FlxG.save.data.savedGfData = 0;
			
		if (FlxG.save.data.savedGfFormData == null)
			FlxG.save.data.savedGfFormData = 0;
			
		if (FlxG.save.data.hornyGF == null)
			FlxG.save.data.hornyGF = false;
			
		if (FlxG.save.data.canTailsDoll == null)
			FlxG.save.data.canTailsDoll = false;
		
		if (FlxG.save.data.canAutoLoad == null)
			FlxG.save.data.canAutoLoad = false;
		
	}
}