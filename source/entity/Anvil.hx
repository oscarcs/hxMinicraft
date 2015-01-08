package entity;

import crafting.Crafting;
import gfx.Color;
import screen.CraftingMenu;

class Anvil extends Furniture
{
	override public function new()
	{
		super("Anvil");
		col = Color.get(-1, 000, 111, 222);
		sprite = 0;
		xr = 3;
		yr = 2;
	}

	override public function use(player:Player, attackDir:Int):Bool
	{
		player.game.setMenu(new CraftingMenu(Crafting.anvilRecipes, player));
		return true;
	}
}