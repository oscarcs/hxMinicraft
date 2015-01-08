package entity;

import entity.particle.TextParticle;
import gfx.Color;
import level.Level;
import level.tile.Tile;
import level.tile.StaticTile;
//import sound.Sound;

class Mob extends Entity
{
	public var walkDist:Int = 0;
	public var dir:Int = 0;
	public var hurtTime:Int = 0;
	public var xKnockback:Int;
	public var yKnockback:Int;
	public var maxHealth:Int = 10;
	public var health:Int;
	public var swimTimer:Int = 0;
	public var tickTime:Int = 0;
	
	public function new() 
	{
		super();
		health = maxHealth;
		
		x = y = 8;
		xr = 4;
		yr = 3;
	}
	
	override public function tick():Void
	{
		tickTime++;
		
		if (level.getTile(x >> 4, y >> 4) == StaticTile.lava)
		{
			hurt(this, 4, dir ^ 1);
		}

		if (health <= 0)
		{
			die();
		}
		
		if (hurtTime > 0) hurtTime--;
	}
	
	private function die():Void
	{
		remove();
	}
	
	override public function move(xa:Int, ya:Int):Bool
	{
		if (isSwimming())
		{
			if (swimTimer++ % 2 == 0) return true;
		}
		if (xKnockback < 0)
		{
			move2(-1, 0);
			xKnockback++;
		}
		if (xKnockback > 0)
		{
			move2(1, 0);
			xKnockback--;
		}
		if (yKnockback < 0)
		{
			move2(0, -1);
			yKnockback++;
		}
		if (yKnockback > 0)
		{
			move2(0, 1);
			yKnockback--;
		}
		if (hurtTime > 0) return true;
		if (xa != 0 || ya != 0)
		{
			walkDist++;
			if (xa < 0) dir = 2;
			if (xa > 0) dir = 3;
			if (ya < 0) dir = 1;
			if (ya > 0) dir = 0;
		}
		return super.move(xa, ya);
	}
	
	private function isSwimming():Bool
	{
		var tile:Tile = level.getTile(x >> 4, y >> 4);
		return tile == StaticTile.water || tile == StaticTile.lava;
	}
	
	override public function blocks(e:Entity):Bool
	{
		return e.isBlockableBy(this);
	}

	
	//I resent Java's method overloading.
	//Mankind's fithiest hack candidate 2015:
	override public function hurt(tile_or_mob:Dynamic, x_or_dmg:Int, y_or_attackDir:Int, ?dmg:Int):Void
	{
		var damage:Int = x_or_dmg;
		var attackDir:Int = y_or_attackDir;

		if (Std.is(tile_or_mob, Tile)) attackDir= dir ^ 1;
		if (dmg != null) damage = dmg;
		doHurt(damage, attackDir);
	}
	
	public function heal(heal:Int):Void
	{
		if (hurtTime > 0) return;

		level.add(new TextParticle("" + heal, x, y, Color.get(-1, 50, 50, 50)));
		health += heal;
		if (health > maxHealth) health = maxHealth;	
	}
	
	private function doHurt(damage:Int, attackDir:Int):Void
	{
		if (hurtTime > 0) return;

		if (level.player != null)
		{
			var xd:Int = level.player.x - x;
			var yd:Int = level.player.y - y;
			if (xd * xd + yd * yd < 80 * 80)
			{
				//Sound.monsterHurt.play();
			}
		}
		level.add(new TextParticle("" + damage, x, y, Color.get(-1, 500, 500, 500)));
		health -= damage;
		if (attackDir == 0) yKnockback = 6;
		if (attackDir == 1) yKnockback = -6;
		if (attackDir == 2) xKnockback = -6;
		if (attackDir == 3) xKnockback = 6;
		hurtTime = 10;	
	}
	
	public function findStartPos(level:Level):Bool
	{
		var x:Int = random.nextInt(level.w);
		var y:Int = random.nextInt(level.h);
		var xx:Int = x * 16 + 8;
		var yy:Int = y * 16 + 8;
		
		if (level.player != null)
		{
			var xd:Int = level.player.x - xx;
			var yd:Int = level.player.y - yy;
			if (xd * xd + yd * yd < 80 * 80) return false;
		}
		
		var r:Int = level.monsterDensity * 16;
		if (level.getEntities(xx - r, yy - r, xx + r, yy + r).length > 0) return false;
		
		if (level.getTile(x, y).mayPass(level, x, y, this))
		{
			this.x = xx;
			this.y = yy;
			return true;
		}

		return false;
	}
	
	
}