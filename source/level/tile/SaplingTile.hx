package level.tile;

import entity.Mob;
import gfx.Color;
import gfx.Screen;
import level.Level;

class SaplingTile extends Tile
{
	private var onType:Tile;
	private var growsTo:Tile;

	override public function new(id:Int, onType:Tile, growsTo:Tile)
	{
		super(id);
		this.onType = onType;
		this.growsTo = growsTo;
		connectsToSand = onType.connectsToSand;
		connectsToGrass = onType.connectsToGrass;
		connectsToWater = onType.connectsToWater;
		connectsToLava = onType.connectsToLava;
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		onType.render(screen, level, x, y);
		var col:Int = Color.get(10, 40, 50, -1);
		screen.render(x * 16 + 4, y * 16 + 4, 11 + 3 * 32, col, 0);
	}

	override public function tick(level:Level, x:Int, y:Int):Void
	{
		var age:Int = level.getData(x, y) + 1;
		if (age > 100)
		{
			level.setTile(x, y, growsTo, 0);
		}
		else
		{
			level.setData(x, y, age);
		}
	}

	override public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void 
	{
		level.setTile(x, y, onType, 0);
	}
}