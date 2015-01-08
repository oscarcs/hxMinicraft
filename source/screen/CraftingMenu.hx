package screen;

//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
//import java.util.List;

import flixel.FlxG;

import crafting.Recipe;
import entity.Player;
import gfx.Color;
import gfx.Font;
import gfx.Screen;
import item.Item;
import item.ResourceItem;
//import sound.Sound;

class CraftingMenu extends Menu
{
	private var player:Player;
	private var selected:Int = 0;

	private var recipes:Array<Recipe>;

	public function new(recipes:Array<Recipe>, player:Player)
	{
		//super();
		
		this.recipes = recipes;
		this.player = player;

		for (i in 0...recipes.length)
		{
			this.recipes[i].checkCanCraft(player);
		}

		
		//recipes.sort(
		
		/*
		Collections.sort(this.recipes, new Comparator<Recipe>()
		{
			public int compare(Recipe r1, Recipe r2)
			{
				if (r1.canCraft && !r2.canCraft) return -1;
				if (!r1.canCraft && r2.canCraft) return 1;
				return 0;
			}
		});
		*/
	}

	override public function tick():Void
	{
		if (FlxG.keys.anyJustPressed(G.menuKeys)) game.setMenu(null);

		if (FlxG.keys.anyJustPressed(G.upKeys)) selected--;
		if (FlxG.keys.anyJustPressed(G.downKeys)) selected++;

		var len:Int = recipes.length;
		if (len == 0) selected = 0;
		if (selected < 0) selected += len;
		if (selected >= len) selected -= len;

		if (FlxG.keys.anyJustPressed(G.attackKeys) && len > 0)
		{
			var r:Recipe = recipes[selected];
			r.checkCanCraft(player);
			if (r.canCraft)
			{
				r.deductCost(player);
				r.craft(player);
				//Sound.craft.play();
			}
			for (i in 0...recipes.length)
			{
				recipes[i].checkCanCraft(player);
			}
		}
	}

	override public function render(screen:Screen):Void
	{
		Font.renderFrame(screen, "Have", 12, 1, 19, 3);
		Font.renderFrame(screen, "Cost", 12, 4, 19, 11);
		Font.renderFrame(screen, "Crafting", 0, 1, 11, 11);
		renderItemList(screen, 0, 1, 11, 11, cast recipes, selected);

		if (recipes.length > 0)
		{
			var recipe:Recipe = recipes[selected];
			var hasResultItems:Int = player.inventory.count(recipe.resultTemplate);
			var xo:Int = 13 * 8;
			screen.render(xo, 2 * 8, recipe.resultTemplate.getSprite(), recipe.resultTemplate.getColor(), 0);
			Font.draw("" + hasResultItems, screen, xo + 8, 2 * 8, Color.get(-1, 555, 555, 555));

			var costs:Array<Item> = recipe.costs;
			for (i in 0...costs.length)
			{
				var item:Item = costs[i];
				var yo:Int = (5 + i) * 8;
				screen.render(xo, yo, item.getSprite(), item.getColor(), 0);
				var requiredAmt:Int = 1;
				if (Std.is(item, ResourceItem))
				{
					var unsafeCast:ResourceItem = cast item;
					requiredAmt = unsafeCast.count;
				}
				var has:Int = player.inventory.count(item);
				var color:Int = Color.get(-1, 555, 555, 555);
				if (has < requiredAmt)
				{
					color = Color.get(-1, 222, 222, 222);
				}
				if (has > 99) has = 99;
				Font.draw("" + requiredAmt + "/" + has, screen, xo + 8, yo, color);
			}
		}
		// renderItemList(screen, 12, 4, 19, 11, recipes.get(selected).costs, -1);
	}
}