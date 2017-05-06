package sprites.weapons;

import flixel.*;
import flixel.util.*;

class Weapon extends FlxSprite {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        makeGraphic(40, 15, FlxColor.RED);
    }

}