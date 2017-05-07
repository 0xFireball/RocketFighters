package states;

import flixel.*;
import flixel.util.*;

import ui.*;
import ui.menu.*;

import states.game.*;

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

        var lbpArenaMi = new MenuItem(
            new SBNFText("LBP Arena", 30),
            menuWidth,
            function() {
                onStageSelected("lbp_stage");
            }
        );

        var comingSoon1 = new MenuItem(
            new SBNFText("Coming Soon", 30),
            menuWidth
        );
        comingSoon1.enabled = false;

        menuItems.addItem(lbpArenaMi);
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