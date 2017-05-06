package intro;

import flixel.*;
import flixel.util.*;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import states.*;

/**
 * ...
 * @author ...
 */
class FFIntroState extends FlxState
{
	private var _ffLogo:FFLogo;
	private var _t:Float = 0;
	private var anim1:Bool = false;
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end

		bgColor = FlxColor.fromInt(0xFF111111);
		
		_ffLogo = new FFLogo();
		_ffLogo.scaleFactor = FlxG.stage.stageWidth / _ffLogo.width;
		_ffLogo.screenCenter(FlxAxes.XY);
		_ffLogo.alpha = 0;
		add(_ffLogo);

		FlxG.camera.fade(FlxColor.fromInt(0xFF555555), 0.2, true);
		FlxTween.tween(_ffLogo, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadIn });
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		_t += elapsed;
		if (_t > (60 / FlxG.updateFramerate) && !anim1)
		{
			anim1 = true;
			FlxTween.tween(_ffLogo, { alpha: 0, scaleFactor: 3 }, 1.2, { ease: FlxEase.cubeOut, onComplete: switchToGameIcon, type: FlxTween.ONESHOT});
		}
		super.update(elapsed);
	}
	
	private function switchToGameIcon(tween:FlxTween):Void
	{
		FlxG.switchState(new MenuState());
	}
}