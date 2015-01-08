package item;

import entity.Entity;
import entity.ItemEntity;
import entity.Player;
import gfx.Screen;
import level.Level;
import level.tile.Tile;
import screen.ListItem;

class Item extends ListItem
{
	public function getColor():Int
	{
		return 0;
	}
	
	public function getSprite():Int
	{
		return 0;
	}
	
	public function onTake(itemEntity:ItemEntity):Void
	{
		
	}
	
	override public function renderInventory(screen:Screen, x:Int, y:Int):Void
	{
		
	}
	
	public function interact(player:Player, entity:Entity, attackDir:Int):Bool
	{
		return false;
	}
	
	public function renderIcon(screen:Screen, x:Int, y:Int):Void
	{
		
	}
	
	public function interactOn(tile:Tile, level:Level, xt:Int,  yt:Int, player:Player, attackDir:Int)
	{
		return false;
	}
	
	public function isDepleted():Bool
	{
		return false;	
	}
	
	public function canAttack():Bool
	{
		return false;
	}
	
	public function getAttackDamageBonus(e:Entity):Int
	{
		return 0;
	}
	
	public function getName():String
	{
		return "";
	}
	
	//TODO test this, wtf does it even do?
	
	public function matches(item:Item):Bool
	{
		//return Type.getClassName(this) == Type.getClassName(item);
		return true;
	}
	
	
	
	
}