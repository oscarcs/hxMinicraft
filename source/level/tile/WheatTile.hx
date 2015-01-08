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
import item.resource.StaticResource;
import level.Level;

class WheatTile extends Tile
{	
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var age:Int = level.getData(x, y);
		var col:Int = Color.get(level.dirtColor - 121, level.dirtColor - 11, level.dirtColor, 50);
		var icon:Int = Std.int(age / 10);
		if (icon >= 3)
		{
			col = Color.get(level.dirtColor - 121, level.dirtColor - 11, 50 + (icon) * 100, 40 + (icon - 3) * 2 * 100);
			if (age == 50)
			{
				col = Color.get(0, 0, 50 + (icon) * 100, 40 + (icon - 3) * 2 * 100);
			}
			icon = 3;
		}

		screen.render(x * 16 + 0, y * 16 + 0, 4 + 3 * 32 + icon, col, 0);
		screen.render(x * 16 + 8, y * 16 + 0, 4 + 3 * 32 + icon, col, 0);
		screen.render(x * 16 + 0, y * 16 + 8, 4 + 3 * 32 + icon, col, 1);
		screen.render(x * 16 + 8, y * 16 + 8, 4 + 3 * 32 + icon, col, 1);
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		if (random.nextInt(2) == 0) return;

		var age:Int = level.getData(xt, yt);
		if (age < 50) level.setData(xt, yt, age + 1);
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

	override public function steppedOn(level:Level, xt:Int, yt:Int, entity:Entity):Void
	{
		if (random.nextInt(60) != 0) return;
		if (level.getData(xt, yt) < 2) return;
		harvest(level, xt, yt);
	}

	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		harvest(level, x, y);
	}

	private function harvest(level:Level, x:Int, y:Int):Void
	{
		var age:Int = level.getData(x, y);

		var count:Int = random.nextInt(2);
		for (i in 0...count)
		{
			level.add(new ItemEntity(new ResourceItem(StaticResource.seeds), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
		}

		count = 0;
		if (age == 50)
		{
			count = random.nextInt(3) + 2;
		}
		else if (age >= 40)
		{
			count = random.nextInt(2) + 1;
		}
		for (i in 0...count)
		{
			level.add(new ItemEntity(new ResourceItem(StaticResource.wheat), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
		}

		level.setTile(x, y, StaticTile.dirt, 0);
	}
}
