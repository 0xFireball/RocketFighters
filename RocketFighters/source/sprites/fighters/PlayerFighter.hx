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

        // attack
        var primaryAction:Bool = false;

        #if !FLX_NO_KEYBOARD
        upKey = FlxG.keys.anyPressed([W, UP, Z]);
        leftKey = FlxG.keys.anyPressed([A, LEFT]);
        downKey = FlxG.keys.anyPressed([S, DOWN]);
        rightKey = FlxG.keys.anyPressed([D, RIGHT]);
        primaryAction = FlxG.keys.anyPressed([F]);
        #end

        #if !FLX_NO_GAMEPAD
        var gamepad = FlxG.gamepads.lastActive;
        var stickDeadzone = 0.2;
        if (gamepad != null) {
            var leftStick = FlxVector.get(gamepad.getXAxis(LEFT_ANALOG_STICK), gamepad.getYAxis(LEFT_ANALOG_STICK));
            // var rightStick = FlxVector.get(gamepad.getXAxis(LEFT_ANALOG_STICK), gamepad.getYAxis(LEFT_ANALOG_STICK));
            if (leftStick.length < stickDeadzone) { // enforce a small radial deadzone
                leftStick.set(0, 0);
            }
            if (leftStick.x < 0) leftKey = true;
            if (leftStick.x > 0) rightKey = true;
            upKey = gamepad.anyPressed([ A ]);
            downKey = gamepad.anyPressed([ X ]);
            primaryAction = gamepad.anyPressed([ B, RIGHT_TRIGGER_BUTTON, RIGHT_SHOULDER ]);

            leftStick.put();
        }
        #end

        this.moveDefault(upKey, leftKey, downKey, rightKey, primaryAction);
    }

    private override function primaryFire(?FireTarget:FlxPoint = null) {
        var fireTarget = FlxG.mouse.getPosition();
        super.primaryFire(fireTarget);
    }

}