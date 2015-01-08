package item;

import entity.Entity;
import entity.Furniture;
import entity.Player;
import gfx.Color;
import gfx.Font;
import gfx.Screen;

class PowerGloveItem extends Item
{
	public function new()
	{
		
	}
	
	override public function getColor():Int
	{
		return Color.get(-1, 100, 320, 430);
	}

	override public function getSprite():Int
	{
		return 7 + 4 * 32;
	}

	override public function renderIcon(screen:Screen, x:Int, y:Int):Void
	{
		screen.render(x, y, getSprite(), getColor(), 0);
	}

	override public function renderInventory(screen:Screen, x:Int, y:Int):Void
	{
		screen.render(x, y, getSprite(), getColor(), 0);
		Font.draw(getName(), screen, x + 8, y, Color.get(-1, 555, 555, 555));
	}

	override public function getName():String
	{
		return "Pow glove";
	}

	override public function interact(player:Player, entity:Entity, attackDir:Int):Bool
	{
		if (Std.is(entity, Furniture))
		{
			var f:Furniture = cast entity;
			f.take(player);
			return true;
		}
		return false;
	}
}