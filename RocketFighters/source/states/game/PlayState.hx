package states.game;

import flixel.*;
import flixel.group.FlxGroup;
import flixel.util.*;
import flixel.math.*;
import flixel.tile.*;
import flixel.addons.display.*;

import mapping.*;

import sprites.fighters.*;
import sprites.things.*;

class PlayState extends FlxState {
    public static var gameZoom = 1.0;

    public var player:PlayerFighter;
    public var fighters:FlxTypedGroup<Fighter>;

    public var level:GameLevel;
    public var mapLoader:GameMapLoader = new GameMapLoader();

    public override function create() {

        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.diamond_mouse__png);
		#end

        bgColor = Registry.backgroundColor;

        var backdrop = new FlxBackdrop(AssetPaths.backdrop__png, 0.2, 0.2);
        add(backdrop);

        level = mapLoader.loadMap("lbp_stage", this);
        addLevel(level);

        fighters = new FlxTypedGroup<Fighter>();
        add(fighters);

        player = new PlayerFighter();
        spawnFighter(player);
        fighters.add(player);

        FlxG.camera.follow(player, PLATFORMER, 1.0);
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

    public function spawnFighter(fighter:Fighter) {
        // get available spawners, and randomly pick one
        var targetSpawnerPos = level.spawnerPositions[Std.int(Math.random() * level.spawnerPositions.length)];
        fighter.setPosition(targetSpawnerPos.x, targetSpawnerPos.y);
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
        fighters.forEachExists(function (fighter) {
            level.collideWithLevel(fighter);
        });

        // Collide with Things
        FlxG.overlap(fighters, level.objectsLayer, function (f:Fighter, thing:MapThing) {
            thing.hitFighter(f);
        });

        super.update(dt);
    }

    private function openPause() {
        openSubState(new PauseSubState(Registry.unfocusColor));
    }

    public override function destroy() {
        if (level != null) level.destroy();
        level = null;

        super.destroy();
    }
}