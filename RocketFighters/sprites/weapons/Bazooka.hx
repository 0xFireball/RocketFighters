package sprites.weapons;

import flixel.*;
import flixel.math.*;
import flixel.util.*;
import flixel.group.FlxGroup;

import nf4.effects.particles.*;
import nf4.util.*;

import sprites.fighters.*;
import sprites.projectiles.*;

using nf4.math.NFMathExt;

class Bazooka extends Weapon {

    public function new(Carrier:Fighter, ReloadTime:Float, EffectEmitter:NFParticleEmitter, ProjectilesGroup:FlxTypedGroup<Projectile>) {
        super(Carrier, ReloadTime, EffectEmitter, ProjectilesGroup);

        spread = 8; // degrees

        loadGraphic(AssetPaths.rf_bazooka__png, true, 64, 64);
    }

    public override function update(dt:Float) {
        super.update(dt);
    }

    public override function fireFree(target:FlxPoint):Projectile {
        if (!canFire()) return null;
        var projectile = new Rocket(carrier, carrier.center.x, carrier.center.y,  5.0, null);
		var projectileSpread:Float = 10;
		var fireVelocity = projectile.center.toVector()
			.subtractPoint(target)
			.rotate(FlxPoint.weak(0, 0), (180 - (spread / 2)) + (Math.random() * spread));
        fireVelocity.y /= 12; // greatly shrink Y component
        fireVelocity = fireVelocity
            .toVector().normalize()
            .scale(projectile.movementSpeed);
		launchProjectile(projectile, fireVelocity.x, fireVelocity.y);
		fireVelocity.put();
		// apply recoil
		carrier.velocity.addPoint(projectile.momentum.scale(1 / carrier.mass).negate());
        // smoke
		for (i in 0...14) {
			effectEmitter.emitSquare(carrier.center.x, carrier.center.y, 6,
				NFParticleEmitter.velocitySpread(45, fireVelocity.x / 4, fireVelocity.y / 4),
				NFColorUtil.randCol(0.5, 0.5, 0.5, 0.1), 0.8);
		}
        return projectile;
    }

}