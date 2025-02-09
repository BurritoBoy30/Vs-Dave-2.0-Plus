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

	public var charOffset:Array<Float> = [0, 0];
	public var animationsArray:Array<String> = [];
	public var camOffsets:Array<Float> = [0, 0];
	public var shitSize:Float = 1;
	public var isFlipped:Bool = false;
	public var healthIcon:String = '';
	public var healthColorArray:Array<Int> = [0, 0, 0];
	public var danceType:String = '';
	
	var startedAnim:String = '';
	var startedVarAnims:Array<String> = [];
	var forceAnim:Bool = true;
	var hasHair:Bool = false;
	
	public static var tutorialGFs:Array<String> = [];
		
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:String = 'bf')
	{
		super(x, y);
		
		tutorialGFs = CoolUtil.coolTextFile(Paths.txt('tutorialgfs'));

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		
		trace('get char: ' + curCharacter);
		
		loadCharInfo(curCharacter);
		
		trace('loaded');
	
		dance();

		if (isPlayer == 'bf')
		{
			var bfList:Array<String> = CoolUtil.coolTextFile(Paths.txt('boyfriendList'));
			var gfList:Array<String> = CoolUtil.coolTextFile(Paths.txt('girlfriendList'));
			
			// Doesn't flip for BF, since his are already in the right place???
			if (!(bfList.contains(curCharacter) || gfList.contains(curCharacter)))
			{
				flipX = !flipX;
				
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
			if (danceType == 'dance')
			{	
				if (hasHair ? !animation.curAnim.name.startsWith('hair') : true)
				{
					danced = !danced;
					
					if (curCharacter == 'gf-trepidation')
					{
						if (trepTransition)
						{
							startedVarAnims[0] = startedVarAnims[0].replace('1', '2');
							startedVarAnims[1] = startedVarAnims[1].replace('1', '2');
						}
					}
					
					if (danced)
						playAnim(startedVarAnims[0], forceAnim);
					else
						playAnim(startedVarAnims[1], forceAnim);
				}
			}
			else
			{
				playAnim(startedAnim, forceAnim);
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
			
		if (tutorialGFs.contains(curCharacter) && danceType == 'dance')
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
	
	//my magnum opus or whatever the people say
	function loadCharInfo(character:String)
	{
		var offsetStuffs:Array<String> = CoolUtil.coolTextFile(Paths.txt('charinfo/' + character, 'preload'));
		
		for (charText in offsetStuffs)
		{
			var charInfo:Array<String> = charText.split(": ");
			
			switch (charInfo[0])
			{
				case 'file':
					frames = Paths.getSparrowAtlas('characters/' + charInfo[1], 'shared');
					
				case 'offsets':
					var charoffsetInfo:Array<String> = charInfo[1].split(', ');
					charOffset = [Std.parseFloat(charoffsetInfo[0]), Std.parseFloat(charoffsetInfo[1])];
					
				case 'camoffsets':
					var camoffsetInfo:Array<String> = charInfo[1].split(', ');
					camOffsets = [Std.parseFloat(camoffsetInfo[0]), Std.parseFloat(camoffsetInfo[1])];
					
				case 'scale':
					shitSize = Std.parseFloat(charInfo[1]);
					
					if (shitSize != 1)
					{
						setGraphicSize(Std.int(width * shitSize));
						updateHitbox();
					}
					
				case 'icon':
					healthIcon = charInfo[1];
				
				case 'barcolor':
					var healthInfo:Array<String> = charInfo[1].split(', ');
					healthColorArray = [Std.parseInt(healthInfo[0]), Std.parseInt(healthInfo[1]), Std.parseInt(healthInfo[2])];
					
				case 'anti-aliasing':
					antialiasing = charInfo[1] == 'true';
					
				case 'flipX':
					flipX = charInfo[1] == 'true';
					isFlipped = charInfo[1] == 'true';
					
			}
		}
	
		for (offsetText in offsetStuffs)
		{
			var offsetInfo:Array<String> = offsetText.split(", ");
				
			if (offsetInfo[0] == 'prefix')
			{
				var loopedBool:Bool = false;
				if (offsetInfo[5] == 'true')
					loopedBool = true;
					
				animation.addByPrefix(offsetInfo[3], offsetInfo[4], Std.parseInt(offsetInfo[6]), loopedBool);
				animOffsets[offsetInfo[3]] = [Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2])];
				animationsArray.push(offsetInfo[3]);
			
			}
			else if (offsetInfo[0] == 'indices')
			{
				var indicesArray:Array<Int> = [];
				var indiceData:Array<String> = offsetInfo[5].split(':');
					
				for (i in 0...indiceData.length)
				{
					indicesArray.push(Std.parseInt(indiceData[i]));
				}
				
				var loopedBool:Bool = false;
				if (offsetInfo[6] == 'true')
					loopedBool = true;
					
				animation.addByIndices(offsetInfo[3], offsetInfo[4], indicesArray, "", Std.parseInt(offsetInfo[7]), loopedBool);
				animOffsets[offsetInfo[3]] = [Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2])];
				animationsArray.push(offsetInfo[3]);
			}
		}
	
		for (animText in offsetStuffs)
		{
			var starterAnimInfo:Array<String> = animText.split(": ");
			
			if (starterAnimInfo[0] == 'starterIdle')
			{
				danceType = 'idle';
				var idleInfo:Array<String> = starterAnimInfo[1].split(", ");
				startedAnim = idleInfo[0];
				forceAnim = idleInfo[1] == 'true';
				
				playAnim(startedAnim, forceAnim);
			}
			else if (starterAnimInfo[0] == 'starterDance')
			{
				danceType = 'dance';
				var danceInfo:Array<String> = starterAnimInfo[1].split(", ");
				startedVarAnims = [danceInfo[0], danceInfo[1]];
				forceAnim = danceInfo[2] == 'true';
				
				hasHair = danceInfo[3] != null && danceInfo[3] == 'hasHair';
				
				playAnim(startedVarAnims[0], forceAnim);
			}
		}
	}
}
