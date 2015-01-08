package level.tile;

import entity.Entity;
import gfx.Color;
import gfx.Screen;
import level.Level;

class HoleTile extends Tile 
{	
	override public function new(id:Int)
	{
		super(id);
		connectsToSand = true;
		connectsToWater = true;
		connectsToLava= true;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var col:Int = Color.get(111, 111, 110, 110);
		var transitionColor1:Int = Color.get(3, 111, level.dirtColor - 111, level.dirtColor);
		var transitionColor2:Int = Color.get(3, 111, level.sandColor - 110, level.sandColor);

		var u:Bool = !level.getTile(x, y - 1).connectsToLiquid();
		var d:Bool = !level.getTile(x, y + 1).connectsToLiquid();
		var l:Bool = !level.getTile(x - 1, y).connectsToLiquid();
		var r:Bool = !level.getTile(x + 1, y).connectsToLiquid();
        
		var su:Bool = u && level.getTile(x, y - 1).connectsToSand;
		var sd:Bool = d && level.getTile(x, y + 1).connectsToSand;
		var sl:Bool = l && level.getTile(x - 1, y).connectsToSand;
		var sr:Bool = r && level.getTile(x + 1, y).connectsToSand;

		if (!u && !l)
		{
			screen.render(x * 16 + 0, y * 16 + 0, 0, col, 0);
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 0, (l ? 14 : 15) + (u ? 0 : 1) * 32, (su || sl) ? transitionColor2 : transitionColor1, 0);
		}

		if (!u && !r)
		{
			screen.render(x * 16 + 8, y * 16 + 0, 1, col, 0);
		}
		else
		{
			screen.render(x * 16 + 8, y * 16 + 0, (r ? 16 : 15) + (u ? 0 : 1) * 32, (su || sr) ? transitionColor2 : transitionColor1, 0);
		}

		if (!d && !l)
		{
			screen.render(x * 16 + 0, y * 16 + 8, 2, col, 0);
		}
		else
		{
			screen.render(x * 16 + 0, y * 16 + 8, (l ? 14 : 15) + (d ? 2 : 1) * 32, (sd || sl) ? transitionColor2 : transitionColor1, 0);
		}
		if (!d && !r)
		{
			screen.render(x * 16 + 8, y * 16 + 8, 3, col, 0);
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

}
