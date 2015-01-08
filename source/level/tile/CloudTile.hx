package level.tile;

import entity.Entity;
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

 class CloudTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(444, 444, 555, 555);
		var transitionColor:Int = Color.get(333, 444, 555, -1);

		var u:Bool = level.getTile(x, y - 1) == StaticTile.infiniteFall;
		var d:Bool = level.getTile(x, y + 1) == StaticTile.infiniteFall;
		var l:Bool = level.getTile(x - 1, y) == StaticTile.infiniteFall;
		var r:Bool = level.getTile(x + 1, y) == StaticTile.infiniteFall;
		
		var ul:Bool = level.getTile(x - 1, y - 1) == StaticTile.infiniteFall;
		var dl:Bool = level.getTile(x - 1, y + 1) == StaticTile.infiniteFall;
		var ur:Bool = level.getTile(x + 1, y - 1) == StaticTile.infiniteFall;
		var dr:Bool = level.getTile(x + 1, y + 1) == StaticTile.infiniteFall;

		if (!u && !l)
		{
			if (!ul)
			{
				screen.render(x * 16 + 0, y * 16 + 0, 17, col, 0);
			}
			else
			{
				screen.render(x * 16 + 0, y * 16 + 0, 7 + 0 * 32, transitionColor, 3);
			}
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 0, (l ? 6 : 5) + (u ? 2 : 1) * 32, transitionColor, 3);
		}

		if (!u && !r)
		{
			if (!ur)
			{
				screen.render(x * 16 + 8, y * 16 + 0, 18, col, 0);
			}
			else
			{
				screen.render(x * 16 + 8, y * 16 + 0, 8 + 0 * 32, transitionColor, 3);
			}
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 0, (r ? 4 : 5) + (u ? 2 : 1) * 32, transitionColor, 3);
		}

		if (!d && !l)
		{
			if (!dl)
			{
				screen.render(x * 16 + 0, y * 16 + 8, 20, col, 0);
			}
			else
			{
				screen.render(x * 16 + 0, y * 16 + 8, 7 + 1 * 32, transitionColor, 3);
			}
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 8, (l ? 6 : 5) + (d ? 0 : 1) * 32, transitionColor, 3);
		}
		if (!d && !r)
		{
			if (!dr)
			{
				screen.render(x * 16 + 8, y * 16 + 8, 19, col, 0);
			}
			else
			{
				screen.render(x * 16 + 8, y * 16 + 8, 8 + 1 * 32, transitionColor, 3);
			}
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 8, (r ? 4 : 5) + (d ? 0 : 1) * 32, transitionColor, 3);
		}
	}

	override public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		return true;
	}

	override public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int):Bool
	{
		if (Std.is(item, ToolItem))
		{
			var tool:ToolItem = cast item;
			if (tool.type == ToolType.shovel)
			{
				if (player.payStamina(5))
				{
					// level.setTile(xt, yt, Tile.infiniteFall, 0);
					var count:Int = random.nextInt(2) + 1;
					for (i in 0...count)
					{
						level.add(new ItemEntity(new ResourceItem(StaticResource.cloud), xt * 16 + random.nextInt(10) + 3, yt * 16 + random.nextInt(10) + 3));
					}
					return true;
				}
			}
		}
		return false;
	}

	/*
	 * public boolean interact(Level level, int xt, int yt, Player player, Item item, int attackDir) { if (item instanceof ToolItem) { ToolItem tool = (ToolItem) item; if (tool.type == ToolType.pickaxe) { if (player.payStamina(4 - tool.level)) { hurt(level, xt, yt, random.nextInt(10) + (tool.level) * 5 + 10); return true; } } } return false; }
	 */
}
