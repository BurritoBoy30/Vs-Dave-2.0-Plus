package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GirlfriendThatGetsFat extends FlxSpriteGroup
{
	var theFatAssgirl:FlxSprite;
	var speakersYes:FlxSprite;
	
	public function new (x:Float, y:Float)
	{
		super(x, y);
		
		speakersYes = new FlxSprite(x, y);
		speakersYes.frames = Paths.getSparrowAtlas('girlfriendweightgain/girlfriend/speakers', 'horny');
		speakersYes.animation.addByPrefix('beat', 'beatwow', 24, false);
		speakersYes.animation.play('beat', true);
		speakersYes.antialiasing = FlxG.save.data.antiAliasing;
		add(speakersYes);
		
		theFatAssgirl = new FlxSprite(x - 135, y - 545).loadGraphic(Paths.image('girlfriendweightgain/girlfriend/weight_1', 'horny'));
		theFatAssgirl.antialiasing = FlxG.save.data.antiAliasing;
		add(theFatAssgirl);
	}
	
	public function playAnim()
	{
		speakersYes.animation.play('beat', true);
	}
	
	public function getFatter(size:Int = 1)
	{
		theFatAssgirl.loadGraphic(Paths.image('girlfriendweightgain/girlfriend/weight_' + size, 'horny'));
	}
}