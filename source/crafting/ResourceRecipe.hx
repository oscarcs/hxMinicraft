package crafting;

import entity.Player;
import gfx.Color;
import gfx.Font;
import gfx.Screen;
import item.ResourceItem;
import item.resource.Resource;

class ResourceRecipe extends Recipe
{
	private var resource:Resource;

	override public function new(resource:Resource)
	{
		super(new ResourceItem(resource, 1));
		this.resource = resource;
	}

	override public function craft(player:Player):Void
	{
		player.inventory.add2(0, new ResourceItem(resource, 1));
	}
}
