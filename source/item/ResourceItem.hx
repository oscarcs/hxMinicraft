package item;

import entity.ItemEntity;
import entity.Player;
import gfx.Color;
import gfx.Font;
import gfx.Screen;
import item.resource.Resource;
import level.Level;
import level.tile.Tile;

class ResourceItem extends Item
{
	public var resource:Resource;
	public var count:Int = 1;

	public function new(resource:Resource, ?count:Int) 
	{
		this.resource = resource;
		if (count != null) this.count = count;
	}
	
	override public function getColor():Int
	{
		return resource.color;
	}
	
	override public function getSprite():Int
	{
		return resource.sprite;
	}
	
	override public function renderIcon(screen:Screen, x:Int, y:Int):Void
	{
		screen.render(x, y, resource.sprite, resource.color, 0);
	}
	
	override public function renderInventory(screen:Screen, x:Int, y:Int):Void
	{
		screen.render(x, y, resource.sprite, resource.color, 0);
		Font.draw(resource.name, screen, x + 32, y, Color.get( -1, 555, 555, 555));
		var cc:Int = count;
		if (cc > 999) cc = 999;
		Font.draw("" + cc, screen, x + 8, y, Color.get(-1, 444, 444, 444));
	}
	
	override public function getName():String
	{
		return resource.name;
	}
	
	override public function onTake(itemEntity:ItemEntity):Void
	{
		
	}
	
	override public function interactOn(tile:Tile, level:Level, xt:Int, yt:Int, player:Player, attackDir:Int):Bool
	{
		if (resource.interactOn(tile, level, xt, yt, player, attackDir))
		{
			count --;
			return true;
		}
		return false;
	}
	
	override public function isDepleted():Bool
	{
		return count <= 0;
	}
}