package states;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import nf4.ui.*;
import nf4.effects.particles.*;
import nf4.util.*;

import states.game.*;

import ui.*;
import ui.menu.*;

class MenuState extends SBNFMenuState {
	private var titleTx:NFText;

	private var emitter:FlxEmitter;
	public var effectEmitter:NFParticleEmitter;

	public var flixelEmitter:Bool = true;

	public var emitterExplosion:Bool = true;
	public var normalEmitTime:Float = 1.1;
	public var normalEmitTimer:Float = 0;

	public var playing:Bool = false;
	public var canPlay:Bool = false;

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.mouse__png);
		#end

		#if (!FLX_NO_GAMEPAD && !FLX_NO_MOUSE)
        // hide mouse if there's a mouse and an active gamepad
        if (FlxG.gamepads.lastActive != null) {
			FlxG.mouse.visible = false;
        }
        #end

		bgColor = Registry.backgroundColor;

		titleTx = new SBNFText(0, 0, "RocketFighters", 84);
		titleTx.color = Registry.foregroundAccentColor;
		titleTx.screenCenter(FlxAxes.X);
		titleTx.y = -titleTx.height;
		var titleFinalY = 180;
		FlxTween.tween(titleTx, { y: titleFinalY }, 0.7, { ease: FlxEase.cubeOut });

		emitter = new FlxEmitter(FlxG.width / 2, titleFinalY + titleTx.height * 1.2);
		emitter.scale.set(2, 2, 8, 8, 12, 12, 12, 12);
		emitter.makeParticles(1, 1, FlxColor.WHITE, 200);
		emitter.color.set(FlxColor.fromInt(0xA3A256), FlxColor.fromInt(0xD6D454));
		emitter.alpha.set(1, 1, 0, 0);
		emitter.speed.set(400, 580);
		emitter.lifespan.set(0.8);
		// start emitter
		emitter.start(true);
		add(emitter);

		add(titleTx); // add title after emitter

		var credits = new SBNFText(32, 0, "PetaPhaser", 48);
		credits.y = FlxG.height - (credits.height + 32);
		add(credits);

		var version = new SBNFText(32, 0, Registry.gameVersion, 48);
		version.y = FlxG.height - (version.height + 32);
		version.x = FlxG.width - (version.width + 32);
		add(version);

		// set up menu
		menuGroup.updatePosition(FlxG.width / 2, 340);
        menuGroup.itemMargin = 12;
        menuWidth = 240;
        menuItemTextSize = 32;

		menuItems.push({
            text: "Play",
            callback: onClickPlay
        });

		menuItems.push({
            text: "Settings",
            callback: onClickSettings
        });

		#if NF_NO_ANIMATION
		FlxTween.color(credits, 0.9, FlxColor.fromRGBFloat(0.8, 0.1, 0.1), FlxColor.fromRGBFloat(0.98, 0.98, 0.98), { startDelay: 0.6, ease: FlxEase.cubeInOut });

		FlxG.camera.fade(Registry.backgroundColor, 1.1, true, function () {
			canPlay = true;
		});
		FlxG.camera.shake(0.01, 0.5);
		#else
		canPlay = true;
		#end

		// music
		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic(AssetPaths.pp_asdf3__ogg, 1.0, true);
		}

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		normalEmitTimer += elapsed;
		if (emitterExplosion && normalEmitTimer > normalEmitTime) {
			emitterExplosion = false;
			emitter.speed.set(120, 280);
			emitter.lifespan.set(0.6);
			emitter.start(false, 0.003);
		}

		// hotkeys
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			tryExitGame();
		}
		#end

		super.update(elapsed);
	}

	private function onClickPlay() {
		if (!canPlay || playing) return;
		playing = true;

		var waveFct = new FlxWaveEffect(12);
		var distortedTitle = new FlxEffectSprite(titleTx, [ waveFct ]);
		distortedTitle.setPosition(titleTx.x, titleTx.y);
		add(distortedTitle);
		FlxTween.tween(titleTx, { alpha: 0 }, 0.9, { onComplete: function (t) {
			remove(titleTx);
		}});
		FlxTween.tween(distortedTitle, { alpha: 1 }, 0.9, { ease: FlxEase.cubeIn });
		// switch
		FlxG.camera.fade(Registry.washoutColor, 0.8, false, function () {
			FlxG.switchState(new LevelSelectState());
		});
	}

	private function onClickSettings() {
		FlxG.camera.fade(Registry.washoutColor, 0.4, false, function () {
			FlxG.switchState(new SettingsState());
		});
	}

	private function tryExitGame() {
		#if (desktop)
		openfl.system.System.exit(0);
		#end
	}
}
