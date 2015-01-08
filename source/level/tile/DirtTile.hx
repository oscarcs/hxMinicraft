package level.tile;

import entity.ItemEntity;
import entity.Player;
import gfx.Color;
import gfx.Screen;
import item.Item;
import item.ResourceItem;
import item.ToolItem;
import item.ToolType;
import item.resource.Resource;
import item.resource.StaticResource;
import level.Level;
//import sound.Sound;

class DirtTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(level.dirtColor, level.dirtColor, level.dirtColor - 111, level.dirtColor - 111);
		screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0);
		screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0);
		screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0);
		screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0);
	}

	override public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int):Bool
	{
		if (Std.is(item, ToolItem))
		{
			//TODO: cast?
			var tool:ToolItem = cast item;
			if (tool.type == ToolType.shovel)
			{
				if (player.payStamina(4 - tool.level))
				{
					level.setTile(xt, yt, StaticTile.hole, 0);
					level.add(new ItemEntity(new ResourceItem(StaticResource.dirt), xt * 16 + random.nextInt(10) + 3, yt * 16 + random.nextInt(10) + 3));
					//Sound.monsterHurt.play();
					return true;
				}
			}
			if (tool.type == ToolType.hoe)
			{
				if (player.payStamina(4 - tool.level))
				{
					level.setTile(xt, yt, StaticTile.farmland, 0);
					//Sound.monsterHurt.play();
					return true;
				}
			}
		}
		return false;
	}
}
