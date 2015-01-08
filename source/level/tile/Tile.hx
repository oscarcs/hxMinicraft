package level.tile;

import entity.Entity;
import entity.Mob;
import entity.Player;
import gfx.Screen;
import item.Item;
import item.resource.Resource;
import level.Level;

class Tile
{
	public static var tickCount:Int = 0;
	public var random:Random = new Random();
	
	public static var tiles:Array<Tile> = [];

	public var id:Int;
	public var connectsToGrass:Bool = false;
	public var connectsToSand:Bool = false;
	public var connectsToLava:Bool = false;
	public var connectsToWater:Bool = false;
	
	public function new(id:Int) 
	{
		this.id = id;
		if (tiles[id] != null) throw ("Duplicate tile ids!");
		tiles[id] = this;
	}
	
	public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		
	}
	
	public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		return true;
	}
	
	public function getLightRadius(level:Level, x:Int, y:Int):Int
	{
		return 0;
	}
	
	public function hurt(level:Level, x:Int, y:Int, source:Mob, dmg:Int, attackDir:Int):Void
	{
		
	}

	public function bumpedInto(level:Level, xt:Int, yt:Int, entity:Entity):Void
	{
		
	}      
           
	public function tick(level:Level, xt:Int, yt:Int):Void
	{
		
	}      
           
	public function steppedOn(level:Level, xt:Int, yt:Int, entity:Entity):Void
	{
		
	}

	public function interact(level:Level, xt:Int, yt:Int, player:Player, item:Item, attackDir:Int):Bool
	{
		return false;
	}

	public function use(level:Level, xt:Int, yt:Int, player:Player, attackDir:Int):Bool
	{
		return false;
	}

	public function connectsToLiquid():Bool
	{
		return connectsToWater || connectsToLava;
	}
}