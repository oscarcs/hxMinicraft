package gfx;
import flixel.FlxG;

class Screen
{
	public var xOffset:Int = 0;
	public var yOffset:Int = 0;
	
	public static var BIT_MIRROR_X:Int = 0x01;
	public static var BIT_MIRROR_Y:Int = 0x02;
	
	public var w:Int;
	public var h:Int;
	public var pixels:Array<Int> = [];
	
	private var sheet:SpriteSheet;
	
	//optimization?
	//private var preloadedTiles:Array<Array<Int>> = [][];
	
	public function new(w:Int, h:Int, sheet:SpriteSheet) 
	{
		this.sheet = sheet;
		this.w = w;
		this.h = h;
		
		pixels = [for (i in 0...(w * h)) 0];
	}
	
	public function clear(color:Int):Void
	{
		pixels = [];
		for (i in 0...(w * h))
		{
			pixels[i] = color;
		}
	}
	
	public function render(xp:Int, yp:Int, tile:Int, colors:Int, bits:Int):Void
	{
		xp -= xOffset;
		yp -= yOffset;
		var mirrorX:Bool = (bits & BIT_MIRROR_X) > 0;
		var mirrorY:Bool = (bits & BIT_MIRROR_Y) > 0;
		
		var xTile:Int = tile % 32;
		var yTile:Int = Math.floor(tile / 32);
		var toffs:Int = Math.floor(xTile * 8 + yTile * 8 * sheet.width + 1);
		
		for (y in 0...8)
		{
			var ys:Int = y;
			if (mirrorY) ys = 7 - y;
			if (y + yp < 0 || y + yp >= h) continue;
			
			for (x in 0...8)
			{
				if (x + xp < 0 || x + xp >= w) continue;

				var xs:Int = x;
				if (mirrorX) xs = 7 - x;
				var col:Int = (colors >> (sheet.pixels[xs + ys * sheet.width + toffs] * 8)) & 255;
				
				if (col < 255)
				{
					pixels[(x + xp) + (y + yp) * w] = col;
				}
			}
		}
	}
	
	public function setOffset(xOffset:Int, yOffset:Int):Void
	{
		this.xOffset = xOffset;
		this.yOffset = yOffset;
	}
	
	private var dither:Array<Int> = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5];
	
	public function overlay(screen2:Screen, xa:Int, ya:Int):Void
	{
		var oPixels:Array<Int> = screen2.pixels;
		var i:Int = 0;
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				if (oPixels[i] / 10 <= dither[((x + xa) & 3) + ((y + ya) & 3) * 4]) pixels[i] = 0;
				i++;
			}
		}
	}
	
	public function renderLight(x:Int, y:Int, r:Int):Void
	{
		x -= xOffset;
		y -= yOffset;
		var x0:Int = x - r;
		var x1:Int = x + r;
		var y0:Int = y - r;
		var y1:Int = y + r;
		
		if (x0 < 0) x0 = 0;
		if (y0 < 0) y0 = 0;
		if (x1 > w) x1 = w;
		if (y1 > h) y1 = h;
		// System.out.println(x0 + ", " + x1 + " -> " + y0 + ", " + y1);
		for (yy in y0...y1)
		{
			var yd:Int = yy - y;
			yd = yd * yd;
			for (xx in x0...x1)
			{
				var xd:Int = xx - x;
				var dist:Int = xd * xd + yd;
				// System.out.println(dist);
				if (dist <= r * r)
				{
					var br:Int = Std.int(255 - dist * 255 / (r * r));
					if (pixels[xx + yy * w] < br) pixels[xx + yy * w] = br;
				}
			}
		}
		
	}
}