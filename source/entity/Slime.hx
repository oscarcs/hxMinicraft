package entity;

import gfx.Color;
import gfx.Screen;
import item.ResourceItem;
import item.resource.Resource;
import item.resource.StaticResource;

class Slime extends Mob
{
	private var xa:Int = 0;
	private var ya:Int = 0;
	private var jumpTime:Int = 0;
	private var lvl:Int;

	override public function new(lvl:Int)
	{
		super();
		this.lvl = lvl;
		x = random.nextInt(64 * 16);
		y = random.nextInt(64 * 16);
		health = maxHealth = lvl * lvl * 5;
	}

	override public function tick():Void
	{
		super.tick();

		var speed:Int = 1;
		if (!move(xa * speed, ya * speed) || random.nextInt(40) == 0)
		{
			if (jumpTime <= -10)
			{
				xa = (random.nextInt(3) - 1);
				ya = (random.nextInt(3) - 1);

				if (level.player != null)
				{
					var xd:Int = level.player.x - x;
					var yd:Int = level.player.y - y;
					if (xd * xd + yd * yd < 50 * 50)
					{
						if (xd < 0) xa = -1;
						if (xd > 0) xa = 1;
						if (yd < 0) ya = -1;
						if (yd > 0) ya = 1;
					}

				}

				if (xa != 0 || ya != 0) jumpTime = 10;
			}
		}

		jumpTime--;
		if (jumpTime == 0)
		{
			xa = ya = 0;
		}
	}

	override public function die():Void
	{
		super.die();

		var count:Int = random.nextInt(2) + 1;
		for (i in 0...count)
		{
			level.add(new ItemEntity(new ResourceItem(StaticResource.slime), x + random.nextInt(11) - 5, y + random.nextInt(11) - 5));
		}

		if (level.player != null)
		{
			level.player.score += 25*lvl;
		}
		
	}

	override public function render(screen:Screen):Void
	{
		var xt:Int = 0;
		var yt:Int = 18;

		var xo:Int = x - 8;
		var yo:Int = y - 11;

		if (jumpTime > 0)
		{
			xt += 2;
			yo -= 4;
		}

		var col:Int = Color.get(-1, 10, 252, 555);
		if (lvl == 2) col = Color.get(-1, 100, 522, 555);
		if (lvl == 3) col = Color.get(-1, 111, 444, 555);
		if (lvl == 4) col = Color.get(-1, 000, 111, 224);

		if (hurtTime > 0)
		{
			col = Color.get(-1, 555, 555, 555);
		}

		screen.render(xo + 0, yo + 0, xt + yt * 32, col, 0);
		screen.render(xo + 8, yo + 0, xt + 1 + yt * 32, col, 0);
		screen.render(xo + 0, yo + 8, xt + (yt + 1) * 32, col, 0);
		screen.render(xo + 8, yo + 8, xt + 1 + (yt + 1) * 32, col, 0);
	}

	override public function touchedBy(entity:Entity)
	{
		if (Std.is(entity, Player))
		{
			entity.hurt(this, lvl, dir);
		}
	}
}