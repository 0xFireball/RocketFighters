package sprites.weapons;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class Weapon extends FlxSprite {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        // makeGraphic(40, 15, FlxColor.RED);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
    }

    public function fireFree(target:FlxPoint) {
        // override this
    }

}