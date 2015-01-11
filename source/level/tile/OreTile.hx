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
import level.Level;

class OreTile extends Tile
{
	private var toDrop:Resource;
	private var color:Int;

	override public function new(id:Int, toDrop:Resource)
	{
		super(id);
		this.toDrop = toDrop;
		this.color = toDrop.color & 0xffff00;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		color = (toDrop.color & 0xffffff00) + Color.get2(level.dirtColor);
		screen.render(x * 16 + 0, y * 16 + 0, 17 + 1 * 32, color, 0);
		screen.render(x * 16 + 8, y * 16 + 0, 18 + 1 * 32, color, 0);
		screen.render(x * 16 + 0, y * 16 + 8, 17 + 2 * 32, color, 0);
		screen.render(x * 16 + 8, y * 16 + 8, 18 + 2 * 32, color, 0);
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
			if (tool.type == ToolType.pickaxe)
			{
				if (player.payStamina(6 - tool.level))
				{
					hurt2(level, xt, yt, 1);
					return true;
				}
			}
		}
		return false;
	}

	public function hurt2(level:Level, x:Int, y:Int, dmg:Int):Void
	{
		var damage:Int = level.getData(x, y) + 1;
		level.add(new SmashParticle(x * 16 + 8, y * 16 + 8));
		level.add(new TextParticle("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)));
		if (dmg > 0)
		{
			var count:Int = random.nextInt(2);
			if (damage >= random.nextInt(10) + 3)
			{
				level.setTile(x, y, StaticTile.dirt, 0);
				count += 2;
			}
			else
			{
				level.setData(x, y, damage);
			}
			for (i in 0...count)
			{
				level.add(new ItemEntity(new ResourceItem(toDrop), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
			}
		}
	}

	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		hurt2(level, x, y, 0);
	}
	
	override public function bumpedInto(level:Level, x:Int, y:Int, entity:Entity):Void
	{
		entity.hurt(this, x, y, 3);
	}
}
