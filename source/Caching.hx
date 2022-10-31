#if sys
package;

import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.ui.FlxBar;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone:Int = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var kadeLogo:FlxSprite;

	public static var bitmapData:Map<String,FlxGraphic>;

	var images = [];
	var music = [];
	var sounds = [];

	var curLoading:String = "";

	override function create()
	{

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		bitmapData = new Map<String,FlxGraphic>();

		text = new FlxText(0, FlxG.height / 2 + 300, 0, "Loading...", 34);
		text.size = 34;
		//text.setFormat(Paths.font("badaboom.ttf"), 34, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.screenCenter(X);

		kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.x -= kadeLogo.width / 2;
		kadeLogo.y -= kadeLogo.height / 2 + 100;
		text.y -= kadeLogo.height / 2 - 125;
		text.x -= 170;
		kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.6));
		if(FlxG.save.data.antialiasing != null)
			kadeLogo.antialiasing = FlxG.save.data.antialiasing;
		else
			kadeLogo.antialiasing = true;

		FlxGraphic.defaultPersist = FlxG.save.data.cacheImages;

		#if cpp
		if (FlxG.save.data.cacheImages)
		{
			trace("caching images...");

			loadDirectAssets('assets/shared/images/characters', images);
			/*
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
			*/
		}

		trace("caching music...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			if(StringTools.endsWith(i, "txt")) 
				continue;
			if(i == "offsettest")
				continue;
			music.push(i);
		}

		trace("caching sounds...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/riftjumpers/sounds")))
		{
			if(StringTools.endsWith(i, "txt")) 
				continue;
			sounds.push(i);
		}
		#end

		//toBeDone = Lambda.count(images) + Lambda.count(music);
		toBeDone = images.length + music.length;

		var bar = new FlxBar(0, FlxG.height - 50, LEFT_TO_RIGHT, Std.int(FlxG.width * 0.9), 20, this, 'done', 0, toBeDone);
		bar.screenCenter(X);
		//bar.color = FlxColor.PURPLE;
		bar.createFilledBar(0xFF2b2b2b, FlxColor.WHITE);

		add(bar);

		add(kadeLogo);
		add(text);

		trace('starting caching..');
		
		#if cpp
		// update thread

		sys.thread.Thread.create(() -> {
			while(!loaded)
			{
				if (toBeDone != 0 && done != toBeDone)
					{
						text.text = "Loading " + curLoading + "... (" + done + "/" + toBeDone + ")";
						text.screenCenter(X);
					}
			}
		
		});

		// cache thread

		sys.thread.Thread.create(() -> {
			cache();
		});
		#end

		super.create();
	}

	function loadDirectAssets(absoluteDirectory:String, path)
    {
        #if cpp
        for (i in FileSystem.readDirectory(FileSystem.absolutePath(absoluteDirectory)))
        {
            if (!i.endsWith(".png"))
                continue;
            path.push(i);
        }
        #end
    }

    function loadAssets(directory:String, path) 
    {
        #if cpp
        for (i in FileSystem.readDirectory(directory))
        {
            if (!i.endsWith(".png"))
                continue;
            path.push(i);
        }
        #end
    }

	var calledDone = false;

	override function update(elapsed) 
	{
		super.update(elapsed);
	}


	function cache()
	{
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
			var replaced = i.replace(".png","");
			curLoading = 'images';
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			trace('id ' + replaced + ' file - assets/shared/images/characters/' + i + ' ${data.width}');
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			done++;
		}

		for (i in music)
		{
			curLoading = 'music';
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("cached " + i);
			done++;
		}

		trace("Finished caching...");

		loaded = true;

		trace(Assets.cache.hasBitmapData('GF_assets'));

		FlxG.switchState(new TitleState());
	}

}
#end