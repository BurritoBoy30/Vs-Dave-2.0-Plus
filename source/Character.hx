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
	public var camOffsets:Array<Float> = [0,0];
	
	var startedAnim:String = '';
	var startedVarAnims:Array<String> = [];
	var forceAnim:Bool = true;
	var danceType:String = 'idle';
	var hasHair:Bool = false;
	
	public static var tutorialGFs:Array<String> = [
		'gf',
		'gf-christmas',
		'cyan',
		'cyan-christmas',
		'psyka',
		'psyka-christmas',
		'gf-massive',
		'gf-hot',
		'gf-hot-christmas',
		'gf-hot-funny',
		'tails-doll',
		'skyblue',
		'three-gfs',
		'kaity'
	];
	
	var bfList:Array<String> = [];
	var gfList:Array<String> = [];
	
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:String = 'bf')
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		antialiasing = FlxG.save.data.antiAliasing;
		
		trace('get char: ' + curCharacter);
		
		loadCharInfo(curCharacter);
	
		dance();

		if (isPlayer == 'bf')
		{
			bfList = CoolUtil.coolTextFile(Paths.txt('boyfriendList'));
			// Doesn't flip for BF, since his are already in the right place???
			if (!(bfList.contains(curCharacter)))
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
				var stupidthingforgfshair:Bool = true;
				
				if (hasHair)
					stupidthingforgfshair = animation.curAnim.name.startsWith('hair');
					
				if (!stupidthingforgfshair)
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
		
		for (i in 0...5)
		{
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
						var shitSize:Float = 1;
						shitSize = Std.parseFloat(charInfo[1]);
						
						if (shitSize != 1)
						{
							setGraphicSize(Std.int(width * shitSize));
							updateHitbox();
						}
						
					case 'anti-aliasing':
						antialiasing = charInfo[1] == 'true';
						
					case 'flipX':
						flipX = charInfo[1] == 'true';
						
				}
			}
		}
		
		for (i in 6...offsetStuffs.length - 1)
		{
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
		}
		
		for (i in (offsetStuffs.length - 1)...offsetStuffs.length)
		{
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
}
