package;

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

	private var AllPossibleSongs:Array<String> = ["Dave","Joke","Extra"];

	private var CurrentPack:Int = 0;

	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;
	
	var zoeyBop:FlxSprite;

	override function create()
	{		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);
		
		CurrentSongIcon = new FlxSprite(0,0).loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));

		CurrentSongIcon.centerOffsets(false);
		CurrentSongIcon.x = (FlxG.width / 2) - 256;
		CurrentSongIcon.y = (FlxG.height / 2) - 256;
		CurrentSongIcon.antialiasing = true;

		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.x = (FlxG.width / 2) - 162;
		Highscore.load();
		add(NameAlpha);

		add(CurrentSongIcon);

		super.create();
	}
	
	public function LoadProperPack()
	{
		switch (AllPossibleSongs[CurrentPack].toLowerCase())
		{
			case 'dave':
				addWeek(['Tutorial'], 0, ['gf'], ['Easy']);
				addWeek(['House', 'Insanity', 'Polygonized'], 1, ['dave', 'dave', 'dave-angey'], ['Hard', 'Normal', 'Hard']);
				addWeek(['Blocked','Corn-Theft','Maze',], 2, ['bambi'], ['Hard', 'Normal', 'Normal']);
				addWeek(['Splitathon'],3,['the-duo'], ['Hard']);
				
			case 'joke':
				addWeek(['Cheating'], 2, ['bambi-3d'], ['Stupid']);
			
			case 'extra':
				addWeek(['Bonus-Song'], 1 ,['dave'], ['Hard']);
		}
	}
	
	function GoToActualFreeplay()
	{
		zoeyBop = new FlxSprite(700, 95);
		zoeyBop.frames = Paths.getSparrowAtlas('zoey', 'preload');
		zoeyBop.animation.addByPrefix('jiggle', 'jiggle', 10, true);
		zoeyBop.animation.play('jiggle');
		zoeyBop.setGraphicSize(Std.int(zoeyBop.width * 1.5));
		zoeyBop.alpha = 0;
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

		scoreText = new FlxText(-5, 5, FlxG.width, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.alpha = 0;

		scoreBG = new FlxSprite(0, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, FlxG.width, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		diffText.alpha = 0;
		add(diffText);

		add(scoreText);
		
		FlxTween.tween(scoreBG,{alpha: 0.6},0.2,{ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText,{alpha: 1},0.2,{ease: FlxEase.expoInOut});
		FlxTween.tween(diffText,{alpha: 1},0.2,{ease: FlxEase.expoInOut});
		FlxTween.tween(zoeyBop,{alpha: 1},0.2,{ease: FlxEase.expoInOut});

		changeSelection();
	}
		
	override function beatHit()
	{
		super.beatHit();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, diffculty:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, diffculty));
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
		NameAlpha.destroy();
		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.x = (FlxG.width / 2) - 164;
		add(NameAlpha);
		CurrentSongIcon.loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, diffculty:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		var anotherNum:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], diffculty[anotherNum]);

			if (songCharacters.length != 1)
				num++;
			
			if (diffculty.length != 1)
				anotherNum++;
		}
	}

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
		
		if (!InMainFreeplayState) 
		{
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

				canInteract = false;
				
				new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
				{
					loadingPack = true;
					LoadProperPack();
					
					FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.2);
					FlxTween.tween(NameAlpha, {alpha: 0}, 0.2);
					
					new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
					{
						CurrentSongIcon.visible = false;
						NameAlpha.visible = false;
						GoToActualFreeplay();
						InMainFreeplayState = true;
						loadingPack = false;
						canInteract = true;
					});
				});
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
					FlxTween.tween(i, {alpha: 0}, 0.3);
				}
				
				for (i in grpSongs)
				{
					//i.unlockY = true;

					FlxTween.tween(i, {alpha: 0}, 0.3, {onComplete: function(twn:FlxTween)
					{
						i.unlockY = false;
						
						CurrentSongIcon.visible = true;
						NameAlpha.visible = true;
						FlxTween.tween(CurrentSongIcon, {alpha: 1}, 0.2);
						FlxTween.tween(NameAlpha, {alpha: 1}, 0.2);
						
						if (scoreBG != null)
						{
							FlxTween.tween(scoreBG,{alpha: 0},0.2, {onComplete: function(twn:FlxTween)
							{
								scoreBG = null;
							}});
						}
						
						if (scoreText != null)
						{
							FlxTween.tween(scoreText,{alpha: 0},0.2, {onComplete: function(twn:FlxTween)
							{
								scoreText = null;
							}});
						}
						
						if (diffText != null)
						{
							FlxTween.tween(diffText,{alpha: 0},0.2, {onComplete: function(twn:FlxTween)
							{
								diffText = null;
							}});
						}
						
						if (zoeyBop != null)
						{
							FlxTween.tween(zoeyBop,{alpha: 0},0.2, {onComplete: function(twn:FlxTween)
							{
								zoeyBop = null;
							}});
						}
						
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
					}});
				}
			}

			if (accepted && canInteract)
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase());

				trace(poop);

				PlayState.SONG = Song.loadFromJson(songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;

				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.loadAndSwitchState(new CharacterSelectState());
			}
		}
		
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
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
		
		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
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
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
	
	function updateScore()
	{
		diffText.text = songs[curSelected].diffculty + " - (" + curBfChar.toUpperCase() + " - " + curGfChar.toUpperCase() + ")";
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var diffculty:String = "";

	public function new(song:String, week:Int, songCharacter:String, diffculty:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.diffculty = diffculty;
	}
}
