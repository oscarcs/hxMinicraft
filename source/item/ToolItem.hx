package item;

//import java.util.Random;

import entity.Entity;
import entity.ItemEntity;
import gfx.Color;
import gfx.Font;
import gfx.Screen;

class ToolItem extends Item
{
	private var random:Random = new Random();

	public static var MAX_LEVEL:Int = 5;
	public static var LEVEL_NAMES:Array<String> = ["Wood", "Rock", "Iron", "Gold", "Gem"];

	public static var LEVEL_COLORS:Array<Int> = [//
			Color.get(-1, 100, 321, 431),//
			Color.get(-1, 100, 321, 111),//
			Color.get(-1, 100, 321, 555),//
			Color.get(-1, 100, 321, 550),//
			Color.get(-1, 100, 321, 055),//
	];

	public var type:ToolType;
	public var level:Int = 0;

	override public function new(type:ToolType, level:Int)
	{
		this.type = type;
		this.level = level;
	}

	override public function getColor():Int
	{
		return LEVEL_COLORS[level];
	}

	override public function getSprite():Int
	{
		return type.sprite + 5 * 32;
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
		return LEVEL_NAMES[level] + " " + type.name;
	}

	override public function onTake(itemEntity:ItemEntity):Void
	{
		
	}

	override public function canAttack():Bool
	{
		return true;
	}

	override public function getAttackDamageBonus(e:Entity):Int
	{
		if (type == ToolType.axe)
		{
			return (level + 1) * 2 + random.nextInt(4);
		}
		if (type == ToolType.sword)
		{
			return (level + 1) * 3 + random.nextInt(2 + level * level * 2);
		}
		return 1;
	}

	override public function matches(item:Item):Bool
	{
		if (Std.is(item, ToolItem))
		{
			var other:ToolItem = cast item;
			if (other.type != type) return false;
			if (other.level != level) return false;
			return true;
		}
		return false;
	}
}