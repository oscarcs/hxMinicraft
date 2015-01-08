package screen;

import gfx.Screen;

class LevelTransitionMenu extends Menu
{
	private var dir:Int = 0;
	private var time:Int = 0;

	public function new(dir:Int)
	{
		//super();
		this.dir = dir;
	}

	override public function tick():Void
	{
		#if neko
		if (dir == null) dir = 0;
		#end
		time += 2;
		if (time == 30) game.changeLevel(dir);
		if (time == 60) game.setMenu(null);
	}

	override public function render(screen:Screen):Void
	{
		for (x in 0...20)
		{
			for (y in 0...15)
			{
				var dd:Int = Std.int((y + x % 2 * 2 + x / 3) - time);
				if (dd < 0 && dd > -30)
				{
					if (dir > 0)
					{
						screen.render(x * 8, y * 8, 0, 0, 0);
					}
					else
					{
						screen.render(x * 8, screen.h - y * 8 - 8, 0, 0, 0);
					}
				}
			}
		}
	}
}
