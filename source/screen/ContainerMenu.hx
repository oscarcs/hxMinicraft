package screen;

import flixel.FlxG;

import entity.Inventory;
import entity.Player;
import gfx.Font;
import gfx.Screen;

class ContainerMenu extends Menu
{
	private var player:Player;
	private var container:Inventory;
	private var selected:Int = 0;
	private var title:String;
	private var oSelected:Int;
	private var window:Int = 0;

	override public function new(player:Player, title:String, container:Inventory)
	{
		this.player = player;
		this.title = title;
		this.container = container;
	}

	override public function tick():Void
	{
		if (FlxG.keys.anyJustPressed(G.menuKeys)) game.setMenu(null);

		if (FlxG.keys.anyJustPressed(G.leftKeys))
		{
			window = 0;
			var tmp:Int = selected;
			selected = oSelected;
			oSelected = tmp;
		}
		if (FlxG.keys.anyJustPressed(G.rightKeys))
		{
			window = 1;
			var tmp:Int = selected;
			selected = oSelected;
			oSelected = tmp;
		}

		var i:Inventory = window == 1 ? player.inventory : container;
		var i2:Inventory = window == 0 ? player.inventory : container;

		var len:Int = i.items.length;
		if (selected < 0) selected = 0;
		if (selected >= len) selected = len - 1;

		if (FlxG.keys.anyPressed(G.upKeys)) selected--;
		if (FlxG.keys.anyPressed(G.downKeys)) selected++;

		if (len == 0) selected = 0;
		if (selected < 0) selected += len;
		if (selected >= len) selected -= len;

		if (FlxG.keys.anyJustPressed(G.attackKeys) && len > 0)
		{
			i.items.remove(i.items[selected]);
			i2.add2(oSelected, i.items[selected]);
			if (selected >= i.items.length) selected = i.items.length - 1;
		}
	}

	override public function render(screen:Screen):Void
	{
		if (window == 1) screen.setOffset(6 * 8, 0);
		Font.renderFrame(screen, title, 1, 1, 12, 11);
		renderItemList(screen, 1, 1, 12, 11, cast container.items, window == 0 ? selected : -oSelected - 1);

		Font.renderFrame(screen, "inventory", 13, 1, 13 + 11, 11);
		renderItemList(screen, 13, 1, 13 + 11, 11, cast player.inventory.items, window == 1 ? selected : -oSelected - 1);
		screen.setOffset(0, 0);
	}
}