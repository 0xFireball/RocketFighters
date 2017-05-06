package sprites.weapons;

import flixel.*;

class Bazooka extends Weapon {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        loadGraphic(AssetPaths.rf_bazooka__png, true, 64, 64);
    }

}