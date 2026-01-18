package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxState;
import lime.app.Application;
import openfl.Assets;

class StartState extends MusicBeatState
{
	override public function create():Void
	{	
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