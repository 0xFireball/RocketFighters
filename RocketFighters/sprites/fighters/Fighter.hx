package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

import sprites.*;

class Fighter extends GamePresence {

    public var movementSpeed:Float = 6;
    public var airResistanceMultiplier:Float = 0.7;
    public var jumpVelocity:Float = 294;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        makeGraphic(14, 26, FlxColor.BLUE);
    }

    public override function update(dt:Float) {
        movement();

        super.update(dt);
    }
    
    private function movement() {
        // todo
    }

    private function moveDefault(upKey:Bool, leftKey:Bool, downKey:Bool, rightKey:Bool) {
        if (upKey && downKey) upKey = downKey = false;
        if (leftKey && rightKey) leftKey = rightKey = false;

        if (leftKey) {
            facing = FlxObject.LEFT;
        } else if (rightKey) {
            facing = FlxObject.RIGHT;
        } else if (downKey) {
            facing = FlxObject.DOWN;
        } else if (upKey) {
            facing = FlxObject.UP;
        }

        var tMoveSpeed = movementSpeed;
        var touchingGround:Bool = this.isTouching(FlxObject.DOWN);
        if (upKey || downKey || leftKey || rightKey) { // make sure there is some input
            if (!touchingGround) tMoveSpeed *= airResistanceMultiplier;
            if (leftKey) {
                velocity.x -= tMoveSpeed;
            } else if (rightKey) {
                velocity.x += tMoveSpeed;
            }
            // jump
            if (upKey && touchingGround) {
                velocity.y -= jumpVelocity;
            }
            // now move
        }

        // attack
        // actioning = FlxG.keys.anyPressed([F]) && canAct;
    }

}