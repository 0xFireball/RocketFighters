package states;

import flixel.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.effects.particles.*;
import flixel.addons.effects.chainable.*;

import nf4.ui.*;
import nf4.effects.particles.*;
import nf4.util.*;

import ui.*;
import ui.menu.*;

class SettingsState extends FlxState
{
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		FlxG.mouse.load(AssetPaths.mouse__png);
		#end

		bgColor = Registry.backgroundColor;

		var titleTx = new SBNFText(0, 80, "Settings", 84);
		titleTx.color = FlxColor.WHITE;
		titleTx.screenCenter(FlxAxes.X);
		add(titleTx);

		var menuItems = new MenuItemGroup();
		var menuWidth = 240;
        menuItems.updatePosition(FlxG.width / 2, 340);
        add(menuItems);

        var saveDataBtn = new MenuItem(
            new SBNFText("Save Game", 30),
            menuWidth,
            onSaveData
        );

        var resetGameBtn = new MenuItem(
            new SBNFText("Reset Game", 30),
            menuWidth,
            onResetSave
        );

		var returnBtn = new MenuItem(
            new SBNFText("Return", 30),
            menuWidth,
            onReturn
        );

        menuItems.addItem(saveDataBtn);
        menuItems.addItem(resetGameBtn);
        menuItems.addItem(returnBtn);

		FlxG.camera.fade(bgColor, 0.4, true);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed([ ESCAPE ])) {
            // dismiss menu
			onReturn();
		}
		#end

		super.update(elapsed);
	}

	private function onReturn() {
		// switch
		FlxG.camera.fade(Registry.washoutColor, 0.4, false, function () {
			FlxG.switchState(new MenuState());
		});
	}

	private function onResetSave() {
		Registry.gameLevel = 0;
		onSaveData();
	}

	private function onSaveData() {
		Registry.saveSlot.data.level = Registry.gameLevel;
		Registry.saveSlot.flush();
	}
}
