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

class GrassTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
		connectsToGrass = true;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(level.grassColor, level.grassColor, level.grassColor + 111, level.grassColor + 111);
		var transitionColor:Int = Color.get(level.grassColor - 111, level.grassColor, level.grassColor + 111, level.dirtColor);

		var u:Bool = !level.getTile(x, y - 1).connectsToGrass;
		var d:Bool = !level.getTile(x, y + 1).connectsToGrass;
		var l:Bool = !level.getTile(x - 1, y).connectsToGrass;
		var r:Bool = !level.getTile(x + 1, y).connectsToGrass;

		if (!u && !l)
		{
			screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0);
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 0, (l ? 11 : 12) + (u ? 0 : 1) * 32, transitionColor, 0);
		}

		if (!u && !r)
		{
			screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0);
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 0, (r ? 13 : 12) + (u ? 0 : 1) * 32, transitionColor, 0);
		}

		if (!d && !l)
		{
			screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0);
		}
		else
		{
			
			screen.render(x * 16 + 0, y * 16 + 8, (l ? 11 : 12) + (d ? 2 : 1) * 32, transitionColor, 0);
		}
		if (!d && !r)
		{
			screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0);
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 8, (r ? 13 : 12) + (d ? 2 : 1) * 32, transitionColor, 0);
		}
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		if (random.nextInt(40) != 0) return;

		var xn:Int = xt;
		var yn:Int = yt;

		if (random.nextBoolean())
		{
			xn += random.nextInt(2) * 2 - 1;
		}
		else
		{
			yn += random.nextInt(2) * 2 - 1;
		}

		if (level.getTile(xn, yn) == StaticTile.dirt)
		{
			level.setTile(xn, yn, this, 0);
		}
	}

	override public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int)
	{
		if (Std.is(item, ToolItem))
		{
			var tool:ToolItem = cast item;
			if (tool.type == ToolType.shovel)
			{
				if (player.payStamina(4 - tool.level))
				{
					level.setTile(xt, yt, StaticTile.dirt, 0);
					//Sound.monsterHurt.play();
					if (random.nextInt(5) == 0)
					{
						level.add(new ItemEntity(new ResourceItem(StaticResource.seeds), xt * 16 + random.nextInt(10) + 3, yt * 16 + random.nextInt(10) + 3));
						return true;
					}
				}
			}
			if (tool.type == ToolType.hoe)
			{
				if (player.payStamina(4 - tool.level))
				{
					//Sound.monsterHurt.play();
					if (random.nextInt(5) == 0)
					{
						level.add(new ItemEntity(new ResourceItem(StaticResource.seeds), xt * 16 + random.nextInt(10) + 3, yt * 16 + random.nextInt(10) + 3));
						return true;
					}
					level.setTile(xt, yt, StaticTile.farmland, 0);
					return true;
				}
			}
		}
		return false;

	}
}
