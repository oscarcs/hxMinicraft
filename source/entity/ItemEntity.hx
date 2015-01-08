package entity;

import Random;
import gfx.Color;
import gfx.Screen;
import item.Item;
//import sound.Sound;

class ItemEntity extends Entity
{
	private var lifeTime:Int;
	private var walkDist:Int = 0;
	private var dir:Int = 0;
	public var hurtTime:Int = 0;
	private var xKnockback:Int;
	private var yKnockback:Int;
	public var xa:Float;
	public var ya:Float;
	public var za:Float;
	public var xx:Float;
	public var yy:Float;
	public var zz:Float;
	public var item:Item;
	private var time:Int = 0;

	public function new(item:Item, x:Int, y:Int) 
	{
		super();
		
		this.item = item;
		xx = this.x = x;
		yy = this.y = y;
		xr = 3;
		yr = 3;
		
		zz = 2;
		xa = random.nextGaussian() * 0.3;
		ya = random.nextGaussian() * 0.3;
		za = random.nextFloat() * 0.7 + 1;
		
		lifeTime = 60 * 10 + random.nextInt(60);
	}
	
	override public function tick():Void
	{
		time++;
		if (time >= lifeTime)
		{
			remove();
			return;
		}
		xx += xa;
		yy += ya;
		zz += za;
		if (zz < 0)
		{
			zz = 0;
			za *= -0.5;
			xa *= 0.6;
			ya *= 0.6;
		}
		za -= 0.15;
		var ox:Int = x;
		var oy:Int = y;
		var nx:Int = Std.int(xx);
		var ny:Int = Std.int(yy);
		var expectedx:Int = nx - x;
		var expectedy:Int = ny - y;
		move(nx - x, ny - y);
		var gotx:Int = x - ox;
		var goty:Int = y - oy;
		xx += gotx - expectedx;
		yy += goty - expectedy;

		if (hurtTime > 0) hurtTime--;
	}
	
	override public function isBlockableBy(mob:Mob):Bool
	{
		return false;
	}
	
	override public function render(screen:Screen):Void
	{
		if (time >= lifeTime - 6 * 20)
		{
			if (time / 6 % 2 == 0) return;
		}
		screen.render(x - 4, y - 4, item.getSprite(), Color.get(-1, 0, 0, 0), 0);
		screen.render(x - 4, y - 4 - Std.int(zz), item.getSprite(), item.getColor(), 0);
	}
	
	override public function touchedBy(entity:Entity):Void
	{
		if (time > 30) entity.touchItem(this);
	}
	
	public function take(player:Player):Void
	{
		//Sound.pickup.play();
		player.score++;
		item.onTake(this);
		remove();
	}
	
	
}