package sprites.weapons;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Bazooka extends Weapon {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        loadGraphic(AssetPaths.rf_bazooka__png, true, 64, 64);
    }

    public override function fireFree(target:FlxPoint) {
        
    }

}