package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

import nf4.*;

class PlayerFighter extends Fighter {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
    }

    private override function movement() {
        var upKey:Bool = false;
        var leftKey:Bool = false;
        var downKey:Bool = false;
        var rightKey:Bool = false;
        var analogMoveVector:FlxVector = null;
        var analogMovement:Bool = false;

        #if !FLX_NO_KEYBOARD
        upKey = FlxG.keys.anyPressed([W, UP]);
        leftKey = FlxG.keys.anyPressed([A, LEFT]);
        downKey = FlxG.keys.anyPressed([S, DOWN]);
        rightKey = FlxG.keys.anyPressed([D, RIGHT]);
        analogMovement = false;
        #end

        #if !FLX_NO_GAMEPAD
		if (FlxG.gamepads.lastActive != null) {
            var analog_mvt_threshold:Float = 0.3;
			var lr_mvt = FlxG.gamepads.lastActive.getXAxis(LEFT_ANALOG_STICK);
            var ud_mvt = FlxG.gamepads.lastActive.getYAxis(LEFT_ANALOG_STICK);
            analogMovement = true;
            // still set keys for code sharing
            if (lr_mvt < -analog_mvt_threshold) leftKey = true;
            if (lr_mvt > analog_mvt_threshold) rightKey = true;
            if (ud_mvt < -analog_mvt_threshold) downKey = true;
            if (ud_mvt > analog_mvt_threshold) upKey = true;

            analogMoveVector = FlxVector.get(lr_mvt, ud_mvt).normalize();
        }
        #end

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

        if (upKey || downKey || leftKey || rightKey) { // make sure there is some input
            var movementVec = FlxPoint.get(movementSpeed, 0);
            var velocityChange:FlxPoint = null;
            if (!analogMovement) {
                var movementAngle:Float = 0;
                if (upKey) {
                    movementAngle = -90;
                    if (leftKey) {
                        movementAngle -= 45;
                    } else if (rightKey) {
                        movementAngle += 45;
                    }
                } else if (downKey) {
                    movementAngle = 90;
                    if (leftKey) {
                        movementAngle += 45;
                    } else if (rightKey) {
                        movementAngle -= 45;
                    }
                } else if (leftKey) {
                    movementAngle = 180;
                } else if (rightKey) {
                    movementAngle = 0;
                }
                // now move
                velocityChange = movementVec.rotate(FlxPoint.weak(0, 0), movementAngle);                
            } else if (analogMovement) {
                velocityChange = FlxPoint.get(analogMoveVector.x, analogMoveVector.y);
                analogMoveVector.put();
            }
            velocity.addPoint(velocityChange);
            movementVec.put();
            velocityChange.put();
        }

        // attack
        actioning = FlxG.keys.anyPressed([F]) && canAct;
    }

}