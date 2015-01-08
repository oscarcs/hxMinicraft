package entity.particle;

import entity.Entity;
import gfx.Color;
import gfx.Screen;
//import sound.Sound;

class SmashParticle extends Entity
{
	private var time:Int = 0;

	override public function new(x:Int, y:Int)
	{
		super();
		this.x = x;
		this.y = y;
		//Sound.monsterHurt.play();
	}

	override public function tick():Void
	{
		time++;
		if (time > 10)
		{
			remove();
		}
	}

	override public function render(screen:Screen):Void
	{
		var col:Int = Color.get(-1, 555, 555, 555);
		screen.render(x - 8, y - 8, 5 + 12 * 32, col, 2);
		screen.render(x - 0, y - 8, 5 + 12 * 32, col, 3);
		screen.render(x - 8, y - 0, 5 + 12 * 32, col, 0);
		screen.render(x - 0, y - 0, 5 + 12 * 32, col, 1);
	}
}
