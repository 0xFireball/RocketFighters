package sprites.weapons;

import flixel.*;
import flixel.math.*;
import flixel.util.*;
import flixel.group.FlxGroup;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.fighters.*;
import sprites.projectiles.*;

class Weapon extends FlxSprite {

    private var carrier:Fighter;
    private var fireTimer:Float = 0;
    private var reloadTime:Float;
    private var effectEmitter:NFParticleEmitter;
    private var projectilesGroup:FlxTypedGroup<Projectile>;

    private var spread:Float = 0.0; // spread in degrees

    public function new(Carrier:Fighter, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super();

        carrier = Carrier;
        reloadTime = ReloadTime;
        effectEmitter = EffectEmitter;
        projectilesGroup = ProjectilesGroup;

        // makeGraphic(40, 15, FlxColor.RED);
        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
    }

    public override function update(dt:Float) {
        fireTimer += dt;
        super.update(dt);
    }

    private function canFire():Bool {
        if (fireTimer < reloadTime) return false;
        fireTimer = 0;
        return true;
    }

    public function fireFree(target:FlxPoint):Projectile {
        // override this
        return null;
    }

    public function launchProjectile(Projectile:Projectile, Vx:Float, Vy:Float) {
        projectilesGroup.add(Projectile);
        Projectile.velocity.set(Vx, Vy);
		var recoil = Projectile.momentum.scale(1 / carrier.mass).negate();
		carrier.velocity.addPoint(recoil);
    }

    public override function destroy() {
        // get rid of references
        carrier = null;
        projectilesGroup = null;
        effectEmitter = null;
        super.destroy();
    }

}