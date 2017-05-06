package sprites.things;

import flixel.*;

import sprites.fighters.*;

class MapThing extends FlxSprite {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
    }

    public function hitFighter(Fighter:Fighter) {
        // override, by default just separate
        FlxG.collide(this, Fighter);
    }

}