package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.effects.particles.*;

import sprites.*;

class Fighter extends GamePresence {

    public var movementSpeed:Float = 16;
    public var airResistanceMultiplier:Float = 0.75;
    public var jumpVelocity:Float = 180;

    public var jumpThrusting:Bool = false;

    private var sprayEmitter:FlxEmitter;
    private var effectEmitter:NFParticleEmitter;

    private var weapon:Weapon;

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

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        animation.add("n", [0]);
        animation.add("f", [1]);
        animation.add("lr", [2, 3, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 2], 24);
        animation.add("jt", [10, 1, 10]);

        // subsprites
        sprayEmitter = new FlxEmitter(X, Y);
		sprayEmitter.scale.set(2, 2, 10, 10);
		sprayEmitter.lifespan.set(0.1, 0.7);
		sprayEmitter.color.set(FlxColor.fromRGBFloat(0.0, 0.4, 0.6, 0.4), FlxColor.fromRGBFloat(0.4, 0.8, 1.0, 0.9));
		sprayEmitter.makeParticles(1, 1, FlxColor.WHITE, 200);
        subSprites.add(sprayEmitter);

        effectEmitter = new NFParticleEmitter(40);
        subSprites.add(effectEmitter);

        // add bazooka

    }

    public override function update(dt:Float) {
        movement();
        animate();

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
        } else {
            facing = FlxObject.DOWN;
        }
        // flags to face down or up
        if (downKey) {
            facing |= FlxObject.DOWN;
        } else if (upKey) {
            facing |= FlxObject.UP;
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
                jumpThrusting = true;
            } else if (jumpThrusting) {
                jumpThrusting = false;
            }
            // now move
        }

        // attack
        // actioning = FlxG.keys.anyPressed([F]) && canAct;
    }

    private function animate() {
        var movingSide = Math.abs(velocity.x) > 0;
        var movingSideFaster = movingSide && Math.abs(velocity.x) >= movementSpeed * airResistanceMultiplier;
        if (isTouching(FlxObject.DOWN) && movingSideFaster) {
            animation.play("lr");
        } else if (movingSide) {
            animation.play("f");
        } else {
            animation.play("n");
        }

        if (jumpThrusting && movingSide) {
            animation.play("jt");
        }
    }


}