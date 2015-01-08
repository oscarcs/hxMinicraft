package gfx;

import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import flixel.FlxSprite;

class SpriteSheet
{
	var sprite:FlxSprite;
	
	public var pixels:Array<Int> = [];
	public var width:Int;
	public var height:Int;
	
	private var possibleColors:Array<Int> = [];
	
	public function new() 
	{
		sprite = new FlxSprite(0, 0);
		sprite.loadGraphic("assets/res/icons.png");
		
		width = Std.int(sprite.width);
		height = Std.int(sprite.height);
		
		pixels = [];
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				var cur:Int = sprite.pixels.getPixel(x, y);
				var curInPossible:Bool = false;
				for (i in 0...possibleColors.length)
				{
					if (possibleColors[i] == cur) curInPossible = true;
				}
				if (!curInPossible && cur != 0xD67FFF && cur != 0x6B3F7F) possibleColors.push(cur);
			}
		}
		
		possibleColors.sort(function(a:Int, b:Int):Int
		{   
			if (a == b) return 0;
			if (a > b) return 1;
			else return -1;
		});
		//trace(possibleColors);
		
		var index:Int = 0;
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				var cur:Int = sprite.pixels.getPixel(x, y);
				index ++;
				if (cur == possibleColors[0]) pixels[index] = 0;
				else if (cur == possibleColors[1]) pixels[index] = 1;
				else if (cur == possibleColors[2]) pixels[index] = 2;
				else if (cur == possibleColors[3]) pixels[index] = 3;
				else { pixels[index] = 0; }
			}
		}
	}
	
}