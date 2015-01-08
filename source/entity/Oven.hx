package entity;

import crafting.Crafting;
import gfx.Color;
import screen.CraftingMenu;

class Oven extends Furniture
{
	override public function new()
	{
		super("Oven");
		col = Color.get(-1, 000, 332, 442);
		sprite = 2;
		xr = 3;
		yr = 2;
	}

	override public function use(player:Player, attackDir:Int):Bool
	{
		player.game.setMenu(new CraftingMenu(Crafting.ovenRecipes, player));
		return true;
	}
}