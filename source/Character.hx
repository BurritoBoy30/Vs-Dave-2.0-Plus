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

	public var charOffset:Array<Float> = [0,0];
	public var animationsArray:Array<String> = [];
	
	public static var tutorialGFs:Array<String> = ['gf', 'gf-christmas', 'cyan', 'cyan-christmas', 'psyka', 'psyka-christmas', 'gf-massive', 'gf-hot', 'gf-hot-christmas', 'gf-hot-funny', 'tails-doll', 'skyblue', 'three-gfs', 'kaity'];
	var bfList:Array<String> = [];
	
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:String = 'bf')
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		antialiasing = FlxG.save.data.antiAliasing;
		
		trace('get char: ' + curCharacter);
		
		bfList = CoolUtil.coolTextFile(Paths.txt('boyfriendList'));
		
		loadCharInfo(curCharacter);
		
		if (bfList.contains(curCharacter) || ['bf-pixel-dead', 'rapper-gf-dead', 'bambi-joke'].contains(curCharacter))
		{
			flipX = true;
		}
		
		switch (curCharacter)
		{
			// BOYFRIEND LIST START
			case 'bf-pixel':
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				width -= 100;
				height -= 100;
				
				antialiasing = false;
				
			case 'bf-pixel-dead':				
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				
			case 'dave':				
				setGraphicSize(Std.int(width * 1.1));
				updateHitbox();
			
			case 'dave-annoyed':				
				setGraphicSize(Std.int(width * 1.1));
				updateHitbox();
				
			case 'dave-angey':				
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				
			case 'bambi-3d':
				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				antialiasing = false;
	
			case 'dave-split-3d':		
				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
				
			case 'bambi-piss-3d':		
				setGraphicSize(Std.int(width / furiosityScale));
				updateHitbox();
				antialiasing = false;
					
			case 'exbungo':				
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
	
				antialiasing = false;
				
			case 'bambi-unfair':		
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
				antialiasing = false;
			
			case 'bombu':		
				scale.set(0.8, 0.8);
				updateHitbox();
			
			case 'bombai':		
				scale.set(0.8, 0.8);
				updateHitbox();
				
			case 'gf-pixel':
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
				
			case 'gf-massive':
				scale.set(0.93, 0.93);
				updateHitbox();
				
			case 'gf-trepidation':			
				scale.set(0.75, 0.75);
				updateHitbox();
		}
		
		switch (curCharacter)
		{
			case 'bambi-piss-3d' | 'gf' | 'gf-christmas' | 'gf-standing' | 'gf-pixel' | 'cyan' | 'cyan-christmas' | 'psyka' | 'psyka-christmas' | 'psyka-standing' |
				'gf-massive' | 'gf-hot' | 'gf-hot-funny' | 'gf-hot-christmas' | 'gf-hot-standing' | 'three-gfs' | 'kaity' | 'kaity-christmas':
				playAnim('danceRight');
			case 'bf-pixel-dead' | 'rapper-gf-dead':
				playAnim('firstDeath');
			case 'gf-trepidation':
				playAnim('danceRight1');
			default:
				playAnim('idle');
		}

		dance();

		if (isPlayer == 'bf')
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!(bfList.contains(curCharacter)))
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
					'cyan-christmas' | 'gf-massive' | 'gf-hot' | 'gf-hot-christmas' | 'gf-hot-funny' | 'gf-hot-standing' | 'three-gfs' | 'kaity' |
					'kaity-christmas':
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
			offset.set(daOffset[0], daOffset[1]);
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
	
	function loadCharInfo(character:String)
	{
		var offsetStuffs:Array<String> = CoolUtil.coolTextFile(Paths.txt('charinfo/' + character, 'preload'));
		var characterFile:String = offsetStuffs[0];
		
		getSheet(characterFile);
		
		var charoffsetInfo:Array<String> = offsetStuffs[1].split("' '");
		charOffset = [Std.parseFloat(charoffsetInfo[0]), Std.parseFloat(charoffsetInfo[1])];
		
		for (i in 2...offsetStuffs.length)
		{
			for (offsetText in offsetStuffs)
			{
				var offsetInfo:Array<String> = offsetText.split("' '");
					
				if (offsetInfo[0] == 'prefix')
				{
					var loopedBool:Bool = false;
					if (offsetInfo[5] == 'true')
						loopedBool = true;
						
					addAnimation(Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2]), offsetInfo[3], offsetInfo[4], loopedBool, Std.parseInt(offsetInfo[6]));
				}
				else if (offsetInfo[0] == 'indices')
				{
					var indicesArray:Array<Int> = [];
					var indiceData:Array<String> = offsetInfo[5].split(',');
						
					for (i in 0...indiceData.length)
					{
						indicesArray.push(Std.parseInt(indiceData[i]));
					}
					
					var loopedBool:Bool = false;
					if (offsetInfo[6] == 'true')
						loopedBool = true;
						
					addAnimationIndices(Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2]), offsetInfo[3], offsetInfo[4], indicesArray, loopedBool, Std.parseInt(offsetInfo[7]));
				}
			}
		}
	}
	
	function getSheet(file:String)
	{
		frames = Paths.getSparrowAtlas('characters/' + file, 'shared');
	}
	
	public function addAnimation(xAxis:Float = 0, yAxis:Float = 0, name:String, xmlName:String, looped:Bool = false, fps:Int = 24)
	{
		animation.addByPrefix(name, xmlName, fps, looped);
		animOffsets[name] = [xAxis, yAxis];
		animationsArray.push(name);
	}
	
	public function addAnimationIndices(xAxis:Float = 0, yAxis:Float = 0, name:String, xmlName:String, indicesArray:Array<Int>, looped:Bool = false, fps:Int = 24)
	{
		animation.addByIndices(name, xmlName, indicesArray, "", fps, looped);
		animOffsets[name] = [xAxis, yAxis];
		animationsArray.push(name);
	}
}
