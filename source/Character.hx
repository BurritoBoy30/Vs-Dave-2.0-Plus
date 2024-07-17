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
			
			case 'gf-player':
				tex = Paths.getSparrowAtlas('characters/Playable_GF_V2');
				frames = tex;
				
				addAnimation(-5, 'idle', 'GF Idle dance');
				addAnimation(-29, 27, 'singUP', 'GF Up');
				addAnimation(4, -6, 'singLEFT', 'GF Left');
				addAnimation(-49, -6, 'singRIGHT', 'GF Right');
				addAnimation(-10, -50, 'singDOWN', 'GF Down');
				addAnimation(-29, 27, 'singUPmiss', 'GF Miss Up');
				addAnimation(12, 24, 'singLEFTmiss', 'GF Miss Left');
				addAnimation(-30, 21, 'singRIGHTmiss', 'GF Miss Right');
				addAnimation(-11, -19, 'singDOWNmiss', 'GF Miss Down');
				addAnimation(-4, 5, 'hey', 'GF Hey');

				addAnimation(24, 8, 'firstDeath', "GF First Death");
				addAnimation(24, 3, 'deathLoop', "GF Death Loop", true);
				addAnimation(24, 66, 'deathConfirm', "GF Dead Continue");

				addAnimation(-4, 'scared', 'GF Scared', true);

				playAnim('idle');

				flipX = true;

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
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				addOffset('idle', 7, 0);
				addOffset("singUP", -14, 16);
				addOffset("singRIGHT", 13, 23);
				addOffset("singLEFT", 49, -9);
				addOffset("singDOWN", 0, -10);
				
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
				
				charOffset[1] = 50;
			
			case 'bambi-old':
				tex = Paths.getSparrowAtlas('characters/bambi-old');
				frames = tex;
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUP', 'MARCELLO NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'MARCELLO NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'MARCELLO NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'MARCELLO NOTE DOWN0', 24, false);
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUPmiss', 'MARCELLO MISS UP0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MARCELLO MISS LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MARCELLO MISS RIGHT0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MARCELLO MISS DOWN0', 24, false);

				animation.addByPrefix('firstDeath', "MARCELLO dead0", 24, false);
				animation.addByPrefix('deathLoop', "MARCELLO dead0", 24, true);
				animation.addByPrefix('deathConfirm', "MARCELLO dead0", 24, false);
	
				addOffset('idle');
				addOffset("singUP", -6, 3);
				addOffset("singRIGHT", 0, -4);
				addOffset("singLEFT", -10, -2);
				addOffset("singDOWN", 0, -17);
				addOffset("singUPmiss", -6, 4);
				addOffset("singRIGHTmiss", 0, -4);
				addOffset("singLEFTmiss", -10, -2);
				addOffset("singDOWNmiss", -7, -14);

				playAnim('idle');
	
				flipX = true;
				
				charOffset[1] = 400;
				
			case 'bambi-new':
				frames = Paths.getSparrowAtlas('characters/bambiRemake');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", 44, 0);
				addOffset("singRIGHT", -16, -3);
				addOffset("singLEFT", -5, -8);
				addOffset("singDOWN", -5, -48);

				playAnim('idle');
				
				charOffset[1] = 420;
				charOffset[0] = 200;
			
			case 'dave-splitathon':
				frames = Paths.getSparrowAtlas('characters/Splitathon_Dave');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT", -9);
				addOffset("singLEFT");
				addOffset("singDOWN", 40);

				playAnim('idle');
				
				charOffset[0] = 100;
				charOffset[1] = 300;
				
			case 'bambi-splitathon':
				frames = Paths.getSparrowAtlas('characters/Splitathon_Bambi');
				animation.addByPrefix('idle', 'Idle', 18, false);
				animation.addByPrefix('singDOWN', 'Down', 27, false);
				animation.addByPrefix('singUP', 'Up', 27, false);
				animation.addByPrefix('singLEFT', 'Left', 27, false);
				animation.addByPrefix('singRIGHT', 'Right', 27, false);
							
				addOffset('idle');
				addOffset("singUP", -24, 15);
				addOffset("singRIGHT", -34, -6);
				addOffset("singLEFT", -3, 6);
				addOffset("singDOWN", -20, -10);
		
				playAnim('idle');
				
				charOffset[0] = 175;
				charOffset[1] = 450;
			
			case 'bambi-angey':
				frames = Paths.getSparrowAtlas('characters/bambimaddddd');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP', 0, 20);
				addOffset('singRIGHT');

				playAnim('idle');
				
				charOffset[1] = 430;
				charOffset[0] = 220;

			case 'bambi-3d':
				// BAMBI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/bambi_angryboy');
				frames = tex;
				animation.addByPrefix('idle', 'DaveAngry idle dance', 24, false);
				animation.addByPrefix('singUP', 'DaveAngry Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'DaveAngry Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DaveAngry Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'DaveAngry Sing Note LEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				
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
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
				
			case 'dave-split-3d':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/split_dave_3d');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			// DAD LIST END
				
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				
			case 'gf-standing':
				tex = Paths.getSparrowAtlas('characters/girlfriends/ovaries');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				
				addOffset('sad', -19, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 205;
				
			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/girlfriends/gfPixel');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

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
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer', 0, -14);
				addOffset('sad', -2, -19);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, -10);
				addOffset("singRIGHT", 0, -9);
				addOffset("singLEFT", 0, -8);
				addOffset("singDOWN", 0, -31);
				addOffset('hairBlow', 49, 4);
				addOffset('hairFall', 0, -10);

				addOffset('scared', -2, -40);

				playAnim('danceRight');
				
				charOffset[1] = -7;

			case 'cyan-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/cyanChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer', 0, -14);
				addOffset('sad', -2, -19);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, -10);
				addOffset("singRIGHT", 0, -9);
				addOffset("singLEFT", 0, -8);
				addOffset("singDOWN", 0, -31);
				addOffset('hairBlow', 49, 4);
				addOffset('hairFall', 0, -10);

				addOffset('scared', -2, -40);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				charOffset[1] = -7;
			
			case 'psyka':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/Psyka_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				
				charOffset[1] = -28;

			case 'psyka-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/psykaChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				charOffset[1] = -28;
			
			case 'psyka-standing':
				tex = Paths.getSparrowAtlas('characters/girlfriends/obaries');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				
				addOffset('sad', -19, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 185;
				
			case 'gf-massive':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/massivegf');
				frames = tex;
				animation.addByPrefix('cheer', 'cheer', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByIndices('sad', 'sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'idle', [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], "", 24, false);
				animation.addByIndices('danceRight', 'idle', [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 0, 1, 2], "", 24, false);
				animation.addByIndices('hairBlow', "hairblow", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "hairland", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'scared', 24);
				
				addOffset('cheer', 118, 251);
				addOffset('sad', 11, -35);
				addOffset('danceLeft', 6, 310);
				addOffset('danceRight', 6, 310);

				addOffset("singUP", -19, 18);
				addOffset("singRIGHT", 8, -49);
				addOffset("singLEFT", 13, -7);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 205, -35);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				
				charOffset[0] = 75;
				charOffset[1] = -350;
				
			case 'gf-hot':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Bent_New');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				
				charOffset[1] = -5;
			
			case 'gf-hot-funny':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Bent_Funny');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				
				charOffset[1] = -5;

			case 'gf-hot-christmas':
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Bent_Christmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
				
				charOffset[0] = -80;
				charOffset[1] = -5;
				
			case 'gf-hot-standing':
				tex = Paths.getSparrowAtlas('characters/girlfriends/GF_Funny_Boombox');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				
				addOffset('sad', -19, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				
				playAnim('danceRight');
				
				charOffset[0] = 90;
				charOffset[1] = 205;
				
			case 'tails-doll':
				tex = Paths.getSparrowAtlas('characters/girlfriends/tailslol_edit');
				frames = tex;
				
				addAnimation(0, 0, 'idle', 'tailslol idle');
				addAnimation(0, 0, 'singUP', 'tailslol up');
				addAnimation(0, 0, 'singLEFT', 'tailslol left');
				addAnimation(0, 0, 'singRIGHT', 'tailslol right');
				addAnimation(0, 0, 'singDOWN', 'tailslol down');
				
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
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
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
		if (!curCharacter.startsWith('bf'))
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
				
				PlayState.dadCam[0] = 0;
				PlayState.dadCam[1] = 0;
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
					'cyan-christmas' | 'gf-massive' | 'gf-hot' | 'gf-hot-christmas' | 'gf-hot-funny' | 'gf-hot-standing':
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
			
		if (curCharacter == 'gf')
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
	
	public function addAnimation(xAxis:Float = 0, y:Float = 0, name:String, xmlName:String, looped:Bool = false, fps:Int = 24)
	{
		animation.addByPrefix(name, xmlName, fps, looped);
		animOffsets[name] = [xAxis, y];
	}
}
