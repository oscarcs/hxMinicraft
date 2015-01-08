package screen;

import flixel.FlxG;
import gfx.Color;
import gfx.Font;
import gfx.Screen;

class DeadMenu extends Menu
{
	private var inputDelay:Int = 60;

	public function new()
	{
		//super();
	}

	override public function tick():Void
	{
		if (inputDelay > 0)
		{
			inputDelay--;
		}
		else if (FlxG.keys.anyJustPressed(G.attackKeys) || FlxG.keys.anyJustPressed(G.menuKeys))
		{
			game.setMenu(new TitleMenu());
		}
	}

	override public function render(screen:Screen):Void
	{
		Font.renderFrame(screen, "", 1, 3, 18, 9);
		Font.draw("You died! Aww!", screen, 2 * 8, 4 * 8, Color.get(-1, 555, 555, 555));

		var seconds:Int = Std.int(game.gameTime / 60);
		var minutes:Int = Std.int(seconds / 60);
		var hours:Int = Std.int(minutes / 60);
		minutes %= 60;
		seconds %= 60;

		var timeString:String = "";
		if (hours > 0)
		{
			timeString = hours + "h" + (minutes < 10 ? "0" : "") + minutes + "m";
		}
		else
		{
			timeString = minutes + "m " + (seconds < 10 ? "0" : "") + seconds + "s";
		}
		Font.draw("Time:", screen, 2 * 8, 5 * 8, Color.get(-1, 555, 555, 555));
		Font.draw(timeString, screen, (2 + 5) * 8, 5 * 8, Color.get(-1, 550, 550, 550));
		Font.draw("Score:", screen, 2 * 8, 6 * 8, Color.get(-1, 555, 555, 555));
		Font.draw("" + game.player.score, screen, (2 + 6) * 8, 6 * 8, Color.get(-1, 550, 550, 550));
		Font.draw("Press C to lose", screen, 2 * 8, 8 * 8, Color.get(-1, 333, 333, 333));
	}
}
