package crafting;

import entity.Player;
import item.ToolItem;
import item.ToolType;

class ToolRecipe extends Recipe
{
	private var type:ToolType;
	private var level:Int;

	override public function new(type:ToolType, level:Int) 
	{
		super(new ToolItem(type, level));
		this.type = type;
		this.level = level;
	}

	override public function craft(player:Player):Void
	{
		player.inventory.add2(0, new ToolItem(type, level));
	}
}
