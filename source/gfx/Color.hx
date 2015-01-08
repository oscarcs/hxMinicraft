package gfx;

class Color
{
	public static function get(a:Int, b:Int, c:Int, d:Int):Int
	{
		return (get2(d) << 24) + (get2(c) << 16) + (get2(b) << 8) + (get2(a));
	}
	
	public static function get2(d:Int):Int
	{
		if (d < 0)
		{
			return 255;
		}
		
		var r = Std.int((d / 100) % 10);
		var g = Std.int((d / 10) % 10);
		var b = d % 10;
		return (r * 36) + (g * 6) + b;
	}
}