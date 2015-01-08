package crafting;

//import java.util.ArrayList;
//import java.util.List;

import entity.Player;
import gfx.Color;
import gfx.Font;
import gfx.Screen;
import item.Item;
import item.ResourceItem;
import item.resource.Resource;
import screen.ListItem;

class Recipe extends ListItem
{
	public var costs:Array<Item> = [];
	public var canCraft:Bool = false;
	public var resultTemplate:Item;

	public function new(resultTemplate:Item)
	{
		//super();
		this.resultTemplate = resultTemplate;
	}

	public function addCost(resource:Resource, count:Int):Recipe
	{
		costs.push(new ResourceItem(resource, count));
		return this;
	}

	public function checkCanCraft(player:Player):Void
	{
		for (i in 0...costs.length)
		{
			var item:Item = costs[i];
			if (Std.is(item, ResourceItem))
			{
				var ri:ResourceItem = cast item;
				if (!player.inventory.hasResources(ri.resource, ri.count))
				{
					canCraft = false;
					return;
				}
			}
		}
		canCraft = true;
	}

	override public function renderInventory(screen:Screen, x:Int, y:Int):Void
	{
		screen.render(x, y, resultTemplate.getSprite(), resultTemplate.getColor(), 0);
		var textColor:Int = canCraft ? Color.get(-1, 555, 555, 555) : Color.get(-1, 222, 222, 222);
		Font.draw(resultTemplate.getName(), screen, x + 8, y, textColor);
	}

	public function craft(player:Player):Void
	{
		
	}

	public function deductCost(player:Player):Void
	{
		for (i in 0...costs.length)
		{
			var item:Item = costs[i];
			if (Std.is(item, ResourceItem))
			{
				var ri:ResourceItem = cast item;
				player.inventory.removeResource(ri.resource, ri.count);
			}
		}
	}
}