package mapping;

import flixel.*;
import haxe.io.Path;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;

import states.game.*;

class GameMapLoader {

    private static inline var c_MAP_ASSET_PATH = "assets/maps/";

    public function new() {
    }

    public function loadMap(mapName:String, state:PlayState) {
        var gLevMap = new GameLevel(c_MAP_ASSET_PATH + mapName + ".tmx", c_MAP_ASSET_PATH, state);
        FlxG.worldBounds.set(0, 0, gLevMap.fullWidth, gLevMap.fullHeight);
        return gLevMap;
    }

}