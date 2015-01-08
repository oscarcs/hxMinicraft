package level.tile;

import entity.AirWizard;
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
import level.Level;

class CloudCactusTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var color:Int = Color.get(444, 111, 333, 555);
		screen.render(x * 16 + 0, y * 16 + 0, 17 + 1 * 32, color, 0);
		screen.render(x * 16 + 8, y * 16 + 0, 18 + 1 * 32, color, 0);
		screen.render(x * 16 + 0, y * 16 + 8, 17 + 2 * 32, color, 0);
		screen.render(x * 16 + 8, y * 16 + 8, 18 + 2 * 32, color, 0);
	}

	override public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		/*
		if (Std.is(e, AirWizard)) return true;
		*/
		return false;
	}

	override public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int):Bool
	{	
		if (Std.is(item, ToolItem))
		{
			//TODO cast?
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
			if (damage >= 10)
			{
				level.setTile(x, y, StaticTile.cloud, 0);
			}
			else
			{
				level.setData(x, y, damage);
			}
		}
	}
	
	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		hurt2(level, x, y, 0);
	}

	override public function bumpedInto(level:Level, x:Int, y:Int, entity:Entity):Void
	{
		/*
		if (Std.is(entity, AirWizard)) return;
		entity.hurt(this, x, y, 3);
		*/
	}
}