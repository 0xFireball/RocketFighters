package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

import sprites.*;

class Fighter extends GamePresence {

    public var movementSpeed:Float = 16;
    public var airResistanceMultiplier:Float = 0.87;
    public var jumpVelocity:Float = 220;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        maxVelocity.x = movementSpeed * 15;
        drag.x = 420;

        // makeGraphic(14, 26, FlxColor.BLUE);
        loadGraphic(AssetPaths.rocketfighters_bob__png, true, 64, 64);
        // offset.set(13, 7);
        // setSize(7, 21);
        offset.set(26, 14);
        setSize(14, 42);
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