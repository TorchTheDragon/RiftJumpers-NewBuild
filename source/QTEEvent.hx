package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.FlxCamera;

using StringTools;

class QTEEvent extends MusicBeatSubstate
{	
	/*
	Torch -
	Quick not for anyone using this code, do not use these following symbols:
	;
	:
	'
	"
	/
	\
	[
	]
	{
	}
	-
	_
	=
	+
	<
	>
	`
	~
	|
	That is all the symbols you can't use
	*/
	var sequences:Array<String> = [
		'A',
		'B',
		'C',
		'D',
		'E',
		'F',
		'G',
		'H',
		'I',
		'J',
		'K',
		'L',
		'M',
		'N',
		'O',
		'P',
		'Q',
		'R',
		'T',
		'U',
		'V',
		'W',
		'X',
		'Y',
		'Z'
	];
	
	var lines:FlxTypedGroup<FlxSprite>;
	var letters:FlxTypedSpriteGroup<FlxSprite>;
	public var win:Void->Void = null;
	public var lose:Void->Void = null;
	var timer:Int = 10;
	var timerText:FlxText;
	var selectedSequence:String;
	var realSequence:String = '';
	var position:Int = 0;

	//var wrongLetter:FlxSound = FlxG.sound.play(Paths.sound('missnote1', 'shared'));
	
	public function new(theTimer:Int = 15, word:String = '')
	{
		timer = theTimer;
		super();

		selectedSequence = sequences[FlxG.random.int(0, sequences.length - 1)];
		
		if (word != '')
			selectedSequence = word;
		
		selectedSequence = selectedSequence.toUpperCase();
		var splitSequence = selectedSequence.split(' ');
		
		var dum:Bool = false;
		
		for (i in splitSequence) {
			realSequence += i;
		}
		trace(realSequence);
		
		lines = new FlxTypedGroup<FlxSprite>();
		add(lines);
		
		letters = new FlxTypedSpriteGroup<FlxSprite>();
		add(letters);
		
		var realThing:Int = 0;
		
		for (i in 0...selectedSequence.length) {
			if (!selectedSequence.isSpace(i))
			{
				var letter:FlxSprite = new FlxSprite(0, FlxG.height * 0.5 - 20);
				
				if (260 - (15 * selectedSequence.length) <= 0)
					letter.x += 40 * i;
				else
					letter.x += (260 - (15 * selectedSequence.length)) * i;
				
				var realScale = 1 - (0.05 * selectedSequence.length);
				
				if (realScale < 0.2)
					realScale = 0.2;
				
				letter.scale.set(realScale, realScale);
				letter.updateHitbox();
				letter.frames = Paths.getSparrowAtlas('extras/quicktime/quickTimeAlphabet', 'riftjumpers'); //Torch - Need to create these textures
				letter.animation.addByPrefix('idle', selectedSequence.charAt(i), 24, true);
				letter.animation.play('idle');
				letters.add(letter);
				
				
				var line:FlxSprite = new FlxSprite(letter.x, letter.y).loadGraphic(Paths.image('extras/quicktime/line', 'riftjumpers'));
				line.y += 500;
				line.scale.set(letter.scale.x, letter.scale.y);
				line.updateHitbox();
				line.ID = realThing;
				lines.add(line);
				realThing++;
			}
		}
		
		letters.screenCenter(X);
		for (i in 0...lines.length)
		{
			lines.members[i].x = letters.members[i].x;
		}
		
		timerText = new FlxText(FlxG.width / 2 - 5, letters.members[0].y - 75, 0, '0', 32);
		timerText.alignment = 'center';
		timerText.font = Paths.font('badaboom.ttf');
		add(timerText);
		timerText.text = Std.string(timer);
	}
	
	function correctLetter() {
		position++;
		if (position >= realSequence.length) 
		{
			close();
			win();
			FlxG.sound.play(Paths.sound('CLAP', 'shared'));
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		for (i in lines) 
		{
			i.visible = false;
			i.alpha = 0;
			/*
			Uncomment this if I want to use the lines again

			if (i.ID == position) 
			{
				FlxFlicker.flicker(i, 1.3, 1, true, false);
			} 
			else if (i.ID < position) 
			{
				i.visible = false;
				i.alpha = 0;
			}
			*/
		}
		
		if (FlxG.keys.justPressed.ANY) {
			if (realSequence.charAt(position) == '?') 
			{
				if (FlxG.keys.justPressed.SLASH && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			} 
			else if (realSequence.charAt(position) == '!') 
			{
				if (FlxG.keys.justPressed.ONE && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '@') 
			{
				if (FlxG.keys.justPressed.TWO && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			} 
			else if (realSequence.charAt(position) == '#') 
			{
				if (FlxG.keys.justPressed.THREE && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '$') 
			{
				if (FlxG.keys.justPressed.FOUR && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '^') 
			{
				if (FlxG.keys.justPressed.SIX && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '&') 
			{
				if (FlxG.keys.justPressed.SEVEN && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '*') 
			{
				if (FlxG.keys.justPressed.EIGHT && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			/* Don't use these, breaks game for some reason
			else if (realSequence.charAt(position) == '(') 
			{
				if (FlxG.keys.justPressed.NINE && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == ')') 
			{
				if (FlxG.keys.justPressed.ZERO && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '_') 
			{
				if (FlxG.keys.justPressed.MINUS && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == ':') 
			{
				if (FlxG.keys.justPressed.SEMICOLON && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '"') 
			{
				if (FlxG.keys.justPressed.QUOTE && FlxG.keys.pressed.SHIFT)
					correctLetter();
				else if (!FlxG.keys.justPressed.SHIFT)
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			} */
			else if (realSequence.charAt(position) == '1') 
			{
				if (FlxG.keys.justPressed.ONE)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '2') 
			{
				if (FlxG.keys.justPressed.TWO)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}else if (realSequence.charAt(position) == '3') 
			{
				if (FlxG.keys.justPressed.THREE)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '4') 
			{
				if (FlxG.keys.justPressed.FOUR)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '5') 
			{
				if (FlxG.keys.justPressed.FIVE)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '6') 
			{
				if (FlxG.keys.justPressed.SIX)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '7') 
			{
				if (FlxG.keys.justPressed.SEVEN)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '8') 
			{
				if (FlxG.keys.justPressed.EIGHT)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '9') 
			{
				if (FlxG.keys.justPressed.NINE)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else if (realSequence.charAt(position) == '0') 
			{
				if (FlxG.keys.justPressed.ZERO)
					correctLetter();
				else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
			else 
			{
				if (FlxG.keys.anyJustPressed([FlxKey.fromString(realSequence.charAt(position))])) {
					correctLetter();
				} else
					FlxG.sound.play(Paths.sound('missnote1', 'shared'));
			}
		}
		
		//Torch - For Testing Only
		if (FlxG.keys.justPressed.NUMPADONE) 
		{
			close();
			win();
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		if (timer > 0)
			timer--;
		else 
		{
			close();
			lose();
		}
		
		timerText.text = Std.string(timer);
	}
	
	override public function close() 
	{
		FlxG.autoPause = true;
		super.close();
	}
}