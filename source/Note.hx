package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var finishedGenerating:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var LocalScrollSpeed:Float = 1;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	
	public var noteStyle:String = "normal";

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	
	private var notetolookfor = 0;

	public var MyStrum:FlxSprite;

	private var InPlayState:Bool = false;

	public static var CharactersWith3D:Array<String> = ["dave-angey", "bambi-3d", 'bambi-unfair', 'dave-split-3d', 'bambi-piss-3d', 'exbungo'];

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal")
	{
		super();
		
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		
		this.noteStyle = noteStyle;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime + FlxG.save.data.offset;

		this.noteData = noteData;

		if (((CharactersWith3D.contains(PlayState.dad.curCharacter) && !musthit)
			|| (CharactersWith3D.contains(PlayState.boyfriend.curCharacter) && musthit))
			|| ((CharactersWith3D.contains(PlayState.dad.curCharacter) || CharactersWith3D.contains(PlayState.boyfriend.curCharacter))
			&& ((this.strumTime / 50) % 20 > 10)))
		{
			this.noteStyle = '3d';
			frames = Paths.getSparrowAtlas('notes/NOTE_assets_3D');
			animList();
			antialiasing = FlxG.save.data.antiAliasing;
		}
		else if (PlayState.boyfriend.curCharacter == 'bf-pixel' && musthit)
		{
			this.noteStyle = 'pixel';
			loadGraphic(Paths.image('notes/NOTE_assets_pixel'), true, 17, 17);

			animation.add('greenScroll', [6]);
			animation.add('redScroll', [7]);
			animation.add('blueScroll', [5]);
			animation.add('purpleScroll', [4]);

			if (isSustainNote)
			{
				loadGraphic(Paths.image('notes/NOTE_assetsENDS'), true, 7, 6);

				animation.add('purpleholdend', [4]);
				animation.add('greenholdend', [6]);
				animation.add('redholdend', [7]);
				animation.add('blueholdend', [5]);

				animation.add('purplehold', [0]);
				animation.add('greenhold', [2]);
				animation.add('redhold', [3]);
				animation.add('bluehold', [1]);
			}

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			updateHitbox();

		}
		else
		{
			frames = Paths.getSparrowAtlas('notes/NOTE_assets');

			animList();
			antialiasing = FlxG.save.data.antiAliasing;
		}

		if (PlayState.SONG.song.toLowerCase() == "cheating")
		{
			switch (noteData)
			{
				case 0:
					x += swagWidth * 3;
					notetolookfor = 3;
					animation.play('purpleScroll');
				case 1:
					x += swagWidth * 1;
					notetolookfor = 1;
					animation.play('blueScroll');
				case 2:
					x += swagWidth * 0;
					notetolookfor = 0;
					animation.play('greenScroll');
				case 3:
					notetolookfor = 2;
					x += swagWidth * 2;
					animation.play('redScroll');
			}
			flipY = (Math.round(Math.random()) == 0); //fuck you
			flipX = (Math.round(Math.random()) == 1);
		}
		else
		{
			switch (noteData)
			{
				case 0:
					x += swagWidth * 0;
					notetolookfor = 0;
					animation.play('purpleScroll');
				case 1:
					notetolookfor = 1;
					x += swagWidth * 1;
					animation.play('blueScroll');
				case 2:
					notetolookfor = 2;
					x += swagWidth * 2;
					animation.play('greenScroll');
				case 3:
					notetolookfor = 3;
					x += swagWidth * 3;
					animation.play('redScroll');
			}
		}
		
		if (Type.getClassName(Type.getClass(FlxG.state)).contains("PlayState") && (PlayState.SONG.song.toLowerCase() == 'cheating' || PlayState.SONG.song.toLowerCase() == 'unfairness'))
		{
			var state:PlayState = cast(FlxG.state,PlayState);
			InPlayState = true;
			if (musthit)
			{
				state.playerStrums.forEach(function(spr:FlxSprite)
				{
					if (spr.ID == notetolookfor)
					{
						x = spr.x;
						MyStrum = spr;
					}
				});
			}
			else
			{
				state.dadStrums.forEach(function(spr:FlxSprite)
				{
					if (spr.ID == notetolookfor)
					{
						x = spr.x;
						MyStrum = spr;
					}
				});
			}
		}
		
		if (PlayState.SONG.song.toLowerCase() == 'unfairness')
		{
			var rng:FlxRandom = new FlxRandom();
			if (rng.int(0,120) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(1,3);
			}
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (this.noteStyle == 'pixel')
				x += 60;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * (PlayState.SONG.speed * LocalScrollSpeed);
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}
	
	function animList()
	{
		animation.addByPrefix('greenScroll', 'green0');
		animation.addByPrefix('redScroll', 'red0');
		animation.addByPrefix('blueScroll', 'blue0');
		animation.addByPrefix('purpleScroll', 'purple0');

		animation.addByPrefix('purpleholdend', 'pruple end hold');
		animation.addByPrefix('greenholdend', 'green hold end');
		animation.addByPrefix('redholdend', 'red hold end');
		animation.addByPrefix('blueholdend', 'blue hold end');

		animation.addByPrefix('purplehold', 'purple hold piece');
		animation.addByPrefix('greenhold', 'green hold piece');
		animation.addByPrefix('redhold', 'red hold piece');
		animation.addByPrefix('bluehold', 'blue hold piece');

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (MyStrum != null)
		{
			x = MyStrum.x + (isSustainNote ? width : 0);
		}
		else
		{
			if (InPlayState)
			{
				var state:PlayState = cast(FlxG.state,PlayState);
				if (mustPress)
						{
					state.playerStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.ID == notetolookfor)
						{
							x = spr.x;
							MyStrum = spr;
						}
					});
				}
				else
				{
					state.dadStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.ID == notetolookfor)
						{
							x = spr.x;
							MyStrum = spr;
						}
					});
				}
			}
		}
		
		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
