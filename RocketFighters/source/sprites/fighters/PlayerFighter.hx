package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;

import nf4.*;
import nf4.input.*;

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
        var nfGamepad = NFGamepad.get(gamepad);
        var stickDeadzone = 0.2;
        if (gamepad != null) {
            var leftStick = nfGamepad.getAxes(LEFT_ANALOG_STICK, stickDeadzone);
            // var rightStick = FlxVector.get(gamepad.getXAxis(LEFT_ANALOG_STICK), gamepad.getYAxis(LEFT_ANALOG_STICK));
            if (leftStick.length < stickDeadzone) { // enforce a small radial deadzone
                leftStick.set(0, 0);
            }
            if (leftStick.x < 0) leftKey = true;
            if (leftStick.x > 0) rightKey = true;
            upKey = upKey || gamepad.anyPressed([ A ]);
            downKey = downKey || gamepad.anyPressed([ X ]);
            primaryAction = primaryAction || gamepad.anyPressed([ B, RIGHT_TRIGGER_BUTTON, RIGHT_SHOULDER ]);

            leftStick.put();
        }
        nfGamepad = null;
        #end

        this.moveDefault(upKey, leftKey, downKey, rightKey, primaryAction);
    }

    private override function primaryFire(?FireTarget:FlxPoint = null) {
        #if !FLX_NO_KEYBOARD
        FireTarget = FlxG.mouse.getPosition();
        #end
        #if !FLX_NO_GAMEPAD
        var gamepad = NFGamepad.get(FlxG.gamepads.lastActive);
        var targetRadius:Float = 60; // pseudo-mouse position
        if (gamepad != null) {
            var rightStick = gamepad.getAxes(RIGHT_ANALOG_STICK);
            if (FireTarget.x <= 0 && FireTarget.y <= 0) {
                FireTarget.x = 1;
            }
            FireTarget = center.addPoint(rightStick.scale(targetRadius));
            rightStick.put();
        }
        gamepad = null;
        #end
        super.primaryFire(FireTarget);
    }

}