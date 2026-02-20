package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class LoadingScreenState extends MusicBeatState
{
	var gfXml:FlxSprite;
	var loadingText:FlxText;
	
	override public function create():Void
	{
		gfXml = new FlxSprite(0, 0);
		gfXml.frames = Paths.getSparrowAtlas('gf_fucked', 'horny');
		gfXml.animation.addByPrefix('gfgettingfuckedlikethewhoresheis', 'fucked', 12, true);
		gfXml.animation.addByPrefix('gfbecomesacumdumpster', 'gettingfilledwithcum', 12, false);
		gfXml.animation.play('gfgettingfuckedlikethewhoresheis', true);
		gfXml.x = FlxG.width - gfXml.width + 1;
		gfXml.visible = FlxG.save.data.hornyALL;
		gfXml.antialiasing = FlxG.save.data.antiAliasing;
		add(gfXml);
		
		loadingText = new FlxText(20, FlxG.height - 70, FlxG.width, 'Now Loading...', 16);
		loadingText.setFormat(Paths.font("comic.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		loadingText.borderSize = 2;
		loadingText.antialiasing = FlxG.save.data.antiAliasing;
		add(loadingText);

		super.create();

		new FlxTimer().start(2, function(skyFNF:FlxTimer) go());
	}
	
	var updateText:Float = 0;
	var addition:String = '';

	override function update(elapsed:Float)
	{	
		updateText++;
		
		if (updateText > 40)
			updateText = 0;
		
		switch(updateText)
		{
			case 10: addition = '';
			case 20: addition = '.';
			case 30: addition = '..';
			case 40: addition = '...';
		}
		
		loadingText.text = 'Now Loading' + addition;
		
		super.update(elapsed);
	}

	function go():Void
	{
		gfXml.animation.play('gfbecomesacumdumpster', false);
		new FlxTimer().start(3, function(skyFNF:FlxTimer)
			LoadingState.loadAndSwitchState(new PlayState())
		);
	}
}