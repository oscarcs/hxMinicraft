package entity;

import crafting.Crafting;
import gfx.Color;
import screen.CraftingMenu;

class Workbench extends Furniture
{
	override public function new()
	{
		super("Workbench");
		col = Color.get(-1, 100, 321, 431);
		sprite = 4;
		xr = 3;
		yr = 2;
	}

	override public function use(player:Player, attackDir:Int):Bool
	{
		player.game.setMenu(new CraftingMenu(Crafting.workbenchRecipes, player));
		return true;
	}
}