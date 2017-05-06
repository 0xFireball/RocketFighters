package sprites.fighters;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.effects.particles.*;

import sprites.*;
import sprites.weapons.*;

import states.game.data.*;

class Fighter extends GamePresence {

    public var movementSpeed:Float = 16;
    public var airResistanceMultiplier:Float = 0.75;
    public var jumpVelocity:Float = 180;

    public var jumpThrusting:Bool = false;

    private var effectEmitter:NFParticleEmitter;

    private var weapon:Weapon = null;

    private var stateData:PlayStateData;

    public function new(?X:Float = 0, ?Y:Float = 0, StateData:PlayStateData) {
        super(X, Y);

        stateData = StateData;

        maxVelocity.x = movementSpeed * 15;
        drag.x = 420;

        mass = 100; // 100 kg

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

        effectEmitter = new NFParticleEmitter(40);
        subSprites.add(effectEmitter);

        addWeapons();
    }

    private function addWeapons() {
        // add bazooka
        weapon = new Bazooka(this, 0.8, effectEmitter, stateData.projectiles);
        subSprites.add(weapon);
    }

    public override function update(dt:Float) {
        movement();
        animate();

        updateItemPositions();

        super.update(dt);
    }

    private function updateItemPositions() {
        // update positions of items
        if (weapon != null) {
            weapon.x = x - weapon.width / 2.5;
            weapon.y = y + height / 2 - weapon.height / 2.6;
            if (facing & FlxObject.LEFT > 0 || facing & FlxObject.RIGHT > 0) {
                weapon.facing = facing;
            }
        }
    }
    
    private function movement() {
        // todo
    }

    private function moveDefault(upKey:Bool, leftKey:Bool, downKey:Bool, rightKey:Bool, primaryAction:Bool) {
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
        if (primaryAction) {
            primaryFire();
        }
    }

    private function primaryFire(?FireTarget:FlxPoint = null) {
        // override this?
        if (FireTarget != null) {
            // update sprite state to reflect target
            if (FireTarget.x < x) {
                facing = FlxObject.LEFT;
            } else if (FireTarget.x > x) {
                facing = FlxObject.RIGHT;
            }
            weapon.fireFree(FireTarget);
        }
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