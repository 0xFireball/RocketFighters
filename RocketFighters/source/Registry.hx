package;

import flixel.util.*;

class Registry {
    // constants

    public static var gameVersion:String = "v0.0.1 Alpha";

    // vars

    public static var gameLevel:Int = 0;

    private static var defaultSaveName:String = "angrywizard_0";

    public static var saveSlot:FlxSave;

    public static function loadSave() {
        saveSlot = new FlxSave();
        saveSlot.bind(defaultSaveName);
        reloadSave();
    }

    public static function reloadSave() {
        gameLevel = saveSlot.data.level;
        #if (!cpp)
        if (gameLevel == null) {
            gameLevel = 0;
        }
        #end
    }

    // color constants
    public static var backgroundColor:FlxColor = FlxColor.fromInt(0xFFA3A256);

    public static var dimBackgroundColor:FlxColor = FlxColor.fromInt(0xFF51512E);

    public static var foregroundColor:FlxColor = FlxColor.fromInt(0xFFE8E676);

    public static var foregroundAccentColor:FlxColor = FlxColor.fromInt(0xFFFFFEB0);

    public static var washoutColor:FlxColor = FlxColor.fromInt(0xFFFFFEDE);

    public static var unfocusColor:FlxColor = FlxColor.fromRGBFloat(0.7, 0.7, 0.7, 0.8);
    
}