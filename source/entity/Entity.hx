package entity;

import gfx.Screen;
import item.Item;
import level.Level;
import level.tile.Tile;

class Entity
{
	//static?
	private var random:Random = new Random();
	public var x:Int;
	public var y:Int;
	public var xr:Int = 6;
	public var yr:Int = 6;
	public var removed:Bool;
	public var level:Level;
	
	public function new() 
	{
		
	}
	
	public function render(screen:Screen):Void
	{
		
	}
	
	public function tick():Void
	{
		
	}
	
	public function remove():Void
	{
		removed = true;
	}
	
	public function init(level:Level)
	{
		this.level = level;
	}
	
	public function intersects(x0:Int, y0:Int, x1:Int, y1:Int):Bool
	{
		return !(x + xr < x0 || y + yr < y0 || x - xr > x1 || y - yr > y1);
	}
	
	public function blocks(e:Entity)
	{
		return false;
	}
	
	//oh boy, things are getting crazy.
	public function hurt(tile_or_mob:Dynamic, x_or_dmg:Int, y_or_attackDir:Int, ?dmg:Int):Void
	{
		
	}
	
	public function move(xa:Int, ya:Int):Bool
	{
		if (xa != 0 || ya != 0)
		{
			var stopped:Bool = true;
			if (xa != 0 && move2(xa, 0)) stopped = false;
			if (ya != 0 && move2(0, ya)) stopped = false;
			if (!stopped)
			{
				var xt:Int = x >> 4;
				var yt:Int = y >> 4;
				level.getTile(xt, yt).steppedOn(level, xt, yt, this);
			}
			return !stopped;
		}
		return true;
	}
	
	public function move2(xa:Int, ya:Int):Bool
	{
		if (xa != 0 && ya != 0)
		{
			throw ("Move2 can only move along one axis at a time!");
		}

		var xto0:Int = ((x) - xr) >> 4;
		var yto0:Int = ((y) - yr) >> 4;
		var xto1:Int = ((x) + xr) >> 4;
		var yto1:Int = ((y) + yr) >> 4;
		
		var xt0:Int = ((x + xa) - xr) >> 4;
		var yt0:Int = ((y + ya) - yr) >> 4;
		var xt1:Int = ((x + xa) + xr) >> 4;
		var yt1:Int = ((y + ya) + yr) >> 4;
		var blocked:Bool = false;
		for (yt in yt0...(yt1+1))
		{
			for (xt in xt0...(xt1+1))
			{
				if (xt >= xto0 && xt <= xto1 && yt >= yto0 && yt <= yto1) continue;
				level.getTile(xt, yt).bumpedInto(level, xt, yt, this);
				if (!level.getTile(xt, yt).mayPass(level, xt, yt, this))
				{
					blocked = true;
					return false;
				}
			}
		}
		if (blocked) return false;

		var wasInside:Array<Entity> = level.getEntities(x - xr, y - yr, x + xr, y + yr);
		var isInside:Array<Entity> = level.getEntities(x + xa - xr, y + ya - yr, x + xa + xr, y + ya + yr);
		for (i in 0...isInside.length)
		{
			var e:Entity = isInside[i];
			if (e == this) continue;
			
			e.touchedBy(this);
		}
		for (i in 0...wasInside.length)
		{
			isInside.remove(wasInside[i]);
		}
		for (i in 0...isInside.length)
		{
			var e:Entity = isInside[i];
			if (e == this) continue;

			if (e.blocks(this)) return false;
		}

		x += xa;
		y += ya;
		return true;
	}
	
	private function touchedBy(entity:Entity):Void
	{
		
	}
	
	public function isBlockableBy(mob:Mob):Bool
	{
		return true;
	}
	
	public function touchItem(itemEntity:ItemEntity):Void
	{
		
	}
	
	public function canSwim():Bool
	{
		return false;
	}
	
	//subverting Haxe's function signatures checker.
	//see Player.hx.
	public function interact(player:Dynamic, item:Dynamic, attackDir:Int, ?y1:Int):Bool
	{
		return item.interact(player, this, attackDir);
	}
	
	public function use(player:Player, attackDir:Int):Bool
	{
		return false;
	}
	
	public function getLightRadius():Int
	{
		return 0;
	}
	
	
	
}