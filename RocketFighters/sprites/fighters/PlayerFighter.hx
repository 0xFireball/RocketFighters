package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

import nf4.*;

import states.game.data.*;

class PlayerFighter extends Fighter {

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:PlayStateData) {
        super(X, Y, StateData);
    }

    private override function movement() {
        var upKey:Bool = false;
        var leftKey:Bool = false;
        var downKey:Bool = false;
        var rightKey:Bool = false;

        #if !FLX_NO_KEYBOARD
        upKey = FlxG.keys.anyPressed([W, UP]);
        leftKey = FlxG.keys.anyPressed([A, LEFT]);
        downKey = FlxG.keys.anyPressed([S, DOWN]);
        rightKey = FlxG.keys.anyPressed([D, RIGHT]);
        #end

        this.moveDefault(upKey, leftKey, downKey, rightKey);
    }

}