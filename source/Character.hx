package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var globaloffset:Array<Float> = [0,0];
	public var charOffset:Array<Float> = [0,0];
	
	public static var tutorialGFs:Array<String> = ['gf', 'gf-christmas', 'cyan', 'cyan-christmas', 'psyka', 'psyka-christmas', 'gf-massive', 'gf-hot', 'gf-hot-christmas', 'gf-hot-funny', 'tails-doll', 'skyblue', 'three-gfs'];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			// BOYFRIEND LIST START
			case 'bf':
				tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				
				addAnimation(-5, 'idle', 'BF idle dance');
				addAnimation(-29, 27, 'singUP', 'BF NOTE UP0');
				addAnimation(12, -6, 'singLEFT', 'BF NOTE LEFT0');
				addAnimation(-38, -7, 'singRIGHT', 'BF NOTE RIGHT0');
				addAnimation(-10, -50, 'singDOWN', 'BF NOTE DOWN0');
				addAnimation(-29, 27, 'singUPmiss', 'BF NOTE UP MISS');
				addAnimation(12, 24, 'singLEFTmiss', 'BF NOTE LEFT MISS');
				addAnimation(-30, 21, 'singRIGHTmiss', 'BF NOTE RIGHT MISS');
				addAnimation(-11, -19, 'singDOWNmiss', 'BF NOTE DOWN MISS');
				addAnimation(-4, 5, 'hey', 'BF HEY');

				addAnimation(24, 8, 'firstDeath', "BF dies");
				addAnimation(24, 3, 'deathLoop', "BF Dead Loop", true);
				addAnimation(24, 66, 'deathConfirm', "BF Dead confirm");

				addAnimation(-4, 'scared', 'BF idle shaking', true);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				
				addAnimation(-5, 'idle', 'BF idle dance');
				addAnimation(-29, 27, 'singUP', 'BF NOTE UP0');
				addAnimation(12, -6, 'singLEFT', 'BF NOTE LEFT0');
				addAnimation(-38, -7, 'singRIGHT', 'BF NOTE RIGHT0');
				addAnimation(-10, -50, 'singDOWN', 'BF NOTE DOWN0');
				addAnimation(-29, 27, 'singUPmiss', 'BF NOTE UP MISS');
				addAnimation(12, 24, 'singLEFTmiss', 'BF NOTE LEFT MISS');
				addAnimation(-30, 21, 'singRIGHTmiss', 'BF NOTE RIGHT MISS');
				addAnimation(-11, -19, 'singDOWNmiss', 'BF NOTE DOWN MISS');

				addAnimation(-4, 'scared', 'BF idle shaking', true);

				flipX = true;
			
			case 'bf-with-gf':
				tex = Paths.getSparrowAtlas('characters/BFwithGf');
				frames = tex;
				
				addAnimation(-5, 'idle', 'BF idle dance');
				addAnimation(-29, 33, 'singUP', 'BF NOTE UP0');
				addAnimation(4, -6, 'singLEFT', 'BF NOTE LEFT0');
				addAnimation(-49, -7, 'singRIGHT', 'BF NOTE RIGHT0');
				addAnimation(-10, -50, 'singDOWN', 'BF NOTE DOWN0');
				addAnimation(-39, 30, 'singUPmiss', 'BF NOTE UP MISS');
				addAnimation(12, 24, 'singLEFTmiss', 'BF NOTE LEFT MISS');
				addAnimation(-50, 24, 'singRIGHTmiss', 'BF NOTE RIGHT MISS');
				addAnimation(-1, -27, 'singDOWNmiss', 'BF NOTE DOWN MISS');
				addAnimation(-4, -1, 'hey', 'BF HEY');

				addAnimation(24, 8, 'firstDeath', "BF dies");
				addAnimation(24, 3, 'deathLoop', "BF Dead Loop", true);
				addAnimation(24, 66, 'deathConfirm', "BF Dead confirm");

				addAnimation(-4, -2, 'scared', 'BF idle shaking', true);

				playAnim('idle');

				flipX = true;
			
			case 'bf-with-cyan':
				tex = Paths.getSparrowAtlas('characters/bf-holding-cyan');
				frames = tex;
				
				addAnimation(-5, 'idle', 'BF idle dance');
				addAnimation(-29, 27, 'singUP', 'BF NOTE UP0');
				addAnimation(4, -6, 'singLEFT', 'BF NOTE LEFT0');
				addAnimation(-49, -6, 'singRIGHT', 'BF NOTE RIGHT0');
				addAnimation(-10, -50, 'singDOWN', 'BF NOTE DOWN0');
				addAnimation(-29, 27, 'singUPmiss', 'BF NOTE UP MISS');
				addAnimation(12, 24, 'singLEFTmiss', 'BF NOTE LEFT MISS');
				addAnimation(-30, 21, 'singRIGHTmiss', 'BF NOTE RIGHT MISS');
				addAnimation(-11, -19, 'singDOWNmiss', 'BF NOTE DOWN MISS');
				addAnimation(-4, 5, 'hey', 'BF HEY');

				addAnimation(24, 8, 'firstDeath', "BF dies");
				addAnimation(24, 3, 'deathLoop', "BF Dead Loop", true);
				addAnimation(24, 66, 'deathConfirm', "BF Dead confirm");

				addAnimation(-4, 'scared', 'BF idle shaking', true);

				playAnim('idle');

				flipX = true;

			case 'bf-pixel':
				tex = Paths.getSparrowAtlas('characters/bfPixel');
				frames = tex;
				
				addAnimation('idle', 'BF IDLE');
				addAnimation('singUP', 'BF UP NOTE');
				addAnimation('singLEFT', 'BF LEFT NOTE');
				addAnimation('singRIGHT', 'BF RIGHT NOTE');
				addAnimation('singDOWN', 'BF DOWN NOTE');
				addAnimation('singUPmiss', 'BF UP MISS');
				addAnimation('singLEFTmiss', 'BF LEFT MISS');
				addAnimation('singRIGHTmiss', 'BF RIGHT MISS');
				addAnimation('singDOWNmiss', 'BF DOWN MISS');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;
				
				charOffset[0] = 200;
				charOffset[1] = 150;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				tex = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				frames = tex;
				
				addAnimation('firstDeath', "BF Dies pixel");
				addAnimation(-37, 'deathLoop', "Retry Loop", true);
				addAnimation(-37, 'deathConfirm', "RETRY CONFIRM");
				
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				
				playAnim('firstDeath');
				
				antialiasing = false;
				flipX = true;
				
			case 'rapper-gf':
				tex = Paths.getSparrowAtlas('characters/GF_in_Bf_clothesV2');
				frames = tex;
				
				addAnimation(-40, -221, 'idle', 'Idle Dance');
				addAnimation(-45, -207, 'singUP', 'Up Pose');
				addAnimation(-35, -226, 'singLEFT', 'Left Pose');
				addAnimation(-46, -220, 'singRIGHT', 'Right Pose');
				addAnimation(-41, -277, 'singDOWN', 'Down Pose');
				addAnimation(83, -194, 'singUPmiss', 'Up Miss pose');
				addAnimation(89, -207, 'singLEFTmiss', 'Left Miss pose');
				addAnimation(-44, -206, 'singRIGHTmiss', 'Right Miss pose');
				addAnimation(102, -257, 'singDOWNmiss', 'Down Miss pose');
				addAnimation(-63, -216, 'hey', 'Hey Pose');

				addAnimation(-61, -216, 'scared', 'Fear', true);

				playAnim('idle');

				flipX = true;
				
				charOffset[1] = -340; 
			
			case 'rapper-gf-dead':
				tex = Paths.getSparrowAtlas('characters/GF_in_Bf_clothes_DEAD');
				frames = tex;
				
				addAnimation(0, -200, 'firstDeath', "GF first Dead");
				addAnimation(-4, -215, 'deathLoop', "GF dead loop", true);
				addAnimation(2, -183, 'deathConfirm', "GF Dead confirm");
				
				playAnim('firstDeath');

				flipX = true;
			
			case 'gf-player':
				tex = Paths.getSparrowAtlas('characters/Playable_GF_V2');
				frames = tex;
				
				addAnimation(-6, -1, 'idle', 'GF Idle dance');
				addAnimation(-60, 17, 'singUP', 'GF Up');
				addAnimation(45, -36, 'singLEFT', 'GF Left');
				addAnimation(-49, -7, 'singRIGHT', 'GF Right');
				addAnimation(-6, -75, 'singDOWN', 'GF Down');
				addAnimation(-60, 55, 'singUPmiss', 'GF Miss Up');
				addAnimation(35, -18, 'singLEFTmiss', 'GF Miss Left');
				addAnimation(-80, 22, 'singRIGHTmiss', 'GF Miss Right');
				addAnimation(-42, -44, 'singDOWNmiss', 'GF Miss Down');
				addAnimation(-36, 1, 'hey', 'GF Hey');

				addAnimation(-27, 11, 'firstDeath', "GF First Death");
				addAnimation(-39, -3, 'deathLoop', "GF Death Loop", true);
				addAnimation(-33, -2, 'deathConfirm', "GF Dead Continue");

				addAnimation(-35, -2, 'scared', 'GF Scared', true);

				playAnim('idle');

				flipX = true;
				
				charOffset[1] = -85;
				
			case 'oruta':
				tex = Paths.getSparrowAtlas('characters/oruta');
				frames = tex;
				
				addAnimation(95, 163, 'idle', 'idle');
				addAnimation(40, 220, 'singUP', 'up');
				//addAnimation(-23, 132, 'singLEFT', 'left');
				//addAnimation(100, 160, 'singRIGHT', 'right');
				addAnimation(100, 160, 'singLEFT', 'right');
				addAnimation(-23, 132, 'singRIGHT', 'left');
				addAnimation(109, 79, 'singDOWN', 'down');
				
				playAnim('idle');
				
				charOffset[0] = 50;
				charOffset[1] = -100;
				
			// BOYFRIEND LIST END
			
			// DAD LIST START
			case 'dave':
				tex = Paths.getSparrowAtlas('characters/dave_sheet');
				frames = tex;
				
				addAnimation('idle', 'Dave Idle', 12);
				addAnimation(7, 5, 'singUP', 'Dave Sing Up', 12);
				addAnimation(-36, -1, 'singRIGHT', 'Dave Sing Right', 12);
				addAnimation(-9, -33, 'singDOWN', 'Dave Sing Down', 12);
				addAnimation(7, 4, 'singLEFT', 'Dave Sing Left', 12);

				globaloffset[1] = 100;

				setGraphicSize(Std.int(width * 1.1));
				updateHitbox();
				
				playAnim('idle');
				
				charOffset[1] = 270;
				charOffset[0] = 150;
				
			case 'dave-annoyed':
				tex = Paths.getSparrowAtlas('characters/Dave_insanity_lol');
				frames = tex;
				
				addAnimation('idle', 'Dave Idle', 12);
				addAnimation(7, 5, 'singUP', 'Dave Sing Up', 12);
				addAnimation(-36, -1, 'singRIGHT', 'Dave Sing Right', 12);
				addAnimation(-9, -33, 'singDOWN', 'Dave Sing Down', 12);
				addAnimation(7, 4, 'singLEFT', 'Dave Sing Left', 12);
				
				globaloffset[1] = 100;
	
				setGraphicSize(Std.int(width * 1.1));
				updateHitbox();
	
				playAnim('idle');
				
				charOffset[1] = 270;
				charOffset[0] = 150;

			case 'dave-angey':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/Dave_Furiosity');
				frames = tex;
				
				addAnimation(7, 0, 'idle', 'IDLE');
				addAnimation(-14, 16, 'singUP', 'UP');
				addAnimation(13, 23, 'singRIGHT', 'RIGHT');
				addAnimation(49, -9, 'singDOWN', 'DOWN');
				addAnimation(0, -10, 'singLEFT', 'LEFT');
				
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			
			case 'dave-splitathon':
				frames = Paths.getSparrowAtlas('characters/Splitathon_Dave');
				
				addAnimation('idle', 'Idle');
				addAnimation('singUP', 'Up');
				addAnimation(-9, 'singRIGHT', 'Right');
				addAnimation(40, 'singDOWN', 'Down');
				addAnimation('singLEFT', 'Left');

				playAnim('idle');
				
				charOffset[0] = 100;
				charOffset[1] = 300;
				
			case 'bambi-new':
				frames = Paths.getSparrowAtlas('characters/bambiRemake');
				
				addAnimation('idle', 'Idle');
				addAnimation(44, 0, 'singUP', 'up');
				addAnimation(-16, -3, 'singRIGHT', 'right');
				addAnimation(-5, -8, 'singDOWN', 'down');
				addAnimation(-5, -48, 'singLEFT', 'left');

				playAnim('idle');
				
				charOffset[1] = 430;
				charOffset[0] = 200;
				
			case 'bambi-splitathon':
				frames = Paths.getSparrowAtlas('characters/Splitathon_Bambi');
				
				addAnimation('idle', 'Idle', 18);
				addAnimation(-20, -10, 'singDOWN', 'Down', 27);
				addAnimation(-24, 15, 'singUP', 'Up', 27);
				addAnimation(-3, 6, 'singLEFT', 'Left', 27);
				addAnimation(-34, -6, 'singRIGHT', 'Right', 27);
		
				playAnim('idle');
				
				charOffset[0] = 175;
				charOffset[1] = 450;
			
			case 'bambi-angey':
				frames = Paths.getSparrowAtlas('characters/bambimaddddd');
				
				addAnimation('idle', 'idle');
				addAnimation('singLEFT', 'left');
				addAnimation('singDOWN', 'down');
				addAnimation(0, 20, 'singUP', 'up');
				addAnimation('singRIGHT', 'right');

				playAnim('idle');
				
				charOffset[1] = 430;
				charOffset[0] = 220;

			case 'bambi-3d':
				// BAMBI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bambi_angryboy');
				frames = tex;
				
				addAnimation('idle', 'DaveAngry idle dance');
				addAnimation('singUP', 'DaveAngry Sing Note UP');
				addAnimation('singRIGHT', 'DaveAngry Sing Note RIGHT');
				addAnimation('singDOWN', 'DaveAngry Sing Note DOWN');
				addAnimation('singLEFT', 'DaveAngry Sing Note LEFT');

				globaloffset[0] = 150;
				globaloffset[1] = 450; //this is the y
				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
				
				charOffset[1] = -200;
				
			case 'dave-alpha':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/alphadave');
				frames = tex;
				
				addAnimation('idle', 'Dad idle dance');
				addAnimation(-6, 50, 'singUP', 'Dad Sing Note UP');
				addAnimation(0, 27, 'singRIGHT', 'Dad Sing Note RIGHT');
				addAnimation(0, -30, 'singDOWN', 'Dad Sing Note DOWN');
				addAnimation(-10, 10, 'singLEFT', 'Dad Sing Note LEFT');

				playAnim('idle');
				
				charOffset[1] = -20;
				
			case 'dave-split-3d':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/split_dave_3d');
				frames = tex;
				
				addAnimation('idle', 'IDLE');
				addAnimation('singUP', 'UP');
				addAnimation('singRIGHT', 'RIGHT');
				addAnimation('singDOWN', 'DOWN');
				addAnimation('singLEFT', 'LEFT');
		
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
				
				charOffset[1] = 50;
			// DAD LIST END
				
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_assets');
				frames = tex;
				
				addAnimation('cheer', 'GF Cheer');
				addAnimation(0, -19,'singLEFT', 'GF left note');
				addAnimation(0, -20, 'singRIGHT', 'GF Right Note');
				addAnimation(0, 4, 'singUP', 'GF Up Note');
				addAnimation(0, -20, 'singDOWN', 'GF Down Note');
				addAnimationIndices(-2, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat',  [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(45, -8, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9 ,'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -17, 'scared', 'GF FEAR', true);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/gfChristmas');
				frames = tex;
				
				addAnimation('cheer', 'GF Cheer');
				addAnimation(0, -19, 'singLEFT', 'GF left note');
				addAnimation(0, -20, 'singRIGHT', 'GF Right Note');
				addAnimation(0, 4, 'singUP', 'GF Up Note');
				addAnimation(0, -20, 'singDOWN', 'GF Down Note');
				
				addAnimationIndices(-2, -2, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(45, -8, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -17, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				
			case 'gf-standing':
				tex = Paths.getSparrowAtlas('characters/girlfriends/ovaries');
				frames = tex;
				
				addAnimationIndices(-19, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 205;
				
			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/girlfriends/gfPixel');
				frames = tex;
				
				addAnimationIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
				
				charOffset[0] = 280;
				charOffset[1] = 280;
				
			case 'cyan':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/cyan_assets');
				frames = tex;
				
				addAnimation(0, -14, 'cheer', 'GF Cheer');
				addAnimation(0, -8, 'singLEFT', 'GF left note');
				addAnimation(0, -32, 'singRIGHT', 'GF Right Note');
				addAnimation(0, -10, 'singUP', 'GF Up Note');
				addAnimation(0, -31, 'singDOWN', 'GF Down Note');
				
				addAnimationIndices(-2, -19, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(46, 4, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -10, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -40, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[1] = -7;

			case 'cyan-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/cyanChristmas');
				frames = tex;
				
				addAnimation(0, -14, 'cheer', 'GF Cheer');
				addAnimation(0, -8, 'singLEFT', 'GF left note');
				addAnimation(0, -9, 'singRIGHT', 'GF Right Note');
				addAnimation(0, -10, 'singUP', 'GF Up Note');
				addAnimation(0, -31, 'singDOWN', 'GF Down Note');
				addAnimationIndices(-2, -19, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(49, 4, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -10, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -40, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				charOffset[1] = -7;
			
			case 'psyka':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/Psyka_assets');
				frames = tex;
				
				addAnimation('cheer', 'GF Cheer');
				addAnimation(0, -19, 'singLEFT', 'GF left note');
				addAnimation(0, -20, 'singRIGHT', 'GF Right Note');
				addAnimation(0, 4, 'singUP', 'GF Up Note');
				addAnimation(0, -20, 'singDOWN', 'GF Down Note');
				addAnimationIndices(-2, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(45, -8, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -17, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[1] = -28;

			case 'psyka-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/psykaChristmas');
				frames = tex;
				
				addAnimation('cheer', 'GF Cheer');
				addAnimation(0, -19, 'singLEFT', 'GF left note');
				addAnimation(0, -20, 'singRIGHT', 'GF Right Note');
				addAnimation(0, 4, 'singUP', 'GF Up Note');
				addAnimation(0, -20, 'singDOWN', 'GF Down Note');
				addAnimationIndices(-2, -2, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(45, -8, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -17, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				charOffset[1] = -28;
			
			case 'psyka-standing':
				tex = Paths.getSparrowAtlas('characters/girlfriends/obaries');
				frames = tex;
				
				addAnimationIndices(-19, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 185;
				
			case 'gf-massive':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/massivegf');
				frames = tex;
				
				addAnimation(118, 251, 'cheer', 'cheer');
				addAnimation(11, -35, 'singLEFT', 'left');
				addAnimation(8, -49, 'singRIGHT', 'right');
				addAnimation(-19, 18, 'singUP', 'up');
				addAnimation(0, -20, 'singDOWN', 'down');
				
				addAnimationIndices(11, -35, 'sad', 'sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(6, 310,'danceLeft', 'idle', [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
				addAnimationIndices(6, 310, 'danceRight', 'idle', [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 0, 1, 2]);
				addAnimationIndices(205, -35, 'hairBlow', "hairblow", [0, 1, 2, 3], true);
				addAnimationIndices( 0, -9, 'hairFall', "hairland", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -17, 'scared', 'scared', true);

				playAnim('danceRight');
				
				charOffset[0] = 75;
				charOffset[1] = -350;
				
			case 'gf-hot':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Bent_New');
				frames = tex;
				
				addAnimation(0, -3, 'cheer', 'GF Cheer');
				addAnimation(0, -20, 'singLEFT', 'GF left note');
				addAnimation(0, -22, 'singRIGHT', 'GF Right Note');
				addAnimation(0, -2, 'singUP', 'GF Up Note');
				addAnimation(0, -23, 'singDOWN', 'GF Down Note');
				addAnimationIndices(-2, -18, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(64, -7, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -20, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[1] = -5;
			
			case 'gf-hot-funny':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Bent_Funny');
				frames = tex;
				
				addAnimation(0, -3, 'cheer', 'GF Cheer');
				addAnimation(0, -20, 'singLEFT', 'GF left note');
				addAnimation(0, -22, 'singRIGHT', 'GF Right Note');
				addAnimation(0, -2, 'singUP', 'GF Up Note');
				addAnimation(0, -23, 'singDOWN', 'GF Down Note');
				
				addAnimationIndices(-2, -18, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(64, -7, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -20, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[1] = -5;

			case 'gf-hot-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Bent_Christmas');
				frames = tex;
				
				addAnimation(0, -3, 'cheer', 'GF Cheer');
				addAnimation(0, -20, 'singLEFT', 'GF left note');
				addAnimation(0, -22,'singRIGHT', 'GF Right Note');
				addAnimation(0, -2, 'singUP', 'GF Up Note');
				addAnimation(0, -23, 'singDOWN', 'GF Down Note');
				
				addAnimationIndices(-2, -18, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				addAnimationIndices(64, -7, 'hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9, 'hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(-2, -20, 'scared', 'GF FEAR', true);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				charOffset[1] = -5;
				
			case 'gf-hot-standing':
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Funny_Boombox');
				frames = tex;
				
				addAnimationIndices(-19, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 205;
				
			case 'tails-doll':
				tex = Paths.getSparrowAtlas('characters/girlfriends/tailslol_edit');
				frames = tex;
				
				addAnimation('idle', 'tailslol idle');
				addAnimation('singUP', 'tailslol up');
				addAnimation('singLEFT', 'tailslol left');
				addAnimation('singRIGHT', 'tailslol right');
				addAnimation('singDOWN', 'tailslol down');
				
				playAnim('idle');
				
				charOffset[0] = -140;
				charOffset[1] = -170;
				
			case 'skyblue':
				tex = Paths.getSparrowAtlas('characters/girlfriends/SKYBLUE');
				frames = tex;
				
				addAnimation(0, 0, 'idle', 'SKYBLUE IDLE');
				addAnimation(-55, 92, 'singUP', 'SKYBLUE UP');
				addAnimation(271, -140, 'singLEFT', 'SKYBLUE LEFT');
				addAnimation(-191, 28, 'singRIGHT', 'SKYBLUE RIGHT');
				addAnimation(-29, -181, 'singDOWN', 'SKYBLUE DOWN');
				
				playAnim('idle');
				
				charOffset[0] = 20;
				charOffset[1] = -70;
				
			case 'three-gfs':
				tex = Paths.getSparrowAtlas('characters/girlfriends/GFGAWDl');
				frames = tex;
				
				addAnimation(2, -32, 'cheer', 'GF Cheer');
				addAnimation(32, -35, 'singLEFT', 'GF left note');
				addAnimation(-47, -35, 'singRIGHT', 'GF Right Note');
				addAnimation(-24, -30, 'singUP', 'GF Up Note');
				addAnimation(-35, -35, 'singDOWN', 'GF Down Note');
				addAnimationIndices(-47, -35, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimation(0, -9, 'danceLeft', 'dancingLEFT');
				addAnimation(0, -9, 'danceRight', 'dancingRIGHT');
				addAnimation(-46, -34, 'scared', 'GF FEAR', true);
				
				playAnim('danceRight');
				
				charOffset[0] = -132;
				charOffset[1] = -70;
				
			case 'three-gfs-nude':
				tex = Paths.getSparrowAtlas('characters/girlfriends/GFWHATT');
				frames = tex;
				
				addAnimation(0, -9, 'danceLeft', 'dancingLEFT');
				addAnimation(0, -9, 'danceRight', 'dancingRIGHT');
				
				playAnim('danceRight');
				
				charOffset[0] = -132;
				charOffset[1] = -70;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!(curCharacter.startsWith('bf') || curCharacter == 'gf-player' || curCharacter.startsWith('rapper-gf') || curCharacter == 'oruta'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if(!debugMode && animation.curAnim != null)
		{
			if (!isPlayer)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}

				var dadVar:Float = 4;

				if (curCharacter == 'dad')
					dadVar = 6.1;
				if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
				{
					dance();
					holdTimer = 0;
				}
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && canDance)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-standing' | 'gf-pixel' | 'psyka' | 'psyka-christmas' | 'psyka-standing'  | 'cyan' |
					'cyan-christmas' | 'gf-massive' | 'gf-hot' | 'gf-hot-christmas' | 'gf-hot-funny' | 'gf-hot-standing' | 'three-gfs' |
					'three-gfs-nude':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}
				default:
					playAnim('idle', true);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) == null)
		{
			return; //why wasn't this a thing in the first place
		}
		animation.play(AnimName, Force, Reversed, Frame);
	
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			if (isPlayer)
			{
				offset.set(daOffset[0] + globaloffset[0], daOffset[1] + globaloffset[1]);
			}
			else
			{
				offset.set(daOffset[0], daOffset[1]);
			}
		}
		else
			offset.set(0, 0);
			
		if (tutorialGFs.contains(curCharacter) && (curCharacter != 'tails-doll' || curCharacter != 'skyblue'))
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
	
	public function addAnimation(xAxis:Float = 0, yAxis:Float = 0, name:String, xmlName:String, looped:Bool = false, fps:Int = 24)
	{
		animation.addByPrefix(name, xmlName, fps, looped);
		animOffsets[name] = [xAxis, yAxis];
	}
	
	public function addAnimationIndices(xAxis:Float = 0, yAxis:Float = 0, name:String, xmlName:String, indicesArray:Array<Int>, looped:Bool = false, fps:Int = 24)
	{
		animation.addByIndices(name, xmlName, indicesArray, "", fps, looped);
		animOffsets[name] = [xAxis, yAxis];
	}
}
