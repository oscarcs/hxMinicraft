package level.tile;

import entity.Entity;
import entity.ItemEntity;
import entity.Mob;
import entity.particle.SmashParticle;
import entity.particle.TextParticle;
import gfx.Color;
import gfx.Screen;
import item.ResourceItem;
import item.resource.Resource;
import item.resource.StaticResource;
import level.Level;

class CactusTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
		connectsToSand = true;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(20, 40, 50, level.sandColor);
		screen.render(x * 16 + 0, y * 16 + 0, 8 + 2 * 32, col, 0);
		screen.render(x * 16 + 8, y * 16 + 0, 9 + 2 * 32, col, 0);
		screen.render(x * 16 + 0, y * 16 + 8, 8 + 3 * 32, col, 0);
		screen.render(x * 16 + 8, y * 16 + 8, 9 + 3 * 32, col, 0);
	}

	override public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		return false;
	}

	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		var damage:Int = level.getData(x, y) + dmg;
		level.add(new SmashParticle(x * 16 + 8, y * 16 + 8));
		level.add(new TextParticle("" + dmg, x * 16 + 8, y * 16 + 8, Color.get(-1, 500, 500, 500)));
		if (damage >= 10)
		{
			var count:Int = random.nextInt(2) + 1;
			for (i in 0...count)
			{
				level.add(new ItemEntity(new ResourceItem(StaticResource.cactusFlower), x * 16 + random.nextInt(10) + 3, y * 16 + random.nextInt(10) + 3));
			}
			level.setTile(x, y, StaticTile.sand, 0);
		}
		else
		{
			level.setData(x, y, damage);
		}
	}

	override public function bumpedInto(level:Level, x:Int, y:Int, entity:Entity):Void
	{
		entity.hurt(this, x, y, 1);
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		var damage:Int = level.getData(xt, yt);
		if (damage > 0) level.setData(xt, yt, damage - 1);
	}
}