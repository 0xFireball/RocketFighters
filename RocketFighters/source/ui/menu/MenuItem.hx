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
    private var persistentSelect:Bool = false;
    
    private var txTween:FlxTween;
    private var bkTween:FlxTween;
    private var olTween:FlxTween;

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

    public function select(P:Bool = false) {
        if (selected) return;
        selected = true;
        if (P) persistentSelect = true;
        onSelect();
    }

    public function deselect(P:Bool = false) {
        if (!selected) return;
        selected = false;
        if (P) persistentSelect = false;
        onDeselect();
    }

    public function disable() {
        enabled = false;
        if (anyTweens()) cancelTweens();
        text.alpha = 0.5;
        backing.alpha = 0.7;
        outline.alpha = 0;
    }

    public function enable() {
        enabled = true;
        if (anyTweens()) cancelTweens();
        backing.alpha = 1.0;
        text.alpha = 1.0;
        outline.alpha = 0;
    }

    private function onSelect(Now:Bool = false) {
        if (Now) {
            backing.alpha = 0.8;
            text.alpha = 1.0;
            outline.alpha = 0.6;
        } else {
            if (anyTweens()) cancelTweens();
            txTween = alphaTween(text, 1.0);
            bkTween = alphaTween(backing, 0.8);
            olTween = alphaTween(outline, 0.6);
        }
    }

    private function onDeselect(Now:Bool = false) {
        if (Now) {
            backing.alpha = 1.0;
            text.alpha = 1.0;
            outline.alpha = 0;
        } else {
            if (anyTweens()) cancelTweens();
            txTween = alphaTween(text, 1.0);
            bkTween = alphaTween(backing, 1.0);
            olTween = alphaTween(outline, 0);
        }
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

    private function anyTweens() {
        return (txTween != null && !txTween.finished)
            || (bkTween != null && !bkTween.finished)
            || (olTween != null && !olTween.finished);
    }

    private function cancelTweens() {
        if (txTween != null) txTween.cancel();
        if (bkTween != null) bkTween.cancel();
        if (olTween != null) olTween.cancel();
    }

    private function alphaTween(Spr:FlxSprite, Val:Float, Duration:Float = 0.2) {
        return FlxTween.tween(Spr, { alpha: Val }, Duration, { ease: FlxEase.cubeIn });
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
        if (enabled && isHovering() || persistentSelect) {
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