package states;

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

	var mainBG:FlxSprite = new FlxSprite();
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
	var AllSongPackImages:Array<String> = [];
	var packAmmount:Int;

	private var CurrentPack:Int = 0;

	private var NameAlpha:FlxText;
	private var PackDescription:FlxText;
	var PackList:FlxSprite;
	var zoeyBop:FlxSprite;
	
	var select_button:Button;
	var return_button:Button;
	var selection_left:Button;
	var selection_right:Button;
	var go_play:Button;
	
	var loadingPack:Bool = false;
	var iconBoopin:Bool = false;
	
	var lilText:FlxText;
	var modes:Array<String> = ["Normal", "Alt"];
	var selectedmode:Int = 0;
	
	var songColors:Array<FlxColor> = [
		0xFFA5004D, //tutorial, fnfgf
		0xFF0F5FFF, //dave
		0xFFFF9583, //dave 3d
		0xFF25BF37, //bambi
		0xFF00FFFF, //split a thon
		0xFF9271FD, //og
		0xFFC7A4A5, //ringi
		0xFF653303, //cakebi
		0xFF6F4447, //dale
		0xFFB3B3B3, //bambi bass
		0xFFFF0000, //unfair, your demise
		0xFF332019, //kabunga
		0xFF211952, //computer
		0xFF8E070A, //corridor
		0xFFF6F6F5, //disposition, mekatsune
		0xFF60AB24, //decimal
		0xFF2C2C2C, //recursed
		0xFF852424, //boing
		0xFFCBCCCC, //rules, malware madness
		0xFFE3B756, //unstoppable
		0xFFBC0102, //terminatexs
		0xFFFF7B00 //sunshine
	];

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In Freeplay Menu", null);
		#end
		
		if (FlxG.save.data.hornyALL)
		{
			AllPossibleSongs = ["Dave","Golden","Joke","Extra","Naughty","Console"];
			packAmmount = 6;
			
			AllSongPackImages = [
				Paths.image('packs/week_icons_dave', 'preload'),
				Paths.image('packs/week_icons_golden', 'preload'),
				Paths.image('packs/week_icons_joke', 'preload'),
				Paths.image('packs/week_icons_extra', 'preload'),
				Paths.image('packs/week_icons_naughty', 'horny'),
				Paths.image('packs/week_icons_whores', 'horny'),
			];
		}
		else
		{
			AllPossibleSongs = ["Dave","Golden","Joke","Extra"];
			packAmmount = 4;
			
			AllSongPackImages = [
				Paths.image('packs/week_icons_dave', 'preload'),
				Paths.image('packs/week_icons_golden', 'preload'),
				Paths.image('packs/week_icons_joke', 'preload'),
				Paths.image('packs/week_icons_extra', 'preload')
			];
		}
		
		mainBG = new FlxSprite().loadGraphic(Paths.image(MainMenuState.randomizeBG(), 'preload'));
		mainBG.antialiasing = FlxG.save.data.antiAliasing;
		mainBG.color = 0xFF9271FD;
		add(mainBG);
		
		CurrentSongIcon = new FlxSprite().loadGraphic(AllSongPackImages[CurrentPack]);
		CurrentSongIcon.screenCenter();
		CurrentSongIcon.x -= 300;
		CurrentSongIcon.y -= 50;
		changePackAntiAliasing();

		NameAlpha = new FlxText(675, (FlxG.height / 2) - 300, FlxG.width, ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase()));
		NameAlpha.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		NameAlpha.borderSize = 3;
		NameAlpha.antialiasing = FlxG.save.data.antiAliasing;
		
		PackDescription = new FlxText(675, NameAlpha.y + 150, (FlxG.width / 2.5), ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase() + "_desc"));
		PackDescription.setFormat(Paths.font("comic.ttf"), 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		PackDescription.borderSize = 2;
		PackDescription.antialiasing = FlxG.save.data.antiAliasing;
		
		PackList = new FlxSprite(0, 0);
		PackList.frames = Paths.getSparrowAtlas('freeplay/freeplayPackList' + packAmmount, 'preload');
		PackList.x = (FlxG.width / 2) - (PackList.width / 2);
		PackList.y = FlxG.height - PackList.height;
		PackList.antialiasing = FlxG.save.data.antiAliasing;
		for (i in 0...packAmmount)
		{
			PackList.animation.addByPrefix('pack' + i, 'pack' + i + ' ', 1, true);
		}
		PackList.animation.play('pack0');
		
		select_button = new Button(0, 0, Button.loadOffset('correction'), 'freeplay/select_' + FlxG.save.data.gameLanguage, 'preload');
		select_button.x = (FlxG.width / 2) - (select_button.width / 2);
		select_button.y = FlxG.height - (PackList.height * 2) - 5;
		add(select_button);
		
		return_button = new Button(5, 0, Button.loadOffset('correction'), 'freeplay/return_' + FlxG.save.data.gameLanguage, 'preload');
		return_button.y = FlxG.height - return_button.height - 5;
		add(return_button);
		
		selection_left = new Button(0, PackList.y - 5, Button.loadOffset('correction'), 'freeplay/selection', 'preload');
		selection_left.x = PackList.x - (selection_left.width + 5);
		add(selection_left);
		
		selection_right = new Button(0, PackList.y - 5, Button.loadOffset('correction'), 'freeplay/selection', 'preload');
		selection_right.x = PackList.x + PackList.width + 5;
		selection_right.flipX = true;
		add(selection_right);
		
		add(CurrentSongIcon);
		add(NameAlpha);
		add(PackDescription);
		add(PackList);
		
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
		zoeyBop.frames = Paths.getSparrowAtlas('zoey', 'horny');
		zoeyBop.animation.addByPrefix('jiggle', 'jiggle', 10, true);
		zoeyBop.animation.play('jiggle');
		zoeyBop.setGraphicSize(Std.int(zoeyBop.width * 1.5));
		zoeyBop.alpha = 0;
		zoeyBop.visible = FlxG.save.data.hornyALL;
		insert(members.indexOf(return_button), zoeyBop);
		
		grpSongs = new FlxTypedGroup<Alphabet>();
		insert(members.indexOf(return_button), grpSongs);

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
			insert(members.indexOf(return_button), icon);

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
		insert(members.indexOf(return_button), scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 40, FlxG.width, "", 24);
		diffText.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, RIGHT);
		diffText.antialiasing = FlxG.save.data.antiAliasing;
		diffText.alpha = 0;
		insert(members.indexOf(return_button), diffText);
		
		lilText = new FlxText(scoreText.x, scoreText.y + 80, FlxG.width, "", 24);
		lilText.setFormat(Paths.font("comic.ttf"), 26, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		lilText.antialiasing = FlxG.save.data.antiAliasing;
		lilText.visible = false;
		lilText.alpha = 0;
		insert(members.indexOf(return_button), lilText);
		changefnfgfmode(0);

		insert(members.indexOf(return_button), scoreText);
		
		go_play = new Button(0, 0, Button.loadOffset('correction'), 'freeplay/goPlay_' + FlxG.save.data.gameLanguage, 'preload');
		go_play.x = FlxG.width - go_play.width - 5;
		go_play.y = FlxG.height - go_play.height - 5;
		insert(members.indexOf(return_button), go_play);
		
		FlxTween.tween(scoreBG, {alpha: 0.6}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(diffText, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(zoeyBop, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(lilText, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(go_play, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
		
		changeSelection();
	}
		
	override function beatHit()
	{
		super.beatHit();
		
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
			CurrentPack = AllPossibleSongs.length - 1;
		if (CurrentPack == AllPossibleSongs.length)
			CurrentPack = 0;
			
		NameAlpha.text = ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase());
		PackDescription.text = ReturnLanguage.getLine(AllPossibleSongs[CurrentPack].toLowerCase() + "_desc");
		PackList.animation.play('pack' + CurrentPack);
		CurrentSongIcon.loadGraphic(AllSongPackImages[CurrentPack]);
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
			CurrentSongIcon.antialiasing = FlxG.save.data.antiAliasing;
		}
	}

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		
		select_button.setPermition = !InMainFreeplayState && !loadingPack && canInteract;
		return_button.setPermition = canInteract;
		selection_left.setPermition = !InMainFreeplayState && canInteract;
		selection_right.setPermition = !InMainFreeplayState && canInteract;
		
		if (go_play != null)
			go_play.setPermition = InMainFreeplayState && canInteract;

		super.update(elapsed);
		
		if (!InMainFreeplayState) 
		{
			iconBoopin = false;
			scoreBG = null;
			scoreText = null;
			diffText = null;
			zoeyBop = null;
			lilText = null;
			go_play = null;
			
			selection_left.callback = function()
			{
				UpdatePackSelection(-1);
			}
			selection_right.callback = function()
			{
				UpdatePackSelection(1);
			};
			
			select_button.callback = function()
			{	
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				 
				if (AllPossibleSongs[CurrentPack].toLowerCase() == 'console')
				{
					FlxG.switchState(new DispenserBurstState());
				}
				else
				{
					canInteract = false;
					loadingPack = true;
					LoadProperPack(AllPossibleSongs[CurrentPack].toLowerCase());
					
					for(everything in [CurrentSongIcon, NameAlpha, PackDescription, PackList, selection_left, selection_right, select_button])
					{
						FlxTween.tween(everything, {alpha: 0}, 0.2);
					}
					
					new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
					{
						for(everything in [CurrentSongIcon, NameAlpha, PackDescription, PackList, selection_left, selection_right, select_button])
						{
							everything.visible = false;
						}
						GoToActualFreeplay();
						InMainFreeplayState = true;
						loadingPack = false;
						canInteract = true;
					});
				}
			};
			
			return_button.callback = function()
			{
				FlxG.switchState(new MainMenuState());
			};
		
			return;
		}
		else
		{
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;

			if (FlxG.mouse.wheel > 0 && canInteract)
			{
				changeSelection(-1);
			}
			if (FlxG.mouse.wheel < 0 && canInteract)
			{
				changeSelection(1);
			}
			
			lilText.visible = songs[curSelected].songName.toLowerCase() == 'fnfgf' || songs[curSelected].songName.toLowerCase() == 'terminatexs';
			
			if (songs[curSelected].songName.toLowerCase() == 'fnfgf' || songs[curSelected].songName.toLowerCase() == 'terminatexs')
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
			
			return_button.callback = function()
			{			
				loadingPack = true;
				canInteract = false;
				
				FlxTween.color(mainBG, 0.25, mainBG.color, 0xFF9271FD);
				
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
				
				if (go_play != null)
				{
					FlxTween.tween(go_play, {alpha: 0}, 0.2, {onComplete: function(twn:FlxTween)
					{
						go_play = null;
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
					for(everything in [CurrentSongIcon, NameAlpha, PackDescription, PackList, selection_left, selection_right, select_button])
					{
						everything.visible = true;
						FlxTween.tween(everything, {alpha: 1}, 0.2);
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
				});
			};
			
			go_play.callback = function()
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase());

				trace(poop);

				PlayState.SONG = Song.loadFromJson(songs[curSelected].songName.toLowerCase());
					
				switch (songs[curSelected].songName.toLowerCase())
				{
					case 'fnfgf' | 'unstoppable' | 'mekatsune' | 'sunshine':
						LoadingState.loadAndSwitchState(new PlayState());
					default:
						LoadingState.loadAndSwitchState(new CharacterSelectState());
				}
			};
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
		FlxTween.color(mainBG, 0.25, mainBG.color, songColors[songs[curSelected].week]);
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
		PlayState.altType = modes[selectedmode].toLowerCase();
		lilText.text = "< " + modes[selectedmode] + " >";
	}
	
	function updateScore()
	{
		switch (songs[curSelected].songName.toLowerCase())
		{
			case 'fnfgf' | 'unstoppable' | 'mekatsune' | 'sunshine':
				diffText.text = ReturnLanguage.getLine(songs[curSelected].diffculty.toUpperCase());
			default:
				if (CharacterSelectState.noGfChar.contains(curBfChar.toLowerCase()) || (['boing', 'your-demise'].contains(songs[curSelected].songName.toLowerCase())))
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
