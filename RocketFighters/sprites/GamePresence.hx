package sprites;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

import nf4.*;

class GamePresence extends NFSprite {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        // set game acceleration
        acceleration.set(0, 160);
        maxVelocity.set(400, 400);
        drag.set(200, 200);
    }

}