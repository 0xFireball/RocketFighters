package ui.menu;

import flixel.*;
import flixel.util.*;
import flixel.group.FlxGroup;

class MenuItemGroup extends FlxTypedGroup<MenuItem> {

    private var foregroundColor:FlxColor = FlxColor.fromInt(0xAAEEEEEE);
    private var backgroundColor:FlxColor = FlxColor.fromInt(0xAA222222);

    private var centerX:Float;
    private var startY:Float;

    public var itemMargin:Float = 10;

    private var items:Array<MenuItem> = new Array<MenuItem>();
    private var currentOffset:Float = 0;
    
    private var selectedIndex:Int = -1;
    private var defocus:Bool = true;

    public function new() {
        super();
    }

    public function updateTheme(ForegroundColor:FlxColor, BackgroundColor:FlxColor) {
        foregroundColor = ForegroundColor;
        backgroundColor = BackgroundColor;
    }

    public function updatePosition(CenterX:Float, StartY:Float) {
        centerX = CenterX;
        startY = StartY;
    }

    public function addItem(Item:MenuItem) {
        Item.updateTheme(foregroundColor, backgroundColor);
        Item.updatePosition(centerX, startY + currentOffset);
        currentOffset += Item.height + itemMargin;
        items.push(Item);
        add(Item);
    }

    public override function destroy() {
        items.splice(0, items.length);
        items = null;

        super.destroy();
    }

    public override function update(dt:Float) {
        super.update(dt);
        
        if (items.length == 0) return;

        var lastDir:Int = 0;

        var up:Bool = false;
        var down:Bool = false;
        var dfc:Bool = false;
        var sel:Bool = false;
        
        #if !FLX_NO_KEYBOARD
        dfc = FlxG.keys.anyJustPressed([ ESCAPE ]);
        down = FlxG.keys.anyJustPressed([DOWN, S]);
        up = FlxG.keys.anyJustPressed([UP, W]);
        sel = FlxG.keys.anyJustPressed([ ENTER, E ]);
        #end

        #if !FLX_NO_GAMEPAD
        var gamepad = FlxG.gamepads.lastActive;
        if (gamepad != null) {
            dfc = gamepad.anyJustPressed([ LEFT_TRIGGER_BUTTON, B ]);
            up = gamepad.anyJustPressed([ DPAD_UP ]);
            down = gamepad.anyJustPressed([ DPAD_DOWN ]);
            sel = gamepad.anyJustPressed([ DPAD_RIGHT, A, START ]);
        }
        #end

        if (!defocus && dfc) {
            defocus = true;
        }
        if (down) {
            defocus = false;
            selectedIndex++;
            lastDir = 1;
        }
        if (up) {
            defocus = false;
            selectedIndex--;
            lastDir = -1;
        }
        if (!defocus && sel) {
            // click
            items[selectedIndex].activate();
        }

        // fix selectedindex
        fixIndex();
        if (!items[selectedIndex].enabled) {
            // skip if disabled
            selectedIndex += lastDir;
            fixIndex();
        }

        highlightMenus();
    }

    private function fixIndex() {
        if (selectedIndex < 0) {
            selectedIndex += items.length;
        } else if (selectedIndex >= items.length) {
            selectedIndex %= items.length;
        }
    }

    private function highlightMenus() {
        for (itemId in 0...items.length) {
            if (!defocus && itemId == selectedIndex) {
                items[itemId].select();
            } else {
                items[itemId].deselect();
            }
        }
    }

}