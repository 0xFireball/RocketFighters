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

    public var enabled:Bool = true;
    public var width(default, null):Float;
    public var height(default, null):Float;

    private var focus:Bool = false;
    public var forceFocus:Bool = false;

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

    public override function destroy() {
        text = null;
        backing = null;

        super.destroy();
    }

    public function menu_focus() {
        backing.alpha = 0.8;
        text.alpha = 1.0;
        outline.alpha = 0.6;
    }

    public function menu_click() {
        menu_focus();
        backing.alpha = 0.6;
        outline.alpha = 0.8;
        if (callback != null) {
            callback();
        }
    }

    private function alphaTween(Spr:FlxSprite, Val:Float) {
        FlxTween.tween(Spr, { alpha: Val }, 0.2, { ease: FlxEase.cubeIn });
    }

    public override function update(dt:Float) {
        var hover = FlxG.mouse.x > backing.x && FlxG.mouse.x < backing.x + backing.width
            && FlxG.mouse.y > backing.y && FlxG.mouse.y < backing.y + backing.height;
        var click = hover && FlxG.mouse.pressed;
        
        focus = hover || forceFocus;

        backing.alpha = 1.0;
        text.alpha = 1.0;

        if (!focus) {
            text.alpha = 0.8;
        }

        if (enabled) {
            if (click) {
            menu_click();
            } else if (focus) {
                menu_focus();
            } else {
                outline.alpha = 0;
            }
        } else {
            text.alpha = 0.5;
            backing.alpha = 0.7;
        }

        super.update(dt);
    }

}