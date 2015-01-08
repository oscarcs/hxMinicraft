package entity;

import gfx.Color;

class Lantern extends Furniture 
{
	override public function new()
	{
		super("Lantern");
		col = Color.get(-1, 000, 111, 555);
		sprite = 5;
		xr = 3;
		yr = 2;
	}

	override public function getLightRadius():Int
	{
		return 8;
	}
}