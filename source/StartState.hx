package;

import flixel.FlxG;
import flixel.FlxState;

class StartState extends MusicBeatState
{
	override public function create():Void
	{
		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		SaveDataHandler.initSave();

		Highscore.load();
		
		FlxG.fullscreen = FlxG.save.data.fullScreen;
		
		if (FlxG.save.data.seenWarning)
		{
			FlxG.switchState(new TitleState());
		}
		else
		{
			FlxG.switchState(new WarningState());
		}
		
		super.create();
	}
}