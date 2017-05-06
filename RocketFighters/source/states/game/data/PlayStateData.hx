package states.game.data;

import flixel.*;
import flixel.group.FlxGroup;

import sprites.fighters.*;
import sprites.projectiles.*;

class PlayStateData {

    public var player:PlayerFighter;
    public var fighters:FlxTypedGroup<Fighter>;
    public var projectiles:FlxTypedGroup<Projectile>;

    public function new() { }

    public function destroy() {
        player = null;
        fighters = null;
        projectiles = null;
    }

}