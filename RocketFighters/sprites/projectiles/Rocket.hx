package sprites.projectiles;

import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.effects.particles.*;

import nf4.NFSprite;
import nf4.util.*;
import nf4.effects.particles.*;

using nf4.math.NFMathExt;

class Rocket extends Projectile {
	public function new(?Owner:NFSprite, ?X:Float = 0, ?Y:Float = 0, Life:Float = 30.0, Target:NFSprite) {
		super(Owner, X, Y, Life, Target);
		damageFactor = 1.5;
		mass = 40;
		movementSpeed = 220 + Math.random() * 40;
        thrust = 400;
		makeGraphic(8, 3, FlxColor.fromRGBFloat(0.13, 0.13, 0.13));

		emitter.maxSize = 15;
		emitter.scale.set(4, 4, 12, 12);
		emitter.lifespan.set(0.7);
		emitter.color.set(FlxColor.fromRGBFloat(0.4, 0.0, 0.0), FlxColor.fromRGBFloat(0.6, 0.2, 0.2));
		emitter.makeParticles(1, 1, FlxColor.WHITE, 15);
	}

	override public function update(dt:Float) {
		super.update(dt);
	}

	override public function explode() {
        var explosionFragTime:Float = 0.6;
        var explosionMv:Float = 12;
		for (i in 0...32) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
				NFParticleEmitter.velocitySpread(movementSpeed / 4, -velocity.x / explosionMv, -velocity.y / explosionMv),
			NFColorUtil.randCol(0.8, 0.2, 0.2, 0.2), explosionFragTime);
		}
		for (i in 0...24) {
			explosionEmitter.emitSquare(center.x, center.y, Std.int(Math.random() * 8 + 4),
				NFParticleEmitter.velocitySpread(movementSpeed / 4, -velocity.x / explosionMv, -velocity.y / explosionMv),
			NFColorUtil.randCol(0.8, 0.8, 0.2, 0.2), explosionFragTime);
		}
		super.explode();
	}
}
