package level.tile;

import entity.Entity;
import entity.ItemEntity;
import entity.Mob;
import entity.Player;
import entity.particle.SmashParticle;
import entity.particle.TextParticle;
import gfx.Color;
import gfx.Screen;
import item.Item;
import item.ResourceItem;
import item.ToolItem;
import item.ToolType;
import item.resource.Resource;
import item.resource.StaticResource;
import level.Level;

class TreeTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
		connectsToGrass = true;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(10, 30, 151, level.grassColor);
		var barkCol1:Int = Color.get(10, 30, 430, level.grassColor);
		var barkCol2:Int = Color.get(10, 30, 320, level.grassColor);

		var u:Bool = level.getTile(x, y - 1) == this;
		var l:Bool = level.getTile(x - 1, y) == this;
		var r:Bool = level.getTile(x + 1, y) == this;
		var d:Bool = level.getTile(x, y + 1) == this;
		var ul:Bool = level.getTile(x - 1, y - 1) == this;
		var ur:Bool = level.getTile(x + 1, y - 1) == this;
		var dl:Bool = level.getTile(x - 1, y + 1) == this;
		var dr:Bool = level.getTile(x + 1, y + 1) == this;

		if (u && ul && l)
		{
			screen.render(x * 16 + 0, y * 16 + 0, 10 + 1 * 32, col, 0);
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 0, 9 + 0 * 32, col, 0);
		}
		if (u && ur && r)
		{
			screen.render(x * 16 + 8, y * 16 + 0, 10 + 2 * 32, barkCol2, 0);
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 0, 10 + 0 * 32, col, 0);
		}
		if (d && dl && l)
		{
			screen.render(x * 16 + 0, y * 16 + 8, 10 + 2 * 32, barkCol2, 0);
		} else
		{
			screen.render(x * 16 + 0, y * 16 + 8, 9 + 1 * 32, barkCol1, 0);
		}
		if (d && dr && r)
		{
			screen.render(x * 16 + 8, y * 16 + 8, 10 + 1 * 32, col, 0);
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 8, 10 + 3 * 32, barkCol2, 0);
		}
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		var damage:Int = level.getData(xt, yt);
		if (damage > 0) level.setData(xt, yt, damage - 1);
	}

	override public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		return false;
	}


	override public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int):Bool
	{
		if (Std.is(item, ToolItem))
		{
			var tool:ToolItem = cast item;
			if (tool.type == ToolType.axe)
			{
				if (player.payStamina(4 - tool.level))
				{
					hurt2(level, xt, yt, random.nextInt(10) + (tool.level) * 5 + 10);
					return true;
				}
			}
		}
		return false;
	}

	private function hurt2(level:Level, x:Int, y:Int, dmg:Int):Void
	{
		{
			var count:Int = random.nextInt(10) == 0 ? 1 : 0;
			for (i in 0...count)
			{
				level.add(new ItemEntity(new ResourceItem(StaticResource.apple), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
			}
		}
		var damage:Int = level.getData(x, y) + dmg;
		level.add(new SmashParticle(x * 16 + 8, y * 16 + 8));
		level.add(new TextParticle("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)));
		if (damage >= 20)
		{
			var count:Int = random.nextInt(2) + 1;
			for (i in 0...count)
			{
				level.add(new ItemEntity(new ResourceItem(StaticResource.wood), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
			}
			var count:Int = random.nextInt(random.nextInt(4) + 1);
			for (i in 0...count)
			{
				level.add(new ItemEntity(new ResourceItem(StaticResource.acorn), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
			}
			level.setTile(x, y, StaticTile.grass, 0);
		}
		else
		{
			level.setData(x, y, damage);
		}
	}
	
	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		hurt2(level, x, y, dmg);
	}
}
