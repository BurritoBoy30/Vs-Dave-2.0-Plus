package;

import flixel.FlxG;
import flixel.FlxSprite;

class StrumNote extends FlxSprite
{
	public var isPlayer:Bool;
	
	public function new(x:Float, y:Float, noteID:Int, type:String, isPlayer:Bool)
	{
		super(x, y);
		
		ID = noteID;
		
		switch (type)
		{
			case 'pixel':
				loadGraphic(Paths.image('notes/NOTE_assets_pixel'), true, 17, 17);
				animation.add('green', [6]);
				animation.add('red', [7]);
				animation.add('blue', [5]);
				animation.add('purplel', [4]);

				switch (Math.abs(noteID))
				{
					case 0:
						animation.add('static', [0]);
						animation.add('pressed', [4, 8], 12, false);
						animation.add('confirm', [12, 16], 24, false);
					case 1:
						animation.add('static', [1]);
						animation.add('pressed', [5, 9], 12, false);
						animation.add('confirm', [13, 17], 24, false);
					case 2:
						animation.add('static', [2]);
						animation.add('pressed', [6, 10], 12, false);
						animation.add('confirm', [14, 18], 12, false);
					case 3:
						x += Note.swagWidth * 3;
						animation.add('static', [3]);
						animation.add('pressed', [7, 11], 12, false);
						animation.add('confirm', [15, 19], 24, false);
				}

			default:
				frames = Paths.getSparrowAtlas('notes/NOTE_assets' + (type == '3d' ? "_3D" : ""));
				animation.addByPrefix('green', 'arrowUP');
				animation.addByPrefix('blue', 'arrowDOWN');
				animation.addByPrefix('purple', 'arrowLEFT');
				animation.addByPrefix('red', 'arrowRIGHT');

				switch (Math.abs(noteID))
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						x += Note.swagWidth * 1;
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						x += Note.swagWidth * 2;
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						x += Note.swagWidth * 3;
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
		}
		
		switch (type)
		{
			case 'pixel' | '3d':
				antialiasing = false;
			default:
				antialiasing = FlxG.save.data.antiAliasing;
		}
		
		animationPlay('static');
		
		setGraphicSize(Std.int(width * (type == 'pixel' ? PlayState.daPixelZoom : 0.7)));
		updateHitbox();		
		scrollFactor.set();
		
		this.isPlayer = isPlayer;
	}
	
	public function animationPlay(sex:String, wierdBool:Bool = false)
	{
		animation.play(sex, wierdBool);
		centerOffsets();
		centerOrigin();
	}
}