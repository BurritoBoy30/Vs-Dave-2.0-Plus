package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songBfChar:Map<String, String> = new Map();
	public static var songGfChar:Map<String, String> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songBfChar:Map<String, String> = new Map<String,String>();
	public static var songGfChar:Map<String, String> = new Map<String,String>();
	#end

	public static function saveScore(song:String, score:Int = 0, bfChar:String, gfChar:String):Void
	{
		var daSong:String = formatSong(song);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score, bfChar, gfChar);
		}
		else
			setScore(daSong, score, bfChar, gfChar);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0):Void
	{
		var daWeek:String = formatSong('week' + week);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score, 'bf', 'gf');
		}
		else
			setScore(daWeek, score, 'bf', 'gf');
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int, bfChar:String, gfChar:String):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		songBfChar.set(song,bfChar);
		songGfChar.set(song,bfChar);
		FlxG.save.data.songScores = songScores;
		FlxG.save.data.songBfChar = songBfChar;
		FlxG.save.data.songGfChar = songGfChar;
		FlxG.save.flush();
	}
	
	static function setBfChar(song:String, char:String):Void
	{
		trace("setchar " + song + ":" + char);
		songBfChar.set(song,char);
		FlxG.save.data.songNames = songBfChar;
		FlxG.save.flush();
	}
	
	static function setGfChar(song:String, char:String):Void
	{
		trace("setchar " + song + ":" + char);
		songGfChar.set(song,char);
		FlxG.save.data.songNames = songGfChar;
		FlxG.save.flush();
	}

	public static function formatSong(song:String):String
	{
		var daSong:String = song;

		return daSong;
	}

	public static function getScore(song:String):Int
	{
		if (!songScores.exists(formatSong(song)))
			setScore(formatSong(song), 0, 'bf', 'gf');

		return songScores.get(formatSong(song));
	}
	
	public static function getBfChar(song:String):String
	{
		if (songBfChar == null)
			return "ERROR";
		if (!songBfChar.exists(formatSong(song)))
		{
			setBfChar(formatSong(song),"bf");
			return "bf";
		}
		return songBfChar.get(formatSong(song));
	}
	
	public static function getGfChar(song:String):String
	{
		if (songBfChar == null)
			return "ERROR";
		if (!songGfChar.exists(formatSong(song)))
		{
			setGfChar(formatSong(song),"gf");
			return "gf";
		}
		return songGfChar.get(formatSong(song));
	}

	public static function getWeekScore(week:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week)))
			setScore(formatSong('week' + week), 0, 'bf', 'gf');

		return songScores.get(formatSong('week' + week));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;
		
		if (FlxG.save.data.songBfChar != null)
			songBfChar = FlxG.save.data.songBfChar;
			
		if (FlxG.save.data.songGfChar != null)
			songGfChar = FlxG.save.data.songGfChar;
			
	}
}
