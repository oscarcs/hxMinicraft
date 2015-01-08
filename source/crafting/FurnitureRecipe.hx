package crafting;

import entity.Furniture;
import entity.Player;
import item.FurnitureItem;

class FurnitureRecipe extends Recipe
{
	private var clazz:Class<Furniture>;
	
	override public function new(clazz:Class<Furniture>)
	{
		//super(new FurnitureItem(clazz.newInstance()));
		super(new FurnitureItem(Type.createInstance(clazz, [])));
		this.clazz = clazz;
	}

	override public function craft(player:Player):Void
	{
		player.inventory.add2(0, new FurnitureItem(Type.createInstance(clazz, [])));
	}
}
