package entity.particle;

import entity.Entity;
import gfx.Color;
import gfx.Font;
import gfx.Screen;

class TextParticle extends Entity
{
	private var msg:String;
	private var col:Int;
	private var time:Int = 0;
	public var xa:Float;
	public var ya:Float;
	public var za:Float;
	public var xx:Float;
	public var yy:Float;
	public var zz:Float;
	
	override public function new(msg:String, x:Int, y:Int, col:Int) 
	{
		super();
		this.msg = msg;
		this.x = x;
		this.y = y;
		this.col = col;
		xx = x;
		yy = y;
		zz = 2;
		xa = random.nextGaussian() * 0.3;
		ya = random.nextGaussian() * 0.2;
		za = random.nextFloat() * 0.7 + 2;
	}
	
	override public function tick():Void
	{
		time++;
		if (time > 60)
		{
			remove();
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
		x = Std.int(xx);
		y = Std.int(yy);
		
	}
	
	override public function render(screen:Screen):Void
	{
		//Font.draw(msg, screen, x - msg.length() * 4, y, Color.get(-1, 0, 0, 0));
		Font.draw(msg, screen, x - msg.length * 4 + 1, y - Std.int(zz) + 1, Color.get(-1, 0, 0, 0));
		Font.draw(msg, screen, x - msg.length * 4, y - Std.int(zz), col);
	}
	
}