package entity;

import crafting.Crafting;
import gfx.Color;
import screen.CraftingMenu;

class Furnace extends Furniture
{
	override public function new()
	{
		super("Furnace");
		col = Color.get(-1, 000, 222, 333);
		sprite = 3;
		xr = 3;
		yr = 2;
	}

	override public function use(player:Player, attackDir:Int)
	{
		player.game.setMenu(new CraftingMenu(Crafting.furnaceRecipes, player));
		return true;
	}
}