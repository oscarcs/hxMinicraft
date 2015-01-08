package entity;

import gfx.Color;
import gfx.Screen;
import item.ResourceItem;
import item.resource.Resource;
import item.resource.StaticResource;

class Zombie extends Mob
{
	private var xa:Int = 0;
	private var ya:Int = 0;
	private var lvl:Int;
	private var randomWalkTime:Int = 0;

	override public function new(lvl:Int)
	{
		super();
		this.lvl = lvl;
		x = random.nextInt(64 * 16);
		y = random.nextInt(64 * 16);
		health = maxHealth = lvl * lvl * 10;

	}

	override public function tick():Void
	{
		super.tick();

		if (level.player != null && randomWalkTime == 0)
		{
			var xd:Int = level.player.x - x;
			var yd:Int = level.player.y - y;
			if (xd * xd + yd * yd < 50 * 50)
			{
				xa = 0;
				ya = 0;
				if (xd < 0) xa = -1;
				if (xd > 0) xa = 1;
				if (yd < 0) ya = -1;
				if (yd > 0) ya = 1;
			}
		}

		var speed:Int = tickTime & 1;
		if (!move(xa * speed, ya * speed) || random.nextInt(200) == 0)
		{
			randomWalkTime = 60;
			xa = (random.nextInt(3) - 1) * random.nextInt(2);
			ya = (random.nextInt(3) - 1) * random.nextInt(2);
		}
		if (randomWalkTime > 0) randomWalkTime--;
	}

	override public function render(screen:Screen):Void
	{
		var xt:Int = 0;
		var yt:Int = 14;
        
		var flip1:Int = (walkDist >> 3) & 1;
		var flip2:Int = (walkDist >> 3) & 1;

		if (dir == 1)
		{
			xt += 2;
		}
		if (dir > 1)
		{

			flip1 = 0;
			flip2 = ((walkDist >> 4) & 1);
			if (dir == 2)
			{
				flip1 = 1;
			}
			xt += 4 + ((walkDist >> 3) & 1) * 2;
		}

		var xo:Int = x - 8;
		var yo:Int = y - 11;

		var col:Int = Color.get(-1, 10, 252, 050);
		if (lvl == 2) col = Color.get(-1, 100, 522, 050);
		if (lvl == 3) col = Color.get(-1, 111, 444, 050);
		if (lvl == 4) col = Color.get(-1, 000, 111, 020);
		if (hurtTime > 0)
		{
			col = Color.get(-1, 555, 555, 555);
		}

		//head?
		screen.render(xo + 8 * flip1, yo + 0, xt + yt * 32, col, flip1);
		screen.render(xo + 8 - 8 * flip1, yo + 0, xt + 1 + yt * 32, col, flip1);
		//body?
		screen.render(xo + 8 * flip2, yo + 8, xt + (yt + 1) * 32, col, flip2);
		screen.render(xo + 8 - 8 * flip2, yo + 8, xt + 1 + (yt + 1) * 32, col, flip2);
	}

	override public function touchedBy(entity:Entity)
	{
		if (Std.is(entity, Player))
		{
			trace('touched');
			entity.hurt(this, lvl + 1, dir);
		}
	}

	override public function die():Void
	{
		super.die();

		var count:Int = random.nextInt(2) + 1;
		for (i in 0...count)
		{
			level.add(new ItemEntity(new ResourceItem(StaticResource.cloth), x + random.nextInt(11) - 5, y + random.nextInt(11) - 5));
		}

		if (level.player != null)
		{
			level.player.score += 50 * lvl;
		}

	}

}