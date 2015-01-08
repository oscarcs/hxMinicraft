package level.tile;

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

class FlowerTile extends GrassTile
{
	override public function new(id:Int)
	{
		super(id);
		Tile.tiles[id] = this;
		connectsToGrass = true;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		trace(screen + " " + level + " " + x + " " + y);
		
		super.render(screen, level, x, y);

		var data:Int = level.getData(x, y);
		var shape:Int = Std.int((data / 16)) % 2;
		var flowerCol:Int = Color.get(10, level.grassColor, 555, 440);

		if (shape == 0) screen.render(x * 16 + 0, y * 16 + 0, 1 + 1 * 32, flowerCol, 0);
		if (shape == 1) screen.render(x * 16 + 8, y * 16 + 0, 1 + 1 * 32, flowerCol, 0);
		if (shape == 1) screen.render(x * 16 + 0, y * 16 + 8, 1 + 1 * 32, flowerCol, 0);
		if (shape == 0) screen.render(x * 16 + 8, y * 16 + 8, 1 + 1 * 32, flowerCol, 0);
	}

	override public function interact(level:Level, x:Int, y:Int, player:Player, item:Item, attackDir:Int):Bool
	{
		if (Std.is(item, ToolItem))
		{
			var tool:ToolItem = cast item;
			if (tool.type == ToolType.shovel)
			{
				if (player.payStamina(4 - tool.level))
				{
					level.add(new ItemEntity(new ResourceItem(StaticResource.flower), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
					level.add(new ItemEntity(new ResourceItem(StaticResource.flower), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
					level.setTile(x, y, StaticTile.grass, 0);
					return true;
				}
			}
		}
		return false;
	}

	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		var count:Int = random.nextInt(2) + 1;
		for (i in 0...count)
		{
			level.add(new ItemEntity(new ResourceItem(StaticResource.flower), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
		}
		level.setTile(x, y, StaticTile.grass, 0);
	}
}