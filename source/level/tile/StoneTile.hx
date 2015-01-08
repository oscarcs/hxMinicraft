package level.tile;

import entity.Entity;
import gfx.Color;
import gfx.Screen;
import level.Level;

class StoneTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		var rc1:Int = 111;
		var rc2:Int = 333;
		var rc3:Int = 555;
		screen.render(x * 16 + 0, y * 16 + 0, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0);
		screen.render(x * 16 + 8, y * 16 + 0, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0);
		screen.render(x * 16 + 0, y * 16 + 8, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0);
		screen.render(x * 16 + 8, y * 16 + 8, 32, Color.get(rc1, level.dirtColor, rc2, rc3), 0);
	}

	override public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		return false;
	}

}
