package sprites;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

class GamePresence extends SuperSprite {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        // set game acceleration
        acceleration.set(0, 240);
        maxVelocity.set(400, 400);
        drag.set(200, 200);
    }

}