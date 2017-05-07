package states;

import flixel.*;

import ui.*;
import ui.menu.*;

class LevelSelectState extends FlxState {

    public var menuItems:MenuItemGroup;
    private var menuWidth:Float = 300;

    public override function create() {
        
        menuItems = new MenuItemGroup();
        menuItems.updatePosition(FlxG.width / 2, 100);
        add(menuItems);

        var testItem1 = new MenuItem(
            new SBNFText("Test Item 1", 30),
            menuWidth
        );

        var testItem2 = new MenuItem(
            new SBNFText("Test Item 2", 30),
            menuWidth
        );

        var disabled = new MenuItem(
            new SBNFText("Disabled", 30),
            menuWidth
        );
        disabled.enabled = false;

        menuItems.addItem(disabled);
        menuItems.addItem(testItem1);
        menuItems.addItem(testItem2);

        super.create();
    }

}