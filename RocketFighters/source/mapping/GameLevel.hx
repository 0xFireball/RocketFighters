package mapping;

import flixel.*;
import flixel.math.*;
import flixel.util.*;
import flixel.addons.editors.tiled.*;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;
import haxe.io.Path;

import states.game.*;

import sprites.magic.*;

class GameLevel extends TiledLevel {

    public function new(tiledLevel:FlxTiledMapAsset, tiledRootPath:String, state:PlayState) {
		super(tiledLevel, tiledRootPath);
        
        loadObjects(state);
    }

    public function loadObjects(state:PlayState)
	{
		var layer:TiledObjectLayer;
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			// collection of images layer
			if (layer.name == "features")
			{
				for (o in objectLayer.objects)
				{
					loadImageObject(o);
				}
			}
			
			// objects layer
			if (layer.name == "objects")
			{
				for (o in objectLayer.objects)
				{
					loadObject(state, o, objectLayer, objectsLayer);
				}
			}
		}
	}
	
	private function loadImageObject(object:TiledObject)
	{
		var tilesImageCollection:TiledTileSet = this.getTileSet("imageCollection");
		var tileImagesSource:TiledImageTile = tilesImageCollection.getImageSourceByGid(object.gid);
		
		var decoSprite:FlxSprite = new FlxSprite(0, 0, TiledLevel.c_PATH_LEVEL_TILESHEETS + tileImagesSource.source);
		if (decoSprite.width != object.width ||
			decoSprite.height != object.height)
		{
			decoSprite.antialiasing = true;
			decoSprite.setGraphicSize(object.width, object.height);
		}
		decoSprite.setPosition(object.x, object.y - decoSprite.height);
		decoSprite.origin.set(0, decoSprite.height);
		if (object.angle != 0)
		{
			decoSprite.angle = object.angle;
			decoSprite.antialiasing = true;
		}
		
		// Custom Properties
		if (object.properties.contains("depth"))
		{
			var depth = Std.parseFloat( object.properties.get("depth"));
			decoSprite.scrollFactor.set(depth,depth);
		}

		backgroundLayer.add(decoSprite);
	}
	
	private function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer, group:FlxGroup)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
		switch (o.type.toLowerCase()) {
			case "spawner":
				// create spawner
				// ... TODO
			// case "exit":
			// 	// Create the level exit
			// 	var exit = new FlxSprite(x, y);
			// 	exit.makeGraphic(32, 32, 0xff3f3f3f);
			// 	exit.exists = false;
			// 	state.exit = exit;
			// 	group.add(exit);
		}
	}

}