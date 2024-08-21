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

	public var isPlayer:String = 'bf';
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var globaloffset:Array<Float> = [0,0];
	public var charOffset:Array<Float> = [0,0];
	
	public static var tutorialGFs:Array<String> = ['gf', 'gf-christmas', 'cyan', 'cyan-christmas', 'psyka', 'psyka-christmas', 'gf-massive', 'gf-hot', 'gf-hot-christmas', 'gf-hot-funny', 'tails-doll', 'skyblue', 'three-gfs'];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:String = 'bf')
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		antialiasing = FlxG.save.data.antiAliasing;

		switch (curCharacter)
		{
			// BOYFRIEND LIST START
			case 'bf':
				getSheet('BOYFRIEND');
				
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
				frames = Paths.getSparrowAtlas('characters/bfChristmas');
				
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
				frames = Paths.getSparrowAtlas('characters/BFwithGf');
				
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
				getSheet('bf-holding-cyan');
				
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
				getSheet('bfPixel');
				
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
				getSheet('bfPixelsDEAD');
				
				addAnimation('firstDeath', "BF Dies pixel");
				addAnimation(-37, 'deathLoop', "Retry Loop", true);
				addAnimation(-37, 'deathConfirm', "RETRY CONFIRM");
				
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				
				playAnim('firstDeath');
				
				antialiasing = false;
				flipX = true;
				
			case 'rapper-gf':
				getSheet('GF_in_Bf_clothesV2');
				
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
				getSheet('GF_in_Bf_clothes_DEAD');
				
				addAnimation(0, -200, 'firstDeath', "GF first Dead");
				addAnimation(-4, -215, 'deathLoop', "GF dead loop", true);
				addAnimation(2, -183, 'deathConfirm', "GF Dead confirm");
				
				playAnim('firstDeath');

				flipX = true;
			
			case 'gf-player':
				getSheet('Playable_GF_V2');
				
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
				getSheet('oruta');
				
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
				getSheet('dave_sheet');
				
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
				getSheet('Dave_insanity_lol');
				
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
				getSheet('Dave_Furiosity');
				
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
				getSheet('Splitathon_Dave');
				
				addAnimation('idle', 'Idle');
				addAnimation('singUP', 'Up');
				addAnimation(-9, 'singRIGHT', 'Right');
				addAnimation(40, 'singDOWN', 'Down');
				addAnimation('singLEFT', 'Left');

				playAnim('idle');
				
				charOffset[0] = 100;
				charOffset[1] = 300;
				
			case 'bambi-new':
				getSheet('bambiRemake');
				
				addAnimation('idle', 'Idle');
				addAnimation(44, 0, 'singUP', 'up');
				addAnimation(-16, -3, 'singRIGHT', 'right');
				addAnimation(-5, -48, 'singDOWN', 'down');
				addAnimation(-5, -8, 'singLEFT', 'left');

				playAnim('idle');
				
				charOffset[1] = 430;
				charOffset[0] = 200;
				
			case 'bambi-splitathon':
				getSheet('Splitathon_Bambi');
				
				addAnimation('idle', 'Idle', 18);
				addAnimation(-20, -10, 'singDOWN', 'Down', 27);
				addAnimation(-24, 15, 'singUP', 'Up', 27);
				addAnimation(-3, 6, 'singLEFT', 'Left', 27);
				addAnimation(-34, -6, 'singRIGHT', 'Right', 27);
		
				playAnim('idle');
				
				charOffset[0] = 175;
				charOffset[1] = 450;
			
			case 'bambi-angey':
				getSheet('bambimaddddd');
				
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
				getSheet('bambi_angryboy');
				
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
				getSheet('alphadave');
				
				addAnimation('idle', 'Dad idle dance');
				addAnimation(-6, 50, 'singUP', 'Dad Sing Note UP');
				addAnimation(0, 27, 'singRIGHT', 'Dad Sing Note RIGHT');
				addAnimation(0, -30, 'singDOWN', 'Dad Sing Note DOWN');
				addAnimation(-10, 10, 'singLEFT', 'Dad Sing Note LEFT');

				playAnim('idle');
				
				charOffset[1] = -20;
				
			case 'dave-split-3d':
				// DAVE SHITE ANIMATION LOADING CODE
				getSheet('split_dave_3d');
				
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
				
			case 'bambi-joke':
				getSheet('bambi-joke');
				
				addAnimation('idle', 'idle');
				addAnimation('singUP', 'up');
				addAnimation('singLEFT', 'right');
				addAnimation('singRIGHT', 'left');
				addAnimation('singDOWN', 'down');
				addAnimation('hey', 'hey');

				flipX = true;
				playAnim('idle');
				
				charOffset[0] = 175;
				charOffset[1] = 400;
				
			case 'bambi-piss-3d':
				getSheet('bambi_pissyboy');
				
				addAnimationIndices('danceLeft', 'idle', [for (i in 0...13) i]);
				addAnimationIndices('danceRight', 'idle', [for (i in 13...23) i]);
				addAnimation(30, 'singLEFT', 'left');
				addAnimation(0, -10, 'singDOWN', 'down');
				addAnimation(10, 20, 'singUP', 'up');
				addAnimation(30, 20, 'singRIGHT', 'right');
		
				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('danceRight');
				
				charOffset[0] = -200;
				charOffset[1] = -75;
			
			case 'exbungo':
				getSheet('exbungo');

				addAnimation('idle', 'idle');
				addAnimation('singUP', 'up');
				addAnimation('singLEFT', 'left');
				addAnimation('singRIGHT', 'right');
				addAnimation('singDOWN', 'down');
				
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
	
				antialiasing = false;

				playAnim('idle');
				
			case 'bambi-unfair':
				getSheet('unfair_bambi');
				
				addAnimation('idle', 'idle');
				addAnimation(140, 70, 'singUP', 'singUP');
				addAnimation(-180, -60, 'singRIGHT', 'singRIGHT');
				addAnimation(150, 50, 'singDOWN', 'singDOWN');
				addAnimation(250, 0, 'singLEFT', 'singLEFT');
		
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
				
			case 'bombu':
				getSheet('bombu');
				
				addAnimation(195, 50, 'idle', 'Idle');
				addAnimation(295, 207, 'singUP', 'Up');
				addAnimation(-78, 33, 'singRIGHT', 'Right');
				addAnimation(270, -1, 'singDOWN', 'Down');
				addAnimation(385, 44, 'singLEFT', 'Left');
		
				scale.set(0.8, 0.8);
				updateHitbox();
		
				playAnim('idle');
				
				charOffset[0] = -300;
				charOffset[1] = -75;
				
			case 'bombai':
				getSheet('bombai');
				
				addAnimation(0, 50, 'idle', 'IDLE', 30);
				addAnimation(60, 50, 'singUP', 'UP');
				addAnimation(-60, 110, 'singRIGHT', 'RIGHT');
				addAnimation(-5, 40, 'singDOWN', 'DOWN');
				addAnimation(0, 30, 'singLEFT', 'LEFT');
		
				scale.set(0.8, 0.8);
				updateHitbox();
		
				playAnim('idle');
				
				charOffset[0] = -675;
				charOffset[1] = -500;
			// DAD LIST END
				
			case 'gf':
				// GIRLFRIEND CODE
				getSheet('girlfriends/GF_assets');
				
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
				getSheet('girlfriends/gfChristmas');
				
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
				getSheet('girlfriends/ovaries');
				
				addAnimationIndices(-19, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 205;
				
			case 'gf-pixel':
				getSheet('girlfriends/gfPixel');
				
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
				getSheet('girlfriends/cyan_assets');
				
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
				getSheet('girlfriends/cyanChristmas');
				
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
				getSheet('girlfriends/Psyka_assets');
				
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
				getSheet('girlfriends/psykaChristmas');
				
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
				getSheet('girlfriends/obaries');
				
				addAnimationIndices(-19, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 185;
				
			case 'gf-massive':
				// GIRLFRIEND CODE
				getSheet('girlfriends/massivegf');
				
				addAnimation(110, 256, 'cheer', 'cheer');
				addAnimation(13, 16, 'singLEFT', 'left');
				addAnimation(8, -15, 'singRIGHT', 'right');
				addAnimation(-18, 38, 'singUP', 'up');
				addAnimation(0, 4, 'singDOWN', 'down');
				
				addAnimationIndices(11, -10, 'sad', 'sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(6, 310,'danceLeft', 'idle', [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
				addAnimationIndices(6, 310, 'danceRight', 'idle', [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 0, 1, 2]);
				addAnimationIndices(190, -10, 'hairBlow', "hairblow", [0, 1, 2, 3], true);
				addAnimationIndices(0, -9, 'hairFall', "hairland", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
				addAnimation(9, -1, 'scared', 'scared', true);
				
				scale.set(0.93, 0.93);
				updateHitbox();
				
				playAnim('danceRight');
				
				charOffset[0] = 75;
				charOffset[1] = -300;
				
			case 'gf-hot':
				// GIRLFRIEND CODE
				getSheet('girlfriends/GF_Bent_New');
				
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
				getSheet('girlfriends/GF_Bent_Funny');
				
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
				getSheet('girlfriends/GF_Bent_Christmas');
				
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
				getSheet('girlfriends/GF_Funny_Boombox');
				
				addAnimationIndices(-19, -21, 'sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
				addAnimationIndices(0, -9, 'danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
				addAnimationIndices(0, -9, 'danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 205;
				
			case 'tails-doll':
				getSheet('girlfriends/tailslol_edit');
				
				addAnimation('idle', 'tailslol idle');
				addAnimation(1, -5, 'singUP', 'tailslol up');
				addAnimation(1, -3, 'singLEFT', 'tailslol left');
				addAnimation(1, -4, 'singRIGHT', 'tailslol right');
				addAnimation(1, -2, 'singDOWN', 'tailslol down');
				
				playAnim('idle');
				
				charOffset[0] = -140;
				charOffset[1] = -170;
				
			case 'skyblue':
				getSheet('girlfriends/SKYBLUE');
				
				addAnimation(0, 0, 'idle', 'SKYBLUE IDLE');
				addAnimation(-55, 92, 'singUP', 'SKYBLUE UP');
				addAnimation(271, -140, 'singLEFT', 'SKYBLUE LEFT');
				addAnimation(-191, 28, 'singRIGHT', 'SKYBLUE RIGHT');
				addAnimation(-29, -181, 'singDOWN', 'SKYBLUE DOWN');
				
				playAnim('idle');
				
				charOffset[0] = 20;
				charOffset[1] = -70;
				
			case 'three-gfs':
				getSheet('girlfriends/GFGAWDl');
				
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
			
			case 'gf-trepidation':
				getSheet('girlfriends/tpgf');
				
				addAnimationIndices('danceLeft1', 'idle a', [29, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13]);
				addAnimationIndices('danceRight1', 'idle a',[14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]);
				addAnimationIndices(-250, 25, 'danceLeft2', 'idle b', [29, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13]);
				addAnimationIndices(-250, 25, 'danceRight2', 'idle b',[14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]);
				addAnimation(-203, 8, 'transition', 'transition');
				
				scale.set(0.75, 0.75);
				updateHitbox();
				
				playAnim('danceRight1');
				
				charOffset[0] = -400;
				charOffset[1] = -250;

		}

		dance();

		if (isPlayer == 'bf')
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
	
	var startTransiton:Bool = false;
	var didItOnce:Bool = false;
	
	public function trepTransi(chance:Float)
	{
		if (curCharacter == 'gf-trepidation')
		{
			if (!didItOnce)
			{
				if (FlxG.random.bool(chance * 0.01))
				{
					startTransiton = true;
					canDance = false;
					playAnim('transition', true);
					didItOnce = true;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if(!debugMode && animation.curAnim != null)
		{
			if (isPlayer == 'dad')
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
					
					PlayState.dadNoteCamOffset[0] = 0;
					PlayState.dadNoteCamOffset[1] = 0;
				}
			}
		}

		// i would delete this but im lazy
		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}
		
		if (curCharacter == 'gf-trepidation')
		{
			if (startTransiton)
			{
				if (animation.curAnim.name == 'transition' && animation.curAnim.finished)
				{
					trepTransition = true;
					canDance = true;
					startTransiton = false;
					dance();
				}
			}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;
	var trepTransition:Bool = false;

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
					'cyan-christmas' | 'gf-massive' | 'gf-hot' | 'gf-hot-christmas' | 'gf-hot-funny' | 'gf-hot-standing' | 'three-gfs':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}
				case 'gf-trepidation':
					danced = !danced;

					if (danced)
					{
						if (!trepTransition)
							playAnim('danceRight1', true);
						else
							playAnim('danceRight2', true);
					}
					else
					{
						if (!trepTransition)
							playAnim('danceLeft1', true);
						else
							playAnim('danceLeft2', true);
					}
				case 'bambi-piss-3d':
					danced = !danced;

					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);
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
			if (isPlayer == 'bf')
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
	
	function getSheet(file:String)
	{
		frames = Paths.getSparrowAtlas('characters/' + file);
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
