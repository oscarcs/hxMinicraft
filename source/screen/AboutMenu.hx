package screen;

import flixel.FlxG;

import gfx.Color;
import gfx.Font;
import gfx.Screen;

class AboutMenu extends Menu
{
	private var parent:Menu;

	override public function new(parent:Menu)
	{
		this.parent = parent;
	}

	override public function tick():Void
	{
		if (FlxG.keys.anyJustPressed(G.menuKeys) || FlxG.keys.anyJustPressed(G.attackKeys))
		{
			game.setMenu(parent);
		}
	}

	override public function render(screen:Screen):Void
	{
		screen.clear(0);
		
		Font.draw("About Minicraft", screen, 2 * 8 + 4, 1 * 8, Color.get(0, 555, 555, 555));
		Font.draw("Minicraft was made", screen, 0 * 8 + 4, 3 * 8, Color.get(0, 333, 333, 333));
		Font.draw("by Markus Persson", screen, 0 * 8 + 4, 4 * 8, Color.get(0, 333, 333, 333));
		Font.draw("For the 22'nd ludum", screen, 0 * 8 + 4, 5 * 8, Color.get(0, 333, 333, 333));
		Font.draw("dare competition in", screen, 0 * 8 + 4, 6 * 8, Color.get(0, 333, 333, 333));
		Font.draw("december 2011.", screen, 0 * 8 + 4, 7 * 8, Color.get(0, 333, 333, 333));
		Font.draw("ported to haxe", screen, 0 * 8 + 4, 9 * 8, Color.get(0, 333, 333, 333));
		Font.draw("jan 2015 by oscar.", screen, 0 * 8 + 4, 10 * 8, Color.get(0, 333, 333, 333));
	}
}
