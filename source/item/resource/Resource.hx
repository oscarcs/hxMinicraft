package item.resource;

import entity.Player;
import gfx.Color;
import level.Level;
import level.tile.Tile;
import level.tile.StaticTile;

class Resource
{	
	public var name:String;
	public var sprite:Int;
	public var color:Int;
	
	public function new(name:String, sprite:Int, color:Int)
	{
		if (name.length > 6) throw("name must be <6 chars");
		this.name = name;
		this.sprite = sprite;
		this.color = color;
	}
	
	public function interactOn(tile:Tile, level:Level, xt:Int, yt:Int, player:Player, attackDir:Int):Bool
	{
		return false;
	}
	
}