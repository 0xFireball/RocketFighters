package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

import sprites.*;

class Fighter extends GamePresence {

    public var movementSpeed:Float = 5;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        makeGraphic(20, 40, FlxColor.BLUE);
    }

    public override function update(dt:Float) {
        movement();

        super.update(dt);
    }
    
    private function movement() {
        // todo
    }

}