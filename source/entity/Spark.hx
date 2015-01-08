package entity;

//import java.util.List;

import gfx.Color;
import gfx.Screen;

class Spark extends Entity
{
	private var lifeTime:Int;
	public var ya:Float;
	public var xa:Float;
	public var xx:Float;
	public var yy:Float;
	private var time:Int;
	private var owner:AirWizard;

	override public function new(owner:AirWizard, xa:Float, ya:Float)
	{
		super();
		
		this.owner = owner;
		xx = this.x = owner.x;
		yy = this.y = owner.y;
		xr = 0;
		yr = 0;

		this.xa = xa;
		this.ya = ya;

		lifeTime = 60 * 10 + random.nextInt(30);
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
		x = Std.int(xx);
		y = Std.int(yy);
		var toHit:Array<Entity> = level.getEntities(x, y, x, y);
		for (i in 0...toHit.length)
		{
			var e:Entity = toHit[i];
			if (Std.is(e, Mob) && !(Std.is(e, AirWizard)))
			{
				var unsafeCast:Mob = cast e;
				e.hurt(owner, 1, unsafeCast.dir ^ 1);
			}
		}
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

		var xt:Int = 8;
		var yt:Int = 13;

		screen.render(x - 4, y - 4 - 2, xt + yt * 32, Color.get(-1, 555, 555, 555), random.nextInt(4));
		screen.render(x - 4, y - 4 + 2, xt + yt * 32, Color.get(-1, 000, 000, 000), random.nextInt(4));
	}
}
