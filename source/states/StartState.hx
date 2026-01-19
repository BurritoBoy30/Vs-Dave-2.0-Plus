package states;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxState;
import lime.app.Application;
import openfl.Assets;
import states.*;

class StartState extends MusicBeatState
{
	override public function create():Void
	{
		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		SaveDataHandler.initSave();
		
		#if desktop
		DiscordClient.initialize();
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		});
		#end

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