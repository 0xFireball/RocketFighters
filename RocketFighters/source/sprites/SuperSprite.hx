package sprites;

import flixel.*;
import flixel.group.FlxGroup;

import nf4.*;

class SuperSprite extends NFSprite {

    public var subSprites:FlxGroup;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        subSprites = new FlxGroup();
    }

    override public function update(dt:Float) {
		subSprites.update(dt);

		// nuke dead subsprites
		subSprites.forEachDead(function (d) {
			subSprites.remove(d, true);
			d.destroy();
		});

		super.update(dt);
    }

    override public function draw():Void {
		super.draw();

		subSprites.draw();
	}

    override public function kill() {
		super.kill();
		subSprites.kill();
	}

    override public function destroy() {
		subSprites.destroy();
		subSprites = null;

        super.destroy();
    }

}