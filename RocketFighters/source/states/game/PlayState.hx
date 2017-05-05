package states.game;

import flixel.*;
import flixel.group.FlxGroup;
import flixel.util.*;
import flixel.math.*;
import flixel.tile.*;

import mapping.*;

class PlayState extends FlxState {
    public static var gameZoom = 1.0;

    public var level:GameLevel;
    public var mapLoader:GameMapLoader = new GameMapLoader();

    public override function create() {

        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.diamond_mouse__png);
		#end

        bgColor = Registry.backgroundColor;

        level = mapLoader.loadMap("lbp_stage", this);

        addLevel(level);

        // FlxG.camera.follow(player, PLATFORMER, 1.0);
        FlxG.camera.zoom = gameZoom;

        FlxG.camera.fade(Registry.washoutColor, 1.1, true);

        super.create();
    }

    public function addLevel(CurrentLevel:GameLevel) {
		add(CurrentLevel.backgroundLayer);
		add(CurrentLevel.imagesLayer);
		add(CurrentLevel.objectsLayer);
		add(CurrentLevel.foregroundTiles);
    }

    public function removeLevel(CurrentLevel:GameLevel) {
		remove(CurrentLevel.backgroundLayer);
		remove(CurrentLevel.imagesLayer);
		remove(CurrentLevel.objectsLayer);
		remove(CurrentLevel.foregroundTiles);
    }

    public override function update(dt:Float) {
        #if !FLX_NO_KEYBOARD
        // pause menu
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
			openPause();
		}
        #end

        #if !FLX_NO_GAMEPAD
		if (FlxG.gamepads.lastActive != null) {
			if (FlxG.gamepads.lastActive.anyJustPressed([ START ])) {
				openPause();
			}
        }
        #end

        // Collide with foreground tile layer
		// level.collideWithLevel(player);

        super.update(dt);
    }

    private function openPause() {
        openSubState(new PauseSubState(Registry.unfocusColor));
    }
}