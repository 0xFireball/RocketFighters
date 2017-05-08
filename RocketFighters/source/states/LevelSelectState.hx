package states;

import flixel.*;
import flixel.util.*;

import ui.*;
import nf4.ui.menu.*;

import states.game.*;

typedef LevelInfo = {
    name: String,
    file: String
}

class LevelSelectState extends FlxState {

    public var menuItems:MenuItemGroup;
    private var menuWidth:Float = 300;
    private var selectEnabled:Bool = true;

    public override function create() {

        bgColor = Registry.dimBackgroundColor;
        
        menuItems = new MenuItemGroup();
        menuItems.updatePosition(FlxG.width / 2, 180);
        add(menuItems);

        var titleTx = new SBNFText(0, 100, "Select Stage", 40);
        titleTx.screenCenter(FlxAxes.X);
        add(titleTx);

        var levels:Array<LevelInfo> = [
            { name: "LBP Arena", file: "lbp_stage" }
        ];

        // bind and create levels
        for (level in levels) {
            var lvMi = new MenuItem(
                new SBNFText(level.name, 30),
                menuWidth,
                function() {
                    onStageSelected(level.file);
                }
            );
            menuItems.addItem(lvMi);
        }

        var comingSoon1 = new MenuItem(
            new SBNFText("Coming Soon", 30),
            menuWidth
        );
        comingSoon1.disable();
        
        menuItems.addItem(comingSoon1);

        FlxG.camera.fade(Registry.dimBackgroundColor, 0.4, true);

        super.create();
    }

    private function onStageSelected(StageName:String) {
        if (!selectEnabled) return;
        selectEnabled = false;
        FlxG.camera.fade(Registry.dimBackgroundColor, 0.4, false, function() {
            FlxG.switchState(new PlayState(StageName));
        });
    }

}