package screen;

import flixel.FlxG;
import gfx.Color;
import gfx.Font;
import gfx.Screen;

class InstructionsMenu extends Menu
{
	private var parent:Menu;

	public function new(parent:Menu)
	{
		//super();
		this.parent = parent;
	}

	override public function tick():Void
	{
		if (FlxG.keys.anyJustPressed(G.attackKeys) || FlxG.keys.anyJustPressed(G.menuKeys))
		{
			game.setMenu(parent);
		}
	}

	override public function render(screen:Screen):Void
	{
		screen.clear(0);

		Font.draw("HOW TO PLAY", screen, 4 * 8 + 4, 1 * 8, Color.get(0, 555, 555, 555));
		Font.draw("Move your character", screen, 0 * 8 + 4, 3 * 8, Color.get(0, 333, 333, 333));
		Font.draw("with the arrow keys", screen, 0 * 8 + 4, 4 * 8, Color.get(0, 333, 333, 333));
		Font.draw("press C to attack", screen, 0 * 8 + 4, 5 * 8, Color.get(0, 333, 333, 333));
		Font.draw("and X to open the", screen, 0 * 8 + 4, 6 * 8, Color.get(0, 333, 333, 333));
		Font.draw("inventory and to", screen, 0 * 8 + 4, 7 * 8, Color.get(0, 333, 333, 333));
		Font.draw("use items.", screen, 0 * 8 + 4, 8 * 8, Color.get(0, 333, 333, 333));
		Font.draw("Select an item in", screen, 0 * 8 + 4, 9 * 8, Color.get(0, 333, 333, 333));
		Font.draw("the inventory to", screen, 0 * 8 + 4, 10 * 8, Color.get(0, 333, 333, 333));
		Font.draw("equip it.", screen, 0 * 8 + 4, 11 * 8, Color.get(0, 333, 333, 333));
		Font.draw("Kill the air wizard", screen, 0 * 8 + 4, 12 * 8, Color.get(0, 333, 333, 333));
		Font.draw("to win the game!", screen, 0 * 8 + 4, 13 * 8, Color.get(0, 333, 333, 333));
	}
}
