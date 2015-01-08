package level.tile;

import entity.Entity;
import entity.Player;
import gfx.Color;
import gfx.Screen;
import item.Item;
import item.ToolItem;
import item.ToolType;
import level.Level;

class FarmTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(level.dirtColor - 121, level.dirtColor - 11, level.dirtColor, level.dirtColor + 111);
		screen.render(x * 16 + 0, y * 16 + 0, 2 + 32, col, 1);
		screen.render(x * 16 + 8, y * 16 + 0, 2 + 32, col, 0);
		screen.render(x * 16 + 0, y * 16 + 8, 2 + 32, col, 0);
		screen.render(x * 16 + 8, y * 16 + 8, 2 + 32, col, 1);
	}

	override public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int):Bool
	{
		if (Std.is(item, ToolItem))
		{
			var tool:ToolItem = cast item;
			if (tool.type == ToolType.shovel)
			{
				if (player.payStamina(4 - tool.level))
				{
					level.setTile(xt, yt, StaticTile.dirt, 0);
					return true;
				}
			}
		}
		return false;
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		var age:Int = level.getData(xt, yt);
		if (age < 5) level.setData(xt, yt, age + 1);
	}

	override public function steppedOn(level:Level, xt:Int, yt:Int, entity:Entity):Void
	{
		if (random.nextInt(60) != 0) return;
		if (level.getData(xt, yt) < 5) return;
		level.setTile(xt, yt, StaticTile.dirt, 0);
	}
}
