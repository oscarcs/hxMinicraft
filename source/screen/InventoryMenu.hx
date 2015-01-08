package screen;

import flixel.FlxG;
import entity.Player;
import gfx.Font;
import gfx.Screen;
import item.Item;

class InventoryMenu extends Menu
{
	private var player:Player;
	private var selected:Int = 0;

	public function new(player:Player) 
	{
		this.player = player;
		
		if (player.activeItem != null)
		{
			player.inventory.items.push(player.activeItem);
			player.activeItem = null;
		}
	}
	
	override public function tick():Void
	{
		if (FlxG.keys.anyJustPressed(G.menuKeys))
		{
			game.setMenu(null);
		}
		
		if (FlxG.keys.anyJustPressed(G.upKeys))
		{
			selected --;
		}
		
		if (FlxG.keys.anyJustPressed(G.downKeys))
		{
			selected ++;
		}
		
		var len:Int = player.inventory.items.length;
		if (len == 0) selected = 0;
		if (selected < 0) selected += len;
		if (selected >= len) selected -= len;
		
		if (FlxG.keys.anyJustPressed(G.attackKeys) && len > 0)
		{
			var cur:Item = player.inventory.items[selected];
			player.inventory.items.remove(cur);
			var item:Item = cur;
			player.activeItem = item;
			game.setMenu(null);
		}
	}
	
	override public function render(screen:Screen):Void
	{
		Font.renderFrame(screen, "inventory", 1, 1, 12, 11);
		renderItemList(screen, 1, 1, 12, 11, cast player.inventory.items, selected);
	}
	
}