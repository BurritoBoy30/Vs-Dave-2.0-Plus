package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;

	var scoreText:FlxText;
	var diffText:FlxText;
	var scoreBG:FlxSprite;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	
	private var curBfChar:String = "bf";
	private var curGfChar:String = "gf";

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var InMainFreeplayState:Bool = false;
	var canInteract:Bool = true;

	private var iconArray:Array<HealthIcon> = [];
	
	private var CurrentSongIcon:FlxSprite;

	public var AllPossibleSongs:Array<String> = [];

	private var CurrentPack:Int = 0;

	private var NameAlpha:FlxText;
	private var PackDescription:FlxText;

	var loadingPack:Bool = false;

	var zoeyBop:FlxSprite;
	var iconBoopin:Bool = false;
	
	var lilText:FlxText;
	var modes:Array<String> = ["Normal", "Alt"];
	var selectedmode:Int = 0;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In Freeplay Menu", null);
		#end
		
		if (FlxG.save.data.hornyALL)
		{
			AllPossibleSongs = ["Dave","Golden","Joke","Extra","Naughty","Console"];
		}
		else
		{
			AllPossibleSongs = ["Dave","Golden","Joke","Extra","Console"];
		}
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image(MainMenuState.randomizeBG(), 'preload'));
		bg.antialiasing = FlxG.save.data.antiAliasing;
		bg.color = 0xFF9271FD;
		add(bg);
		
		CurrentSongIcon = new FlxSprite().loadGraphic(Paths.image('packs/week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));
		CurrentSongIcon.screenCenter();
		CurrentSongIcon.x -= 300;
		changePackAntiAliasing();

		NameAlpha = new FlxText(675, (FlxG.height / 2) - 300, FlxG.width, ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase()));
		NameAlpha.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		NameAlpha.borderSize = 3;
		NameAlpha.antialiasing = FlxG.save.data.antiAliasing;
		
		PackDescription = new FlxText(675, NameAlpha.y + 150, (FlxG.width / 2.5), ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase() + "_desc"));
		PackDescription.setFormat(Paths.font("comic.ttf"), 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		PackDescription.borderSize = 2;
		PackDescription.antialiasing = FlxG.save.data.antiAliasing;
		
		add(CurrentSongIcon);
		add(NameAlpha);
		add(PackDescription);
		
		Highscore.load();

		super.create();
	}
	
	// replaced with reading txt files, easier for modifications
	public function LoadProperPack(textFile:String)
	{
		var fuckingfreeplay:Array<String> = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist/' + textFile));
		
		for (songList in fuckingfreeplay)
		{
			var songInfo:Array<String> = songList.split(",");
			
			addWeek([songInfo[0]], Std.parseInt(songInfo[1]), [songInfo[2]], [songInfo[3]], [Std.parseInt(songInfo[4])]);
		}
	}
	
	function GoToActualFreeplay()
	{
		zoeyBop = new FlxSprite(700, 100);
		zoeyBop.frames = Paths.getSparrowAtlas('hornyshit/zoey', 'preload');
		zoeyBop.animation.addByPrefix('jiggle', 'jiggle', 10, true);
		zoeyBop.animation.play('jiggle');
		zoeyBop.setGraphicSize(Std.int(zoeyBop.width * 1.5));
		zoeyBop.alpha = 0;
		zoeyBop.visible = FlxG.save.data.hornyALL;
		add(zoeyBop);
		
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(-5, -5, FlxG.width, "", 32);
		scoreText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.antialiasing = FlxG.save.data.antiAliasing;
		scoreText.alpha = 0;

		scoreBG = new FlxSprite(0, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 40, FlxG.width, "", 24);
		diffText.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, RIGHT);
		diffText.antialiasing = FlxG.save.data.antiAliasing;
		diffText.alpha = 0;
		add(diffText);
		
		lilText = new FlxText(scoreText.x, scoreText.y + 80, FlxG.width, "", 24);
		lilText.setFormat(Paths.font("comic.ttf"), 26, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		lilText.antialiasing = FlxG.save.data.antiAliasing;
		lilText.visible = false;
		lilText.alpha = 0;
		add(lilText);
		changefnfgfmode(0);

		add(scoreText);
		
		FlxTween.tween(scoreBG, {alpha: 0.6}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(diffText, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(zoeyBop, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(lilText, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});

		changeSelection();
	}
		
	override function beatHit()
	{
		super.beatHit();
		
		if (curBeat % 2 == 0 && iconBoopin)
			FlxTween.tween(FlxG.camera, {zoom:1.05}, Conductor.crochet / 1300, {ease: FlxEase.quadOut, type: BACKWARD});
			
		if (iconBoopin)
		{
			FlxTween.tween(iconArray[curSelected].scale, {x: iconArray[curSelected].realSize + 0.2, y: iconArray[curSelected].realSize + 0.2}, Conductor.crochet / 1300, {ease: FlxEase.quadOut, type: BACKWARD});
		}
	}
	
	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, diffculty:Array<String>, bpm:Array<Int>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		var anotherNum:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], diffculty[anotherNum], bpm[anotherNum]);

			if (songCharacters.length != 1)
				num++;
			
			if (diffculty.length != 1)
				anotherNum++;
		}
	}
	
	public function addSong(songName:String, weekNum:Int, songCharacter:String, diffculty:String, bpm:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, ReturnLanguage.getLine(diffculty.toLowerCase()), bpm));
	}
	
	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
		{
			CurrentPack = AllPossibleSongs.length - 1;
		}
		if (CurrentPack == AllPossibleSongs.length)
		{
			CurrentPack = 0;
		}
		NameAlpha.text = ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase());
		PackDescription.text = ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase() + "_desc");
		CurrentSongIcon.loadGraphic(Paths.image('packs/week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));
		changePackAntiAliasing();
	}
	
	function changePackAntiAliasing()
	{
		if (AllPossibleSongs[CurrentPack].toLowerCase() == 'naughty')
		{
			CurrentSongIcon.antialiasing = false;
		}
		else
		{
			CurrentSongIcon.antialiasing = CurrentSongIcon.antialiasing = FlxG.save.data.antiAliasing;
		}
	}

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
		
		if (!InMainFreeplayState) 
		{
			iconBoopin = false;
			scoreBG = null;
			scoreText = null;
			diffText = null;
			zoeyBop = null;
			
			if (controls.LEFT_P && canInteract)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P && canInteract)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack && canInteract)
			{	
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				 
				if (AllPossibleSongs[CurrentPack].toLowerCase() == 'console')
				{
					FlxG.switchState(new ConsoleState());
				}
				else
				{
					canInteract = false;
					loadingPack = true;
					LoadProperPack(AllPossibleSongs[CurrentPack].toLowerCase());
					
					FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.2);
					FlxTween.tween(NameAlpha, {alpha: 0}, 0.2);
					FlxTween.tween(PackDescription, {alpha: 0}, 0.2);
					
					new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
					{
						CurrentSongIcon.visible = false;
						NameAlpha.visible = false;
						PackDescription.visible = false;
						GoToActualFreeplay();
						InMainFreeplayState = true;
						loadingPack = false;
						canInteract = true;
					});
				}
			}
			if (controls.BACK && canInteract)
			{
				FlxG.switchState(new MainMenuState());
			}	
		
			return;
		}
		else
		{
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;

			if (upP && canInteract)
			{
				changeSelection(-1);
			}
			if (downP && canInteract)
			{
				changeSelection(1);
			}
			
			lilText.visible = songs[curSelected].songName.toLowerCase() == 'fnfgf';
			
			if (songs[curSelected].songName.toLowerCase() == 'fnfgf')
			{
				if (controls.LEFT_P && canInteract)
				{
					changefnfgfmode(-1);
				}
				if (controls.RIGHT_P && canInteract)
				{
					changefnfgfmode(1);
				}
			}
			
			iconBoopin = true;
			
			if (scoreBG != null)
			{
				if (scoreText.textField.textWidth < diffText.textField.textWidth)
					scoreBG.scale.x = diffText.textField.textWidth + 12;
				else
					scoreBG.scale.x = scoreText.textField.textWidth + 12;
					
				scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
			}
			
			if (controls.BACK && canInteract)
			{				
				loadingPack = true;
				canInteract = false;
				
				for (i in iconArray)
				{
					FlxTween.tween(i, {alpha: 0}, 0.2);
				}
				
				for (i in grpSongs)
				{
					FlxTween.tween(i, {alpha: 0}, 0.2, {onComplete: function(twn:FlxTween)
					{
						i.unlockY = false;	
					}});
				}
				
				if (scoreBG != null)
				{
					FlxTween.tween(scoreBG, {alpha: 0}, 0.2, {onComplete: function(twn:FlxTween)
					{
						scoreBG = null;
					}});
				}
				
				if (scoreText != null)
				{
					FlxTween.tween(scoreText, {alpha: 0}, 0.2, {onComplete: function(twn:FlxTween)
					{
						scoreText = null;
					}});
				}
				
				if (diffText != null)
				{
					FlxTween.tween(diffText, {alpha: 0}, 0.2, {onComplete: function(twn:FlxTween)
					{
						diffText = null;
					}});
				}
				
				if (lilText != null)
				{
					FlxTween.tween(lilText, {alpha: 0}, 0.2, {onComplete: function(twn:FlxTween)
					{
						lilText = null;
					}});
				}
				
				if (zoeyBop != null)
				{
					FlxTween.tween(zoeyBop, {alpha: 0}, 0.2, {onComplete: function(twn:FlxTween)
					{
						zoeyBop = null;
					}});
				}
				
				new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
				{
					CurrentSongIcon.visible = true;
					NameAlpha.visible = true;
					PackDescription.visible = true;
					FlxTween.tween(CurrentSongIcon, {alpha: 1}, 0.2);
					FlxTween.tween(NameAlpha, {alpha: 1}, 0.2);
					FlxTween.tween(PackDescription, {alpha: 1}, 0.2);
					
					InMainFreeplayState = false;
					loadingPack = false;
					for (i in grpSongs) { remove(i); }
					for (i in iconArray) { remove(i); }
						
					// MAKE SURE TO RESET EVERYTHIN!
					songs = [];
					grpSongs.members = [];
					iconArray = [];
					curSelected = 0;
					canInteract = true;
				});
			}

			if (accepted && canInteract)
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase());

				trace(poop);

				PlayState.SONG = Song.loadFromJson(songs[curSelected].songName.toLowerCase());
				
				switch (songs[curSelected].songName.toLowerCase())
				{
					case 'fnfgf' | 'unstoppable' | 'mekatsune' | 'sunshine':
						if (songs[curSelected].songName.toLowerCase() == 'fnfgf')
							PlayState.gfvideotype = modes[selectedmode].toLowerCase();
							
						LoadingState.loadAndSwitchState(new PlayState());
					default:
						LoadingState.loadAndSwitchState(new CharacterSelectState());
				}
			}
		}
		
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = ReturnLanguage.getLine('personalbest') + lerpScore;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName);
		// lerpScore = 0;
		#end
		curBfChar = Highscore.getBfChar(songs[curSelected].songName);
		curGfChar = Highscore.getGfChar(songs[curSelected].songName);
		updateScore();
		Conductor.changeBPM(songs[curSelected].bpm);

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
			iconArray[i].scale.set(iconArray[i].realSize,iconArray[i].realSize);
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
	
	public function changefnfgfmode(change:Int)
	{
		selectedmode += change;
		if (selectedmode == -1)
		{
			selectedmode = modes.length - 1;
		}
		if (selectedmode == modes.length)
		{
			selectedmode = 0;
		}
		lilText.text = "< " + modes[selectedmode] + " >";
	}
	
	function updateScore()
	{
		switch (songs[curSelected].songName.toLowerCase())
		{
			case 'fnfgf' | 'unstoppable' | 'mekatsune' | 'sunshine':
				diffText.text = ReturnLanguage.getLine(songs[curSelected].diffculty.toUpperCase());
			default:
				if (CharacterSelectState.noGfChar.contains(curBfChar.toLowerCase()) || songs[curSelected].songName.toLowerCase() == 'boing')
					diffText.text = ReturnLanguage.getLine(songs[curSelected].diffculty.toUpperCase()) + " - (" + curBfChar.toUpperCase() + ")";
				else
				{
					if (!FlxG.save.data.hornyALL && CharacterSelectState.hornyGFs.contains(curGfChar.toLowerCase()))
						diffText.text = ReturnLanguage.getLine(songs[curSelected].diffculty.toUpperCase()) + " - (" + curBfChar.toUpperCase() + " - " + 'GF' + ")";
					else
						diffText.text = ReturnLanguage.getLine(songs[curSelected].diffculty.toUpperCase()) + " - (" + curBfChar.toUpperCase() + " - " + curGfChar.toUpperCase() + ")";
				}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var diffculty:String = "";
	public var bpm:Int = 0;

	public function new(song:String, week:Int, songCharacter:String, diffculty:String, bpm:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.diffculty = diffculty;
		this.bpm = bpm;
	}
}
