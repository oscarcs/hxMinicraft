package level.tile;

import gfx.Color;
import gfx.Screen;
import level.Level;

class StairsTile extends Tile
{
	private var leadsUp:Bool;

	override public function new(id:Int, leadsUp:Bool)
	{
		super(id);
		this.leadsUp = leadsUp;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var color:Int = Color.get(level.dirtColor, 000, 333, 444);
		var xt:Int = 0;
		if (leadsUp) xt = 2;
		screen.render(x * 16 + 0, y * 16 + 0, xt + 2 * 32, color, 0);
		screen.render(x * 16 + 8, y * 16 + 0, xt + 1 + 2 * 32, color, 0);
		screen.render(x * 16 + 0, y * 16 + 8, xt + 3 * 32, color, 0);
		screen.render(x * 16 + 8, y * 16 + 8, xt + 1 + 3 * 32, color, 0);
	}
}
