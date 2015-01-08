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
import item.resource.StaticResource;
import level.Level;

class HardRockTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(334, 334, 223, 223);
		var transitionColor:Int = Color.get(001, 334, 445, level.dirtColor);

		var u:Bool= level.getTile(x, y - 1) != this;
		var d:Bool= level.getTile(x, y + 1) != this;
		var l:Bool= level.getTile(x - 1, y) != this;
		var r:Bool = level.getTile(x + 1, y) != this;
		
		var ul:Bool = level.getTile(x - 1, y - 1) != this;
		var dl:Bool = level.getTile(x - 1, y + 1) != this;
		var ur:Bool = level.getTile(x + 1, y - 1) != this;
		var dr:Bool = level.getTile(x + 1, y + 1) != this;

		if (!u && !l)
		{
			if (!ul)
			{
				screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0);
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
				screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0);
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
				screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0);
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
				screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0);
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
		return false;
	}

	override public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int):Bool
	{
		if (Std.is(item, ToolItem))
		{
			var tool:ToolItem = cast item;
			if (tool.type == ToolType.pickaxe && tool.level == 4)
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

	public function hurt2(level:Level, x:Int, y:Int, dmg:Int):Void
	{
		var damage:Int = level.getData(x, y) + dmg;
		level.add(new SmashParticle(x * 16 + 8, y * 16 + 8));
		level.add(new TextParticle("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)));
		if (damage >= 200)
		{
			var count:Int = random.nextInt(4) + 1;
			for (i in 0...count)
			{
				level.add(new ItemEntity(new ResourceItem(StaticResource.stone), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
			}
			count = random.nextInt(2);
			for (i in 0...count)
			{
				level.add(new ItemEntity(new ResourceItem(StaticResource.coal), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
			}
			level.setTile(x, y, StaticTile.dirt, 0);
		}
		else
		{
			level.setData(x, y, damage);
		}
	}
	
	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		hurt2(level, x, y, 0);
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		var damage:Int = level.getData(xt, yt);
		if (damage > 0) level.setData(xt, yt, damage - 1);
	}
}
