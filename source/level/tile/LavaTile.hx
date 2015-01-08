package level.tile;

//import java.util.Random;

import entity.Entity;
import gfx.Color;
import gfx.Screen;
import level.Level;

class LavaTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
		connectsToSand = true;
		connectsToLava = true;
	}

	private var wRandom:Random = new Random();

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		// ... what.
		wRandom.setSeed(Std.int((Tile.tickCount + (x / 2 - y) * 4311) / 10 * 54687121 + x * 3271612 + y * 3412987161));
		var col:Int = Color.get(500, 500, 520, 550);
		var transitionColor1:Int = Color.get(3, 500, level.dirtColor - 111, level.dirtColor);
		var transitionColor2:Int = Color.get(3, 500, level.sandColor - 110, level.sandColor);

		var u:Bool = !level.getTile(x, y - 1).connectsToLava;
		var d:Bool = !level.getTile(x, y + 1).connectsToLava;
		var l:Bool = !level.getTile(x - 1, y).connectsToLava;
		var r:Bool = !level.getTile(x + 1, y).connectsToLava;
		
		var su:Bool = u && level.getTile(x, y - 1).connectsToSand;
		var sd:Bool = d && level.getTile(x, y + 1).connectsToSand;
		var sl:Bool = l && level.getTile(x - 1, y).connectsToSand;
		var sr:Bool = r && level.getTile(x + 1, y).connectsToSand;

		if (!u && !l)
		{
			screen.render(x * 16 + 0, y * 16 + 0, wRandom.nextInt(4), col, wRandom.nextInt(4));
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 0, (l ? 14 : 15) + (u ? 0 : 1) * 32, (su || sl) ? transitionColor2 : transitionColor1, 0);
		}

		if (!u && !r)
		{
			screen.render(x * 16 + 8, y * 16 + 0, wRandom.nextInt(4), col, wRandom.nextInt(4));
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 0, (r ? 16 : 15) + (u ? 0 : 1) * 32, (su || sr) ? transitionColor2 : transitionColor1, 0);
		}

		if (!d && !l)
		{
			screen.render(x * 16 + 0, y * 16 + 8, wRandom.nextInt(4), col, wRandom.nextInt(4));
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 8, (l ? 14 : 15) + (d ? 2 : 1) * 32, (sd || sl) ? transitionColor2 : transitionColor1, 0);
		}
		if (!d && !r)
		{
			screen.render(x * 16 + 8, y * 16 + 8, wRandom.nextInt(4), col, wRandom.nextInt(4));
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 8, (r ? 16 : 15) + (d ? 2 : 1) * 32, (sd || sr) ? transitionColor2 : transitionColor1, 0);
		}
	}

	override public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		return e.canSwim();
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		var xn:Int = xt;
		var yn:Int = yt;

		if (random.nextBoolean())
		{
			xn += random.nextInt(2) * 2 - 1;
		}
		else
		{
			yn += random.nextInt(2) * 2 - 1;
		}

		if (level.getTile(xn, yn) == StaticTile.hole)
		{
			level.setTile(xn, yn, this, 0);
		}
	}

	override public function getLightRadius(level:Level, x:Int, y:Int):Int
	{
		return 6;
	}
}
