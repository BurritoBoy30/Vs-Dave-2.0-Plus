package;

import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import Shaders.PulseEffect;
import Shaders.GlitchEffect;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public var curbg:FlxSprite;
	public var screenshader:Shaders.PulseEffect = new PulseEffect();
	public static var lazychartshader:Shaders.GlitchEffect = new GlitchEffect();

	public var elapsedtime:Float = 0;
	
	public static var swagSpeed:Float;

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;
	private var dadmirror:Character;
	
	var wiggleShit:WiggleEffect = new WiggleEffect();

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var dadStrums:FlxTypedGroup<StrumNote>;

	private var camZooming:Bool = false;
	public var crazyZooming:Bool = false;
	public static var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	var timeTxt:FlxText;
	var timeLabelTxt:FlxText;
	var songPercent:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	private var shakeCam:Bool = false;
	private var updateTime:Bool = false;
	public static var botPlayOn:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	
	public static var eyesoreson = true;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var fc:Bool = true;

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var kadeEngineWatermark:FlxText;
	var botPlayState:FlxText;
	
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;
	
	var songLength:Float = 0;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	
	public static var boyfriendOverride:String = "none";
	public static var girlfriendOverride:String = "none";
	
	public var thing:FlxSprite = new FlxSprite(0, 250);
	public var splitathonExpressionAdded:Bool = false;
	var bambiEntered:Bool = false;
	
	var bfNoteCamOffset:Array<Float> = new Array<Float>();
	public static var dadNoteCamOffset:Array<Float> = new Array<Float>();
	
	override public function create()
	{
		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'house':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/houseDialogue'));
			case 'insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/insanityDialogue'));
			case 'polygonized':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/furiosityDialogue'));
			case 'supernovae':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/supernovaeDialogue'));
			case 'glitch':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/glitchDialogue'));
			case 'blocked':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/retardedDialogue'));
			case 'corn-theft':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/cornDialogue'));
			case 'maze':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/mazeDialogue'));
			case 'splitathon':
				dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/splitathonDialogue'));
		}

		// create the stage
		generateStage(SONG.song.toLowerCase());
		
		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		
		var gfVersion:String = 'gf';
		if (girlfriendOverride == 'none' || girlfriendOverride == 'gf')
		{
			gfVersion = 'gf';
		}
		else
		{
			gfVersion = girlfriendOverride;
		}
		
		gf = new Character(400, 130, gfVersion);
		gf.x += gf.charOffset[0];
		gf.y += gf.charOffset[1];
		trace('gf load');
		
		var inCaseTutorial:String = '';
		if (SONG.song.toLowerCase() == 'tutorial')
		{
			if (Character.tutorialGFs.contains(gf.curCharacter))
			{
				inCaseTutorial = gf.curCharacter;
			}
			else
			{
				inCaseTutorial = SONG.player2;
			}
		}
		else
		{
			inCaseTutorial = SONG.player2;
		}
			
		dad = new Character(100, 100, inCaseTutorial);
		dad.x += dad.charOffset[0];
		dad.y += dad.charOffset[1];
		trace('dad load');
		
		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x + 150, dad.getGraphicMidpoint().y - 150);
		
		if (Character.tutorialGFs.contains(dad.curCharacter))
		{
			dad.setPosition(gf.x, gf.y);
			if (isStoryMode)
			{
				camPos.x += 600;
				tweenCamIn();
			}
		}
		
		var boyfriendVersion:String = '';
		if (boyfriendOverride == 'none' || boyfriendOverride == 'bf')
		{
			boyfriendVersion = SONG.player1;
		}
		else
		{
			boyfriendVersion = boyfriendOverride;
		}
		
		boyfriend = new Boyfriend(770, 450, boyfriendVersion);
		boyfriend.x += boyfriend.charOffset[0];
		boyfriend.y += boyfriend.charOffset[1];
		trace('boyfriend load');
		
		if (SONG.song.toLowerCase() == 'tutorial')
			gf.visible = false;
		else
			gf.visible = !(Character.tutorialGFs.contains(dad.curCharacter) || CharacterSelectState.noGfChar.contains(boyfriend.curCharacter));
		
		switch (curStage)
		{
			case 'bambiFarmNight' | 'disabled':
				dad.color = 0xFF878787;
				gf.color = 0xFF878787;
				boyfriend.color = 0xFF878787;
		}
		
		add(gf);
		add(dad);
		if (SONG.song.toLowerCase() == 'insanity')
		{
			dadmirror = new Character(dad.x - 100, dad.y - 200, "dave-angey");
			dadmirror.visible = false;
			add(dadmirror);
		}
		add(boyfriend);
		
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;
		
		timeTxt = new FlxText(FlxG.width / 2.28, 65, FlxG.width, "", 32);
		timeTxt.setFormat(Paths.font("comic.ttf"), 45, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.antialiasing = FlxG.save.data.antiAliasing;
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		if(FlxG.save.data.downScroll) timeTxt.y = FlxG.height - 45;
		add(timeTxt);
		
		timeLabelTxt = new FlxText(timeTxt.x, timeTxt.y - 25, FlxG.width, ReturnLanguage.text('time'), 32);
		timeLabelTxt.setFormat(Paths.font("comic.ttf"), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeLabelTxt.scrollFactor.set();
		timeLabelTxt.antialiasing = FlxG.save.data.antiAliasing;
		timeLabelTxt.alpha = 0;
		timeLabelTxt.borderSize = 2;
		add(timeLabelTxt);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StrumNote>();
		dadStrums = new FlxTypedGroup<StrumNote>();
		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.05);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);
		
		iconP1 = new HealthIcon((boyfriendOverride == "none" || boyfriendOverride == "bf") ? SONG.player1 : boyfriendOverride, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.song.toLowerCase() == 'tutorial' ? inCaseTutorial : SONG.player2);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4, healthBarBG.y + 40 ,0,SONG.song + " - Dave Engine+ (KE 1.2)", 16);
		kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.5;
		kadeEngineWatermark.antialiasing = FlxG.save.data.antiAliasing;
		add(kadeEngineWatermark);

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("comic.ttf"), 18, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5;
		scoreTxt.antialiasing = FlxG.save.data.antiAliasing;
		add(scoreTxt);
		
		botPlayState = new FlxText(-45, (FlxG.save.data.downscroll ? -65 : 65), FlxG.width, "Botplay", 20);
		botPlayState.setFormat(Paths.font("comic.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 2;
		botPlayState.borderQuality = 2;
		botPlayState.antialiasing = FlxG.save.data.antiAliasing;
		botPlayState.visible = false;
		add(botPlayState); 

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botPlayState.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		timeLabelTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				preloadChar('bambi-splitathon');
		}
		
		if (SONG.song.toLowerCase() == 'kabunga') //i desperately wanted it so if you use downscroll it switches it to upscroll and flips the entire hud upside down but i never got to it
		{
			lazychartshader.waveAmplitude = 0.03;
			lazychartshader.waveFrequency = 5;
			lazychartshader.waveSpeed = 1;

			camHUD.setFilters([new ShaderFilter(lazychartshader.shader)]);
		}

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		updateTime = true;

		if (isStoryMode)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'polygonized' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'supernovae' | 'glitch':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			startCountdown();
		}

		super.create();
	}
	
	function generateStage(curTrack:String)
	{
		switch (curTrack)
		{
			case 'house' | 'insanity' | 'bonus-song':
				defaultCamZoom = 0.9;
				
				var isNight:Bool;
				isNight = curTrack == 'bonus-song';
				
				curStage = isNight ? 'daveHouseNight' : 'daveHouse';
								
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky' + (isNight ? "_night" : "")));
				bg.antialiasing = FlxG.save.data.antiAliasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills' + (isNight ? "_night" : "")));
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				stageHills.antialiasing = FlxG.save.data.antiAliasing;
				stageHills.scrollFactor.set(1, 1);
				stageHills.active = false;
				add(stageHills);

				var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate' + (isNight ? "_night" : "")));
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				gate.antialiasing = FlxG.save.data.antiAliasing;
				gate.scrollFactor.set(0.925, 0.925);
				gate.x += 25;
				gate.active = false;
				add(gate);

				var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass' + (isNight ? "_night" : "")));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = FlxG.save.data.antiAliasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
				
				if (curTrack == 'insanity')
				{
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky'));
					bg.antialiasing = FlxG.save.data.antiAliasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = true;
					bg.visible = false;
					add(bg);

					createShader(bg, 0.1, 5, 2);
				}
				
			case 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'mealie':
				defaultCamZoom = 0.9;
				
				var isNight:Bool;
				isNight = curTrack == 'splitathon' || curTrack == 'mealie';
				
				curStage = isNight ? 'bambiFarmNight' : 'bambiFarm';

				var skyType:String = isNight ? 'dave/sky_night' : 'dave/sky';

				var bg:FlxSprite = new FlxSprite(-700, 0).loadGraphic(Paths.image(skyType));
				bg.antialiasing = FlxG.save.data.antiAliasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('bambi/orangey hills'));
				hills.antialiasing = FlxG.save.data.antiAliasing;
				hills.scrollFactor.set(0.7, 0.7);
				hills.active = false;

				var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('bambi/funfarmhouse'));
				farm.antialiasing = FlxG.save.data.antiAliasing;
				farm.scrollFactor.set(0.9, 0.9);
				farm.active = false;
				
				var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('bambi/grass lands'));
				foreground.antialiasing = FlxG.save.data.antiAliasing;
				foreground.scrollFactor.set(1, 1);
				foreground.active = false;
				
				var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet.antialiasing = FlxG.save.data.antiAliasing;
				cornSet.scrollFactor.set(1, 1);
				cornSet.active = false;
				
				var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('bambi/Cornys'));
				cornSet2.antialiasing = FlxG.save.data.antiAliasing;
				cornSet2.scrollFactor.set(1, 1);
				cornSet2.active = false;
				
				var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('bambi/crazy fences'));
				fence.antialiasing = FlxG.save.data.antiAliasing;
				fence.scrollFactor.set(0.98, 0.98);
				fence.active = false;

				var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('bambi/Sign'));
				sign.antialiasing = FlxG.save.data.antiAliasing;
				sign.scrollFactor.set(1, 1);
				sign.active = false;

				if (isNight)
				{
					hills.color = 0xFF878787;
					farm.color = 0xFF878787;
					foreground.color = 0xFF878787;
					cornSet.color = 0xFF878787;
					cornSet2.color = 0xFF878787;
					fence.color = 0xFF878787;
					sign.color = 0xFF878787;
				}
				add(bg);
				add(hills);
				add(farm);
				add(foreground);
				add(cornSet);
				add(cornSet2);
				add(fence);
				add(sign);
				
			case 'polygonized' | 'cheating':
				defaultCamZoom = 0.8;
				
				curStage = curTrack == 'cheating' ? 'greenVoid' : 'redVoid';
				var bg:FlxSprite = new FlxSprite(-600, -200);
				switch (curTrack)
				{
					case 'cheating':
						bg.loadGraphic(Paths.image('dave/cheater'));
					default:
						bg.loadGraphic(Paths.image('dave/redsky'));
				}
				bg.antialiasing = FlxG.save.data.antiAliasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = true;
				add(bg);
				
				createShader(bg, 0.1, 5, 2);
			case 'disability' | 'disruption':
				defaultCamZoom = 0.8;
				
				curStage = curTrack == 'disability' ? 'disabled' : 'disrupt';
				var bg:FlxSprite = new FlxSprite(-800, -350);
				switch (curTrack)
				{
					case 'disruption':
						bg.loadGraphic(Paths.image('golden/disruptor'));
					default:
						bg.loadGraphic(Paths.image('golden/disabled'));
				}
				bg.scrollFactor.set(0.95, 0.95);
				bg.active = true;
				add(bg);
				
				createShader(bg, 0.1, 5, 2);
			case 'og':
				defaultCamZoom = 0.8;			
				curStage = 'alphaHouse';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/daveoldbg'));
				bg.antialiasing = FlxG.save.data.antiAliasing;
				bg.scrollFactor.set(0.9, 0.9);
				add(bg);
				
			case 'algebra':
				curStage = 'algebra';
				defaultCamZoom = 0.85;
				swagSpeed = 1.6;
				var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('algebra/algebraBg'));
				bg.setGraphicSize(Std.int(bg.width * 1.35), Std.int(bg.height * 1.35));
				bg.updateHitbox();
				//this is temp until good positioning gets done
				bg.screenCenter(); // no its not
				add(bg);
				
			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = FlxG.save.data.antiAliasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = FlxG.save.data.antiAliasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = FlxG.save.data.antiAliasing;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
		}
	}
	
	function createShader(bg:FlxSprite, waveAmplitude:Float, waveFrequency:Float, waveSpeed:Float)
	{
		var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
		testshader.waveAmplitude = 0.1;
		testshader.waveFrequency = 5;
		testshader.waveSpeed = 2;
		bg.shader = testshader.shader;
		curbg = bg;
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		FlxTween.tween(black, {alpha: 0}, 1);
		new FlxTimer().start(1, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}
	
	function polygonizedEnd()
	{
		FlxG.camera.flash(FlxColor.WHITE, 1);
		defaultCamZoom = 0.9;
		
		dad.x = 100;
		dad.y = 100;
		changeDad('dave');
		
		gf.canDance = false;
		boyfriend.canDance = false;
		gf.playAnim('cheer', true);
		boyfriend.playAnim('hey', true);
		
		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
		bg.antialiasing = FlxG.save.data.antiAliasing;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		insert(members.indexOf(gf), bg);

		var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/hills_night'));
		stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
		stageHills.updateHitbox();
		stageHills.antialiasing = FlxG.save.data.antiAliasing;
		stageHills.scrollFactor.set(1, 1);
		stageHills.active = false;
		insert(members.indexOf(gf), stageHills);

		var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/gate_night'));
		gate.setGraphicSize(Std.int(gate.width * 1.2));
		gate.updateHitbox();
		gate.antialiasing = FlxG.save.data.antiAliasing;
		gate.scrollFactor.set(0.925, 0.925);
		gate.x += 25;
		gate.active = false;
		insert(members.indexOf(gf), gate);

		var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(Paths.image('dave/grass_night'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
		stageFront.updateHitbox();
		stageFront.antialiasing = FlxG.save.data.antiAliasing;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		insert(members.indexOf(gf), stageFront);
		
		regenerateStaticArrows(0);
	}

	var startTimer:FlxTimer;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			if (curSong == 'insanity') dadmirror.dance();
			gf.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
					creditPopUp();
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}
	
	var creditGoDown:Bool = false;
	var creditBG:FlxSprite;
	var creditText:FlxText;
	
	function creditPopUp()
	{
		creditBG = new FlxSprite(0, 200).makeGraphic(1, 70, FlxColor.BLACK);
		creditBG.alpha = 0.6;
		
		var creditString:String;
		switch (curSong)
		{
			case 'tutorial':
				creditString = 'KawaiSprite';
			case 'house' | 'insanity' | 'polygonized' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'bonus-song' | 'cheating':
				creditString = 'MoldyGH';
			case 'mealie':
				creditString = 'Alexander Copper 19';
			case 'disability' | 'disruption':
				creditString = 'Sky!';
			case 'og':
				creditString = 'Aadsta';
			default:
				creditString = 'Placeholder';
		}
		
		creditText = new FlxText(5, creditBG.y - 5, 0, ReturnLanguage.text('songcredit') + creditString, 24);
		creditText.setFormat(Paths.font("comic.ttf"), 45, FlxColor.WHITE, LEFT);
		creditText.antialiasing = FlxG.save.data.antiAliasing;
		
		creditBG.scale.x = creditText.textField.textWidth + 20;
		creditBG.x = -((creditBG.scale.x / 2) - 1) - 12;
		creditText.x = -creditText.textField.textWidth - 15;
		
		add(creditBG);
		
		add(creditText);
		creditBG.cameras = [camHUD];
		creditText.cameras = [camHUD];
		
		// the bg only only goes the to right place if i add it to the FlxTween function, fucking why??
		FlxTween.tween(creditBG, {x: (creditBG.scale.x / 2) - 1}, 1, {ease: FlxEase.elasticInOut});
		FlxTween.tween(creditText, {x: 5}, 1, {ease: FlxEase.elasticInOut});
		
		new FlxTimer().start(5, function(Dumbshit:FlxTimer)
		{
			FlxTween.tween(creditBG, {x: -((creditBG.scale.x / 2) - 1) - 12}, 1,
			{
				ease: FlxEase.elasticInOut,
				onComplete: function(twn:FlxTween)
				{
					creditBG.destroy();
				}
			});
			
			FlxTween.tween(creditText, {x: -creditText.textField.textWidth - 25}, 1,
			{
				ease: FlxEase.elasticInOut,
				onComplete: function(twn:FlxTween)
				{
					creditText.destroy();
				}
			});
		});
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
		
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeLabelTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song.toLowerCase();

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteStyle:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(SONG.speed, 2)), daNoteData, oldNote, true,
						gottaHitNote);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}
	
	var arrowJunks:Array<Array<Float>> = [];

	private function generateStaticArrows(player:Int, regenerate:Bool = false, fadeIn:Bool = true):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var noteSkin:String = '';
			
			if ((Note.CharactersWith3D.contains(dad.curCharacter) && player == 0)
				|| (Note.CharactersWith3D.contains(boyfriend.curCharacter) && player == 1))
			{
				noteSkin = '3d';
			}
			else if (boyfriend.curCharacter == 'bf-pixel' && player == 1)
			{
				noteSkin = 'pixel';
			}
			
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, i, noteSkin, player == 1);

			if (!isStoryMode && fadeIn)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}
			
			babyArrow.x += Note.swagWidth * Math.abs(i);
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
			arrowJunks.push([babyArrow.x, babyArrow.y]);
		}
	}
	
	function regenerateStaticArrows(player:Int, fadeIn = true)
	{
		switch (player)
		{
			case 0:
				dadStrums.forEach(function(spr:StrumNote)
				{
					dadStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
			case 1:
				playerStrums.forEach(function(spr:StrumNote)
				{
					playerStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
		}
		generateStaticArrows(player, false, fadeIn);
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}
	
	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;
		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}
		
		if (['dave-angey', 'bambi-3d', 'dave-split-3d', 'bambi-piss-3d'].contains(dad.curCharacter))
		{
			dad.y += (Math.sin(elapsedtime) * 0.4);
		}

		switch (curSong)
		{
			case 'cheating': // fuck you
				playerStrums.forEach(function(spr:StrumNote)
				{
					spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
					spr.x -= Math.sin(elapsedtime) * 1.5;
				});
				dadStrums.forEach(function(spr:StrumNote)
				{
					spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
					spr.x += Math.sin(elapsedtime) * 1.5;
				});
		
			case 'disability':
				playerStrums.forEach(function(spr:StrumNote)
				{
					spr.angle += (Math.sin(elapsedtime * 2.5) + 1) * 5;
				});
				dadStrums.forEach(function(spr:StrumNote)
				{
					spr.angle += (Math.sin(elapsedtime * 2.5) + 1) * 5;
				});
				for(note in notes)
				{
					if(note.mustPress)
					{
						if (!note.isSustainNote)
							note.angle = playerStrums.members[note.noteData].angle;
					}
					else
					{
						if (!note.isSustainNote)
							note.angle = dadStrums.members[note.noteData].angle;
					}
				}
			case 'disruption':
				var krunkThing = 60;

				playerStrums.forEach(function(spr:StrumNote)
				{
					spr.x = arrowJunks[spr.ID + 4][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
					spr.y = arrowJunks[spr.ID + 4][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;

					spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;

					spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);

					spr.scale.x += 0.2;
					spr.scale.y += 0.2;

					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				});
				
				dadStrums.forEach(function(spr:StrumNote)
				{
					spr.x = arrowJunks[spr.ID][0] + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * krunkThing;
					spr.y = arrowJunks[spr.ID][1] + Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1) * krunkThing;
					
					spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.ID % 2) == 0 ? 1 : -1)) / 4;

					spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) / 2);

					spr.scale.x += 0.2;
					spr.scale.y += 0.2;

					spr.scale.x *= 1.5;
					spr.scale.y *= 1.5;
				});

				notes.forEachAlive(function(spr:Note)
				{
					if (spr.mustPress)
					{
						spr.x = arrowJunks[spr.noteData + 4][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing + (spr.isSustainNote ? 40 : 0);
						spr.y = arrowJunks[spr.noteData + 4][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;

						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;

						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);

						spr.scale.x += 0.2;
						spr.scale.y += 0.2;

						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					}
					else
					{
						spr.x = arrowJunks[spr.noteData][0] + (Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) * krunkThing + (spr.isSustainNote ? 40 : 0);
						spr.y = arrowJunks[spr.noteData][1] + Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1) * krunkThing;

						spr.scale.x = Math.abs(Math.sin(elapsedtime - 5) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 4;

						spr.scale.y = Math.abs((Math.sin(elapsedtime) * ((spr.noteData % 2) == 0 ? 1 : -1)) / 2);

						spr.scale.x += 0.2;
						spr.scale.y += 0.2;

						spr.scale.x *= 1.5;
						spr.scale.y *= 1.5;
					}
				});
		}
		
		if (botPlayOn && FlxG.keys.justPressed.NINE)
			camHUD.visible = !camHUD.visible;
			
		botPlayState.visible = botPlayOn;
		
		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		if (shakeCam && eyesoreson)
		{
			// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
			FlxG.camera.shake(0.010, 0.010);
		}
		screenshader.shader.uTime.value[0] += elapsed;
		lazychartshader.shader.uTime.value[0] += elapsed;
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;
		
		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.createIcon(SONG.player1);
			else
				iconP1.createIcon('bf-old');
		}
		
		dadStrums.forEach(function(spr:StrumNote)
		{
			if (spr.animation.curAnim.curFrame == (spr.animation.curAnim.numFrames - 1))
			{
				spr.animationPlay('static');
			}
		});
		
		if (botPlayOn)
		{
			playerStrums.forEach(function(spr:StrumNote)
			{
				if (spr.animation.curAnim.curFrame == (spr.animation.curAnim.numFrames - 1))
				{
					spr.animationPlay('static');
				}
			});
		}

		super.update(elapsed);

		if (FlxG.save.data.accuracyDisplay)
		{
			scoreTxt.text = ReturnLanguage.text('score') + songScore + " | " + ReturnLanguage.text('misses')  + misses + " | " + ReturnLanguage.text('accuracy')  + truncateFloat(accuracy, 2) + "% ";
		}
		else
		{
			scoreTxt.text = ReturnLanguage.text('score') + songScore;
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new ChartingState());
		
		if (FlxG.keys.justPressed.ONE)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.TWO)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.8)),Std.int(FlxMath.lerp(150, iconP1.height, 0.8)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
				
				if(updateTime) {
					var curTime:Float = Conductor.songPosition;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && SONG.notes[Std.int(curStep / 16)] != null)
		{
			focusCam(!SONG.notes[Std.int(curStep / 16)].mustHitSection);
		}

		/*if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}*/
		
		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}
		if (crazyZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			
			if (['polygonized', 'cheating', 'unfairness', 'kabunga', 'disruption', 'disability'].contains(curSong))
			{
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
			}

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, boyfriend.curCharacter));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			var thing:Int = (curSong == 'unfairness' || curSong == 'exploitation' ? 15000 : 1500);

			if (unspawnNotes[0].strumTime - Conductor.songPosition < thing)
			{
				var dunceNote:Note = unspawnNotes[0];
				dunceNote.finishedGenerating = true;

				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{	
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					dadNoteHit(daNote);
				}
				
				var noteSpeed = (daNote.LocalScrollSpeed == 0 ? 1 : daNote.LocalScrollSpeed);
				
				switch (curSong)
				{
					case 'algebra':
						daNote.y = noteSetup(strumLine.y, FlxG.save.data.downscroll, daNote.strumTime, swagSpeed);
					default:
						if (daNote.MyStrum != null)
						{
							daNote.y = noteSetup(daNote.MyStrum.y, FlxG.save.data.downscroll, daNote.strumTime, SONG.speed * noteSpeed);
						}
						else
						{
							daNote.y = noteSetup(strumLine.y, FlxG.save.data.downscroll, daNote.strumTime, SONG.speed * noteSpeed);
						}
				}
				//trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				
				if (daNote.wasGoodHit && daNote.isSustainNote && Conductor.songPosition >= (daNote.strumTime + 10 + (!daNote.mustPress ? 40 : 0)))
				{
					destroyNote(daNote);
				}
				
				var songSpeed = (curSong == 'algebra' ? swagSpeed : SONG.speed * noteSpeed);
				
				if (!daNote.wasGoodHit && daNote.mustPress && daNote.finishedGenerating && Conductor.songPosition >= daNote.strumTime + (350 / (0.45 * FlxMath.roundDecimal(songSpeed, 2))))
				{
					//if (!noMiss)
						noteMiss(daNote.noteData);

					vocals.volume = 0;

					destroyNote(daNote);
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
		
		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
		}
	}
	
	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void
	{
		iconP2.animation.play("bambi", true);
		BAMBICUTSCENEICONHURHURHUR.animation.play(SONG.player2, true, false, 1);
		stupidx = -5;
		stupidy = -5;
		updatevels = true;
	}
	
	function destroyNote(note:Note)
	{
		note.active = false;
		note.visible = false;
		note.kill();
		notes.remove(note, true);
		note.destroy();
	}
	
	function noteSetup(location:Float, downscrollOn:Bool, strumTime:Float, songspeed:Float)
	{
		var noteDirection:Float;
		
		if (downscrollOn)
			noteDirection = -0.45;
		else
			noteDirection = 0.45;
			
		return (location - (Conductor.songPosition - strumTime) * (noteDirection * FlxMath.roundDecimal(songspeed, 2)));
	}
	
	function focusCam(isDad:Bool)
	{
		if (isDad)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			
			switch (dad.curCharacter)
			{
				case 'dave-angey':
					camFollow.y = dad.getMidpoint().y;
				case 'dave-split-3d':
					camFollow.y = dad.getMidpoint().y - 50;
				case 'dave-alpha':
					camFollow.y = dad.getMidpoint().y - 50;
				
				case 'gf-massive':
					camFollow.y = dad.getMidpoint().y - 300;
					camFollow.x = dad.getMidpoint().x + 50;
				case 'three-gfs':
					camFollow.x = dad.getMidpoint().x + 50;
				case 'skyblue':
					camFollow.x = dad.getMidpoint().x + 100;
				case 'tails-doll':
					camFollow.x = dad.getMidpoint().x + 100;
					camFollow.y = dad.getMidpoint().y - 150;
					
				case 'bambi-piss-3d':
					camFollow.y = dad.getMidpoint().y - 50;
					
			}

			if (curSong == 'tutorial')
			{
				tweenCamIn();
			}
			
			bfNoteCamOffset[0] = 0;
			bfNoteCamOffset[1] = 0;

			camFollow.x += dadNoteCamOffset[0];
			camFollow.y += dadNoteCamOffset[1];
		}
		else
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch (boyfriend.curCharacter)
			{
				case 'bf-pixel':
					camFollow.x = boyfriend.getMidpoint().x - 270;
					camFollow.y = boyfriend.getMidpoint().y - 230;
				case 'bf-with-gf':
					camFollow.y = boyfriend.getMidpoint().y;
				case 'rapper-gf':
					camFollow.x = boyfriend.getMidpoint().x - 150;
					camFollow.y = boyfriend.getMidpoint().y + 150;
				case 'oruta':
					camFollow.x = boyfriend.getMidpoint().x - 170;
					camFollow.y = boyfriend.getMidpoint().y - 170;
					
			}
			
			dadNoteCamOffset[0] = 0;
			dadNoteCamOffset[1] = 0;

			camFollow.x += bfNoteCamOffset[0];
			camFollow.y += bfNoteCamOffset[1];
				

			if (curSong == 'tutorial')
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}
	
	function boyfriendIdleColor()
	{
		if (curStage == 'bambiFarmNight' || curStage == 'disabled')
		{
			boyfriend.color = 0xFF878787;
		}
		else
		{
			boyfriend.color = FlxColor.WHITE;
		}
	}

	function endSong():Void
	{
		timeTxt.visible = false;
		timeLabelTxt.visible = false;
		canPause = false;
		updateTime = false;
		
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			if (!botPlayOn)
				Highscore.saveScore(SONG.song, songScore, boyfriend.curCharacter, gf.curCharacter);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				PlayState.boyfriendOverride = "none";
				PlayState.girlfriendOverride = "none";
				
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			
				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					if (!botPlayOn)
						Highscore.saveWeekScore(storyWeek, campaignScore);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
				
				FlxG.switchState(new StoryMenuState());
			}
			else
			{
				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase());

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase());
				FlxG.sound.music.stop();
				
				if (botPlayOn)
					botPlayOn = false;

				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			if (botPlayOn)
				botPlayOn = false;
				
			trace('WENT BACK TO FREEPLAY??');
			
			if (PlayState.boyfriendOverride != "none" || PlayState.boyfriendOverride != "bf")
				PlayState.boyfriendOverride = "none";
			
			if (PlayState.girlfriendOverride != "none" || PlayState.girlfriendOverride != "gf")
				PlayState.girlfriendOverride = "none";
				
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daStyle:String):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff < Conductor.safeZoneOffset * -2 || noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
		}
		
		switch (daRating)
		{
			case 'sick':
				if (!botPlayOn) totalNotesHit += 1;
				sicks++;
			case 'good':
				if (!botPlayOn)	totalNotesHit += 0.65;
				score = 200;
				goods++;
			case 'bad':
				if (!botPlayOn) totalNotesHit += 0.2;
				score = 100;
				bads++;
			case 'shit':
				if (!botPlayOn) totalNotesHit -= 2;
				score = 50;
				shits++;
		}
	
		if (!botPlayOn)
		{
			songScore += score;
		}

		var pixelShit:String = "";

		if (daStyle == 'pixel')
		{
			pixelShit = 'pixelUI/';
		}

		rating.loadGraphic(Paths.image('UI/' + pixelShit + daRating));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('UI/' + pixelShit + 'combo'));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (daStyle != 'pixel')
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = FlxG.save.data.antiAliasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = FlxG.save.data.antiAliasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		var comboSplit:Array<String> = (combo + "").split('');

		if (comboSplit.length == 2)
			seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

		for(i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('UI/' + pixelShit + 'num' + Std.int(i)));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (daStyle != 'pixel')
			{
				numScore.antialiasing = FlxG.save.data.antiAliasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	private function keyShit():Void
	{
		// PRESSING
		var controlArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		
		// HOLDING
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		
		// RELEASING
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		
		if(botPlayOn)
		{
			holdArray = [false, false, false, false];
			controlArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (controlArray.contains(true) && !boyfriend.stunned && generatedMusic)
		{
			//boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			// tried it out with the test song and apparently the input system is still shit fuck
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{
					possibleNotes.push(daNote);
				}
			});

			possibleNotes.sort((a, b) -> Std.int(a.noteData - b.noteData)); // sorting twice is necessary as far as i know

			if (possibleNotes.length > 0) // left down up right
			{
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes)
				{
					if (controlArray[note.noteData % 4])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition +
							(Conductor.safeZoneOffset * 0.07)) // reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
							{
								lasthitnotetime = -9999999;
								continue; // the jacks are too close together
							}
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}
			}
			else if (!theFunne)
			{
				for (i in 0...controlArray.length)
				{
					if (controlArray[i])
					{
						noteMiss(i % 4);
					}
				}
			}
		}
	
		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (holdArray.contains(true))
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote && holdArray[daNote.noteData] == true)
						goodNoteHit(daNote);
				}
				else if (botPlayOn)
				{
					var noteLine:Float;
					
					if (daNote.MyStrum != null)
						noteLine = daNote.MyStrum.y;
					else
						noteLine = strumLine.y;
						
					if(FlxG.save.data.downscroll && daNote.y > noteLine || !FlxG.save.data.downscroll && daNote.y < noteLine)
					{
						if(daNote.canBeHit && daNote.mustPress || daNote.tooLate && daNote.mustPress)
							goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || botPlayOn)
			&& boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
		{
			boyfriend.dance();
			boyfriendIdleColor();
				
			bfNoteCamOffset[0] = 0;
			bfNoteCamOffset[1] = 0;
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
			{
				spr.animationPlay('pressed');
			}
			if (releaseArray[spr.ID])
			{
				spr.animationPlay('static');
			}
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			
			var animToPlay:String = '';
			switch (direction)
			{
				case 0:
					animToPlay = 'singLEFT';
				case 1:
					animToPlay = 'singDOWN';
				case 2:
					animToPlay = 'singUP';
				case 3:
					animToPlay = 'singRIGHT';
			}
			
			if (boyfriend.animation.getByName("singLEFTmiss") != null)
			{
				animToPlay += 'miss';
			}
			else
			{
				boyfriend.color = 0xFF000084;
			}
			
			boyfriend.playAnim(animToPlay, true);

			updateAccuracy();
		}
	}

	function updateAccuracy()
	{
		if (!botPlayOn)
		{
			totalPlayed += 1;
			
			if (accuracy > 100.0)
				accuracy = 100.0;
			else
				accuracy = (totalNotesHit / totalPlayed) * 100;
		}
	}
	
	function cameraMoveOnNote(note:Int, character:String)
	{
		var amount:Array<Float> = new Array<Float>();
		var followAmount:Float = FlxG.save.data.noteCamera ? 10 : 0;
		switch (note)
		{
			case 0:
				amount[0] = -followAmount;
				amount[1] = 0;
			case 1:
				amount[0] = 0;
				amount[1] = followAmount;
			case 2:
				amount[0] = 0;
				amount[1] = -followAmount;
			case 3:
				amount[0] = followAmount;
				amount[1] = 0;
		}
		switch (character)
		{
			case 'dad':
				dadNoteCamOffset = amount;
			case 'bf':
				bfNoteCamOffset = amount;
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note.noteStyle);
				combo += 1;
			}
			else
			{
				if (!botPlayOn) totalNotesHit += 1;
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			var animList:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
			boyfriend.playAnim('sing' + animList[Math.round(Math.abs(note.noteData))], true);
			boyfriend.holdTimer = 0;
			
			boyfriendIdleColor();
			
			cameraMoveOnNote(note.noteData, 'bf');

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animationPlay('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();
			
			updateAccuracy();
		}
	}
	
	function dadNoteHit(daNote:Note)
	{
		if (SONG.song != 'Tutorial')
			camZooming = true;

		var altAnim:String = "";
		var healthtolower:Float = 0.02;

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].altAnim)
				if (SONG.song.toLowerCase() != "cheating")
				{
					altAnim = '-alt';
				}
				else
				{
					healthtolower = 0.005;
				}
		}
		
		var animToPlay:String = ''; 
		switch (Math.abs(daNote.noteData))
		{	
			case 0:
				animToPlay = 'singLEFT';
			case 1:
				animToPlay = 'singDOWN';
			case 2:
				animToPlay = 'singUP';
			case 3:
				animToPlay = 'singRIGHT';
		}
		
		dad.playAnim(animToPlay + altAnim, true);
		dad.holdTimer = 0;
		
		switch (curSong)
		{
			case "cheating":
				health -= healthtolower;
			case 'disruption':
				health -= healthtolower / 2.7;
		}
		
		cameraMoveOnNote(daNote.noteData, 'dad');
		
		if (curSong == 'insanity')
		{
			dadmirror.playAnim(animToPlay + altAnim, true);
			dadmirror.holdTimer = 0;
		}
		
		dadStrums.forEach(function(spr:StrumNote)
		{
			if (Math.abs(daNote.noteData) == spr.ID)
			{
				spr.animationPlay('confirm', true);
			}
		});
		
		if(dad.curCharacter == 'bambi-piss-3d')
		{
			FlxG.camera.shake(0.0075, 0.1);
			camHUD.shake(0.0045, 0.1);
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		daNote.kill();
		notes.remove(daNote, true);
		daNote.destroy();
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		switch (curSong)
		{
			case 'insanity':
				switch (curStep)
				{
					case 660:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.createIcon('dave-angey');
					case 664:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.createIcon('dave');
					case 680:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.createIcon('dave-angey');
					case 684:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.createIcon('dave');
					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('dave/redsky_fix_attempt'));
						curbg.visible = true;
						iconP2.createIcon('dave-angey');
					case 1180:
						dad.visible = true;
						dadmirror.visible = false;

						dad.frames = Paths.getSparrowAtlas('dave/HolyFubeepWhatJustHappened');
						dad.animation.addByPrefix('holyFubeep', 'HOLYMOLYWHATJUSTHAPPENED', 24, true);
						dad.animation.play('holyFubeep');
						dad.canDance = false;
						iconP2.createIcon('dave');
				}
			case 'polygonized':
				switch(curStep)
				{
					case 128 | 640 | 704 | 1535:
						defaultCamZoom = 0.9;
					case 256 | 768 | 1468 | 1596 | 2048 | 2144 | 2428:
						defaultCamZoom = 0.7;
					case 688 | 752 | 1279 | 1663 | 2176:
						defaultCamZoom = 1;
					case 1019 | 1471 | 1599 | 2064:
						defaultCamZoom = 0.8;
					case 1920:
						defaultCamZoom = 1.1;

					case 1024 | 1312:
						defaultCamZoom = 1.1;
						crazyZooming = true;
						shakeCam = true;
						
					case 1152 | 1408:
						defaultCamZoom = 0.9;
						shakeCam = false;
						crazyZooming = false;
					case 2432:
						polygonizedEnd();
				}
			case 'splitathon':
				switch (curStep)
				{
					case 4736:
						dad.visible = false;
						splitathonExpression('lookup', 225, 400);
					case 4800:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('backup', -100, 400);
						dad.visible = true;
						bambiEntered = true;
						changeDad("bambi-splitathon");
						if (BAMBICUTSCENEICONHURHURHUR == null)
						{
							BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi", false);
							BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
							add(BAMBICUTSCENEICONHURHURHUR);
							BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
							BAMBICUTSCENEICONHURHURHUR.x = -100;
							FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3);
							new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
						}
						bambiEntered = false;
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-what', -100, 550);
						changeDad("dave-splitathon");
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('end', -100, 400);
						changeDad("bambi-splitathon");
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi-corn', -100, 550);
						changeDad("dave-splitathon");
				}
			case 'mealie':
				switch (curStep)
				{
					case 1776:
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						changeDad('bambi-angey');
				}
		}
	}
	
	var gfBeatSnap:Int = 1;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		/*if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}*/
		
		if (camZooming && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (crazyZooming)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		
		if(shakeCam && gf.animation.getByName("scared") != null)
		{
			gf.playAnim('scared', true);
		}
		
		var funny:Float = (healthBar.percent * 0.01) + 0.01;
		
		//health icon bounce but epic
		iconP1.setGraphicSize(Std.int(iconP1.width + (50 * funny)), Std.int(iconP2.height - (25 * funny)));
		iconP2.setGraphicSize(Std.int(iconP2.width + (50 * (2 - funny))), Std.int(iconP2.height - (25 * (2 - funny))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();
		
		if (CharacterSelectState.singleBop.contains(gf.curCharacter))
		{
			gfBeatSnap = 2;
		}
		else
		{
			gfBeatSnap = gfSpeed;
		}

		if (curBeat % (gfBeatSnap + (curSong == 'disruption' && !CharacterSelectState.singleBop.contains(gf.curCharacter) ? 1 : 0)) == 0)
		{
			if (!(shakeCam && gf.animation.getByName("scared") != null) && gf.canDance)
			{
				gf.dance();
			}
		}

		if (curBeat % 2 == 0)
		{
			if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance
				&& (boyfriend.animation.curAnim.name == "hit" ? boyfriend.animation.curAnim.finished : true)
				&& (boyfriend.animation.curAnim.name == "dodge" ? boyfriend.animation.curAnim.finished : true))
			{
				boyfriend.dance();
				boyfriendIdleColor();
			}
		}
		
		if (!dad.animation.curAnim.name.startsWith("sing") && curBeat % (dad.curCharacter == 'bambi-piss-3d' ? 4 : 2) == 0)
		{
			dad.dance();
			if (curSong == 'insanity') dadmirror.dance();
		}

		if (curBeat % 8 == 7)
		{
			if (curSong == 'tutorial' && dad.curCharacter == 'gf')
			{
				dad.playAnim('cheer', true);
				boyfriend.playAnim('hey', true);
			}
		}
		
		gf.trepTransi(SONG.bpm);
	}
	
	public function changeDad(char:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		remove(dad);
		dad = new Character(100, 100, char);
		dad.x += dad.charOffset[0];
		dad.y += dad.charOffset[1];
		if (curSong == 'splitathon' || curSong == 'mealie')
			dad.color = 0xFF878787;
		add(dad);
		if (!(curSong == 'splitathon' && bambiEntered))
			iconP2.createIcon(char);
		boyfriend.stunned = false;
	}
	
	public function splitathonExpression(expression:String, x:Float, y:Float):Void
	{
		if (curSong == 'splitathon')
		{
			boyfriend.stunned = true;
			thing.color = 0xFF878787;
			thing.x = x;
			thing.y = y;

			switch (expression)
			{
				case 'lookup':
					thing.frames = Paths.getSparrowAtlas('splitathon/uhhWhatNow');
					thing.animation.addByPrefix('uhhSoWhatDoWeDoNow', 'Well', 24);
					thing.animation.play('uhhSoWhatDoWeDoNow');
				case 'backup':
					thing.frames = Paths.getSparrowAtlas('splitathon/Why');
					thing.animation.addByPrefix('whyMustYouDoThisToMeBambiWHYYYYY', 'What??????', 24);
					thing.animation.play('whyMustYouDoThisToMeBambiWHYYYYY');
				case 'end':
					thing.frames = Paths.getSparrowAtlas('splitathon/Yeah');
					thing.animation.addByPrefix('yeahhhBambiiiiTakeHimDown', 'YEAH!', 24);
					thing.animation.play('yeahhhBambiiiiTakeHimDown');
				case 'bambi-what':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_WaitWhatNow');
					thing.animation.addByPrefix('uhhhImConfusedWhatsHappening', 'what', 24);
					thing.animation.play('uhhhImConfusedWhatsHappening');
				case 'bambi-corn':
					thing.frames = Paths.getSparrowAtlas('splitathon/Bambi_ChillingWithTheCorn');
					thing.animation.addByPrefix('justGonnaChillHereEatinCorn', 'cool', 24);
					thing.animation.play('justGonnaChillHereEatinCorn');
			}
			if (!splitathonExpressionAdded)
			{
				splitathonExpressionAdded = true;
				insert(members.indexOf(dad), thing);
			}
			thing.antialiasing = FlxG.save.data.antiAliasing;
			boyfriend.stunned = false;
		}
	}
	
	public function preloadAsset(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}
	
	public function preloadChar(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:Character = new Character(9000,-9000, graphic);
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}
}
