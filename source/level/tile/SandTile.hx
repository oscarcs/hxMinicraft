package level.tile;

import entity.Entity;
import entity.ItemEntity;
import entity.Mob;
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

class SandTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
		connectsToSand = true;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(level.sandColor + 2, level.sandColor, level.sandColor - 110, level.sandColor - 110);
		var transitionColor:Int = Color.get(level.sandColor - 110, level.sandColor, level.sandColor - 110, level.dirtColor);

		var u:Bool = !level.getTile(x, y - 1).connectsToSand;
		var d:Bool = !level.getTile(x, y + 1).connectsToSand;
		var l:Bool = !level.getTile(x - 1, y).connectsToSand;
		var r:Bool = !level.getTile(x + 1, y).connectsToSand;

		var steppedOn:Bool = level.getData(x, y) > 0;

		if (!u && !l)
		{
			if (!steppedOn)
			{
				screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0);
			}
			else
			{
				screen.render(x * 16 + 0, y * 16 + 0, 3 + 1 * 32, col, 0);
			}
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
			if (!steppedOn)
			{
				screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0);
			}
			else
			{
				screen.render(x * 16 + 8, y * 16 + 8, 3 + 1 * 32, col, 0);
			}

		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 8, (r ? 13 : 12) + (d ? 2 : 1) * 32, transitionColor, 0);
		}
	}

	override public function tick(level:Level, x:Int, y:Int):Void
	{
		var d:Int = level.getData(x, y);
		if (d > 0) level.setData(x, y, d - 1);
	}

	override public function steppedOn(level:Level, x:Int, y:Int, entity:Entity):Void
	{
		if (Std.is(entity, Mob))
		{
			level.setData(x, y, 10);
		}
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
					level.add(new ItemEntity(new ResourceItem(StaticResource.sand), xt * 16 + random.nextInt(10) + 3, yt * 16 + random.nextInt(10) + 3));
					return true;
				}
			}
		}
		return false;
	}
}
