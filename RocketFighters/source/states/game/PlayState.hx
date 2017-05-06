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
import sprites.projectiles.*;

import states.game.data.*;

class PlayState extends FlxState {
    public static var gameZoom = 1.0;

    public var player:PlayerFighter;
    public var fighters:FlxTypedGroup<Fighter>;
    public var projectiles:FlxTypedGroup<Projectile>;

    public var level:GameLevel;
    public var mapLoader:GameMapLoader = new GameMapLoader();

    public var stateData:PlayStateData;

    public override function create() {

        #if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.diamond_mouse__png);
		#end

        bgColor = Registry.backgroundColor;

        stateData = new PlayStateData();

        projectiles = new FlxTypedGroup<Projectile>();
        stateData.projectiles = projectiles;

        var backdrop = new FlxBackdrop(AssetPaths.backdrop__png, 0.2, 0.2);
        add(backdrop);

        level = mapLoader.loadMap("lbp_stage", this);
        addLevel(level);

        fighters = new FlxTypedGroup<Fighter>();
        add(fighters);
        stateData.fighters = fighters;

        player = new PlayerFighter(stateData);
        spawnFighter(player);
        fighters.add(player);
        stateData.player = player;

        add(projectiles);

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

        // Collide projectiles
		projectiles.forEachAlive(function (pj) {
            if (level.overlapWithLevel(pj)) {
                pj.hitBoundary();
            }
		});

        super.update(dt);
    }

    private function openPause() {
        openSubState(new PauseSubState(Registry.unfocusColor));
    }

    public override function destroy() {
        if (level != null) level.destroy();
        level = null;

        stateData.destroy();
        stateData = null;

        super.destroy();
    }
}