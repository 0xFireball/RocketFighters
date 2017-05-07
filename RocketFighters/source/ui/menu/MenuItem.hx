package ui.menu;

import flixel.*;
import flixel.tweens.*;
import flixel.util.*;
import flixel.group.FlxGroup;

import nf4.ui.*;

class MenuItem extends FlxGroup {

    private var text:NFText;
    private var backing:FlxSprite;
    private var outline:FlxSprite;

    private var marginFactor:Float = 0.2;
    private var outlineSize:Int = 2;

    public var enabled(default, null):Bool = true;
    public var width(default, null):Float;
    public var height(default, null):Float;

    private var selected:Bool = false;
    private var activeTween:FlxTween;

    private var callback:Void->Void;

    public function new(Text:NFText, Width:Float, ?SelectCallback:Void->Void) {
        super();

        text = Text;
        callback = SelectCallback;

        width = Width;
        height = text.height * (1 + marginFactor * 2);

        // create outline
        outline = new FlxSprite();
        outline.makeGraphic(Std.int(width + 2 * outlineSize), Std.int(height + 2 * outlineSize), FlxColor.WHITE);
        outline.alpha = 0;
        add(outline);

        // create backing
        backing = new FlxSprite();
        backing.makeGraphic(Std.int(width), Std.int(height), FlxColor.WHITE);
        add(backing);

        add(text);

        enable();
    }

    public function updateTheme(ForegroundColor:FlxColor, BackgroundColor:FlxColor) {
        text.color = ForegroundColor;
        backing.color = BackgroundColor;
    }

    public function updatePosition(CenterX:Float, Y:Float) {
        backing.x = (CenterX) - (backing.width / 2);
        text.x = (CenterX) - (text.width / 2);

        backing.y = Y;
        text.y = backing.y + marginFactor * text.height;

        outline.y = backing.y - outlineSize;
        outline.x = backing.x - outlineSize;
    }

    public function select() {
        if (selected) return;
        selected = true;
        onSelect();
    }

    public function deselect() {
        if (!selected) return;
        selected = false;
        onDeselect();
    }

    public function disable() {
        enabled = false;
        text.alpha = 0.5;
        backing.alpha = 0.7;
        outline.alpha = 0;
    }

    public function enable() {
        enabled = true;
        backing.alpha = 1.0;
        text.alpha = 1.0;
        outline.alpha = 0;
    }

    private function onSelect() {
        backing.alpha = 0.8;
        text.alpha = 1.0;
        outline.alpha = 0.6;
    }

    private function onDeselect() {
        backing.alpha = 1.0;
        text.alpha = 1.0;
        outline.alpha = 0;
    }

    public function activate() {
        select();
        backing.alpha = 0.6;
        outline.alpha = 0.8;
        if (callback != null) callback();
    }

    public override function destroy() {
        text = null;
        backing = null;

        super.destroy();
    }

    private function alphaTween(Spr:FlxSprite, Val:Float) {
        FlxTween.tween(Spr, { alpha: Val }, 0.2, { ease: FlxEase.cubeIn });
    }

    private function isHovering():Bool {
        var hover:Bool = false;
        #if !FLX_NO_MOUSE
        hover = FlxG.mouse.x > backing.x && FlxG.mouse.x < backing.x + backing.width
            && FlxG.mouse.y > backing.y && FlxG.mouse.y < backing.y + backing.height;
        #end
        return hover;
    }

    private function isPressing():Bool {
        var hover = isHovering();
        var press:Bool = false;

        #if !FLX_NO_MOUSE
        press = hover && FlxG.mouse.justPressed;
        #end

        #if !FLX_NO_TOUCH
        var touch = FlxG.touches.getFirst();
        if (touch != null) {
            press = press || touch.x > backing.x && touch.x < backing.x + backing.width
            && touch.y > backing.y && touch.y < backing.y + backing.height;
        }
        #end

        return press;
    }

    public override function update(dt:Float) {
        if (isHovering()) {
            if (isPressing()) {
                activate();
            } else {
                select();
            }
        } else {
            deselect();
        }

        super.update(dt);
    }

}