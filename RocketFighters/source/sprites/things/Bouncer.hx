package sprites.things;

import flixel.*;
import flixel.util.*;

import sprites.fighters.*;

class Bouncer extends MapThing {

    public var boost:Float = 320;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        immovable = true;
        makeGraphic(16, 16, FlxColor.TRANSPARENT);
        offset.set(4, 6);
        setSize(8, 4);
        visible = false;
    }

    public override function hitFighter(Fighter:Fighter) {
        // propel the fighter upward

        Fighter.velocity.y -= boost;
    }

}