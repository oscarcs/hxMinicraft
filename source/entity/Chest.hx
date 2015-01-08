package entity;

import gfx.Color;
import screen.ContainerMenu;

class Chest extends Furniture
{
	public var inventory:Inventory = new Inventory();

	override public function new()
	{
		super("Chest");
		col = Color.get(-1, 110, 331, 552);
		sprite = 1;
	}

	override public function use(player:Player, attackDir:Int)
	{
		player.game.setMenu(new ContainerMenu(player, "Chest", inventory));
		return true;
	}
}