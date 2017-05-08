package states;

import flixel.*;
import flixel.util.*;

import ui.*;
import ui.menu.*;
import nf4.ui.menu.*;

import states.game.*;

typedef LevelInfo = {
    name: String,
    file: String
}

class LevelSelectState extends SBNFMenuState {

    private var selectEnabled:Bool = true;

    public override function create() {

        bgColor = Registry.dimBackgroundColor;

        var titleTx = new SBNFText(0, 100, "Select Stage", 40);
        titleTx.screenCenter(FlxAxes.X);
        add(titleTx);

        menuGroup.updatePosition(FlxG.width / 2, 180);
        menuGroup.itemMargin = 6;
        menuWidth = 240;
        menuItemTextSize = 30;

        var levels:Array<LevelInfo> = [
            { name: "LBP Arena", file: "lbp_stage" }
        ];

        // bind and create levels
        for (level in levels) {
            menuItems.push({
                text: level.name,
                callback: function() {
                    onStageSelected(level.file);
                }
            });
        }

        menuItems.push({
            text: "Coming Soon",
            disabled: true
        });

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