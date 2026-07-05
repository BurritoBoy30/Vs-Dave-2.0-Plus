package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class LoadingScreenState extends MusicBeatState
{
	var startLoad:Bool = false;
	
	var loadingText:FlxText;
	var goToState:FlxState;
	
	var assetList:Array<Dynamic> = [
		['gf_fucked', 'fucked', 12],
		['motherdaughterbonding', 'succ', 12],
		['auntsolo', 'spitroast', 12],
		['kenzou', 'tits', 10],
		['girlfriend', 'bop', 24],
		['kanna', 'inpublic', 12]
	];
	
	var id:Int = 0;
	
	public function new(state:FlxState)
	{
		super();
		
		goToState = state;
	}
	
	override public function create():Void
	{
		id = FlxG.random.int(0, assetList.length - 1);
		
		var gfXml:FlxSprite = new FlxSprite(0, 0);
		gfXml.frames = Paths.getSparrowAtlas('loading/' + assetList[id][0], 'horny');
		gfXml.animation.addByPrefix('sex',  assetList[id][1], assetList[id][2], true);
		gfXml.animation.play('sex', true);
		gfXml.x = FlxG.width - gfXml.width;
		gfXml.visible = FlxG.save.data.hornyALL && FlxG.save.data.loadingSplashes;
		gfXml.antialiasing = FlxG.save.data.antiAliasing;
		add(gfXml);
		
		var fadeIn:FlxSprite = new FlxSprite(gfXml.x, 0).loadGraphic(Paths.image('loading/fade', 'horny'));
		fadeIn.visible = FlxG.save.data.hornyALL;
		fadeIn.antialiasing = FlxG.save.data.antiAliasing;
		add(fadeIn);
		
		loadingText = new FlxText(20, FlxG.height - 70, FlxG.width, '', 16);
		loadingText.setFormat(Paths.font("comic.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		loadingText.borderSize = 2;
		loadingText.antialiasing = FlxG.save.data.antiAliasing;
		add(loadingText);

		super.create();
		
		startLoad = true;
		
		if (startLoad)
		{
			new FlxTimer().start(2, function(skyFNF:FlxTimer) go());
		}
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
		new FlxTimer().start(3, function(skyFNF:FlxTimer)
			LoadingState.loadAndSwitchState(goToState)
		);
	}
}