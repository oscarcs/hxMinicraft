package crafting;

//import java.util.ArrayList;
//import java.util.List;

import entity.Anvil;
import entity.Chest;
import entity.Furnace;
import entity.Oven;
import entity.Lantern;
import entity.Workbench;
import item.ToolType;
import item.resource.Resource;
import item.resource.StaticResource;


class Crafting
{
	public static var anvilRecipes:Array<Recipe> = [];
	public static var ovenRecipes:Array<Recipe> = [];
	public static var furnaceRecipes:Array<Recipe> = [];
	public static var workbenchRecipes:Array<Recipe> = [];

	public static function init():Void
	{
		workbenchRecipes.push(new FurnitureRecipe(Lantern).addCost(StaticResource.wood, 5).addCost(StaticResource.slime, 10).addCost(StaticResource.glass, 4));
                        
		workbenchRecipes.push(new FurnitureRecipe(Oven).addCost(StaticResource.stone, 15));
		workbenchRecipes.push(new FurnitureRecipe(Furnace).addCost(StaticResource.stone, 20));
		workbenchRecipes.push(new FurnitureRecipe(Workbench).addCost(StaticResource.wood, 20));
		workbenchRecipes.push(new FurnitureRecipe(Chest).addCost(StaticResource.wood, 20));
		workbenchRecipes.push(new FurnitureRecipe(Anvil).addCost(StaticResource.ironIngot, 5));
                        
		workbenchRecipes.push(new ToolRecipe(ToolType.sword, 0).addCost(StaticResource.wood, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.axe, 0).addCost(StaticResource.wood, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.hoe, 0).addCost(StaticResource.wood, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.pickaxe, 0).addCost(StaticResource.wood, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.shovel, 0).addCost(StaticResource.wood, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.sword, 1).addCost(StaticResource.wood, 5).addCost(StaticResource.stone, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.axe, 1).addCost(StaticResource.wood, 5).addCost(StaticResource.stone, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.hoe, 1).addCost(StaticResource.wood, 5).addCost(StaticResource.stone, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.pickaxe, 1).addCost(StaticResource.wood, 5).addCost(StaticResource.stone, 5));
		workbenchRecipes.push(new ToolRecipe(ToolType.shovel, 1).addCost(StaticResource.wood, 5).addCost(StaticResource.stone, 5));

		anvilRecipes.push(new ToolRecipe(ToolType.sword, 2).addCost(StaticResource.wood, 5).addCost(StaticResource.ironIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.axe, 2).addCost(StaticResource.wood, 5).addCost(StaticResource.ironIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.hoe, 2).addCost(StaticResource.wood, 5).addCost(StaticResource.ironIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.pickaxe, 2).addCost(StaticResource.wood, 5).addCost(StaticResource.ironIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.shovel, 2).addCost(StaticResource.wood, 5).addCost(StaticResource.ironIngot, 5));
                    
		anvilRecipes.push(new ToolRecipe(ToolType.sword, 3).addCost(StaticResource.wood, 5).addCost(StaticResource.goldIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.axe, 3).addCost(StaticResource.wood, 5).addCost(StaticResource.goldIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.hoe, 3).addCost(StaticResource.wood, 5).addCost(StaticResource.goldIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.pickaxe, 3).addCost(StaticResource.wood, 5).addCost(StaticResource.goldIngot, 5));
		anvilRecipes.push(new ToolRecipe(ToolType.shovel, 3).addCost(StaticResource.wood, 5).addCost(StaticResource.goldIngot, 5));
                    
		anvilRecipes.push(new ToolRecipe(ToolType.sword, 4).addCost(StaticResource.wood, 5).addCost(StaticResource.gem, 50));
		anvilRecipes.push(new ToolRecipe(ToolType.axe, 4).addCost(StaticResource.wood, 5).addCost(StaticResource.gem, 50));
		anvilRecipes.push(new ToolRecipe(ToolType.hoe, 4).addCost(StaticResource.wood, 5).addCost(StaticResource.gem, 50));
		anvilRecipes.push(new ToolRecipe(ToolType.pickaxe, 4).addCost(StaticResource.wood, 5).addCost(StaticResource.gem, 50));
		anvilRecipes.push(new ToolRecipe(ToolType.shovel, 4).addCost(StaticResource.wood, 5).addCost(StaticResource.gem, 50));

		furnaceRecipes.push(new ResourceRecipe(StaticResource.ironIngot).addCost(StaticResource.ironOre, 4).addCost(StaticResource.coal, 1));
		furnaceRecipes.push(new ResourceRecipe(StaticResource.goldIngot).addCost(StaticResource.goldOre, 4).addCost(StaticResource.coal, 1));
		furnaceRecipes.push(new ResourceRecipe(StaticResource.glass).addCost(StaticResource.sand, 4).addCost(StaticResource.coal, 1));

		ovenRecipes.push(new ResourceRecipe(StaticResource.bread).addCost(StaticResource.wheat, 4));
	}
}