package level.levelgen;

//import java.awt.Image;
//import java.awt.image.BufferedImage;
//import java.util.Random;

//import javax.swing.ImageIcon;
//import javax.swing.JOptionPane;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import level.tile.Tile;
import level.tile.StaticTile;

class LevelGen
{
	private static var random:Random = new Random();
	public var values:Array<Float>;
	private var w:Int;
	private var h:Int;

	public function new (w:Int, h:Int, featureSize:Int)
	{
		this.w = w;
		this.h = h;

		values = [];

		/*
		for (int y = 0; y < w; y += featureSize) {
			for (int x = 0; x < w; x += featureSize) {
				setSample(x, y, random.nextFloat() * 2 - 1);
			}
		}
		*/
		
		//sic y amd w
		var y:Int = 0;
		while (y < w)
		{
			var x:Int = 0;
			while (x < w)
			{
				setSample(x, y, random.nextFloat() * 2 - 1);
				x += featureSize;
			}
			y += featureSize;
		}

		var stepSize:Int = featureSize;
		var scale:Float = 1.0 / w;
		var scaleMod:Float = 1;
		while (stepSize > 1)
		{
			var halfStep:Int = Std.int(stepSize / 2);
			//for (int y = 0; y < w; y += stepSize)
			var y:Int = 0;
			while (y < w)
			{
				//for (int x = 0; x < w; x += stepSize)
				var x:Int = 0;
				while (x < w)
				{
					var a:Float = sample(x, y);
					var b:Float = sample(x + stepSize, y);
					var c:Float = sample(x, y + stepSize);
					var d:Float = sample(x + stepSize, y + stepSize);

					var e:Float = (a + b + c + d) / 4.0 + (random.nextFloat() * 2 - 1) * stepSize * scale;
					setSample(x + halfStep, y + halfStep, e);
					
					x += stepSize;
				}
				y += stepSize;
			}
			//for (int y = 0; y < w; y += stepSize)
			var y:Int = 0;
			while (y < w)
			{
				//for (int x = 0; x < w; x += stepSize)
				var x:Int = 0;
				while (x < w)
				{
					var a:Float = sample(x, y);
					var b:Float = sample(x + stepSize, y);
					var c:Float = sample(x, y + stepSize);
					var d:Float = sample(x + halfStep, y + halfStep);
					var e:Float = sample(x + halfStep, y - halfStep);
					var f:Float = sample(x - halfStep, y + halfStep);
                    
					var H:Float = (a + b + d + e) / 4.0 + (random.nextFloat() * 2 - 1) * stepSize * scale * 0.5;
					var g:Float = (a + c + d + f) / 4.0 + (random.nextFloat() * 2 - 1) * stepSize * scale * 0.5;
					setSample(x + halfStep, y, H);
					setSample(x, y + halfStep, g);
					
					x += stepSize;
				}
				y += stepSize;
			}
			stepSize = Std.int(stepSize / 2);
			//trace(stepSize);
			scale *= (scaleMod + 0.8);
			scaleMod *= 0.3;
		}
		//trace('ended');
	}

	private function sample(x:Int, y:Int):Float
	{
		return values[(x & (w - 1)) + (y & (h - 1)) * w];
	}

	private function setSample(x:Int, y:Int, value:Float):Void
	{
		values[(x & (w - 1)) + (y & (h - 1)) * w] = value;
	}

	public static function createAndValidateTopMap(w:Int, h:Int):Array<Array<Int>>
	{
		var attempt:Int = 0;
		do
		{
			var result:Array<Array<Int>> = createTopMap(w, h);

			var count:Array<Int> = [for(i in 0...50) 0];

			for (i in 0...(w * h))
			{
				count[result[0][i] & 0xff] += 1;
			}
			if (count[StaticTile.rock.id & 0xff] < 100) continue;
			if (count[StaticTile.sand.id & 0xff] < 100) continue;
			if (count[StaticTile.grass.id & 0xff] < 100) continue;
			if (count[StaticTile.tree.id & 0xff] < 100) continue;
			if (count[StaticTile.stairsDown.id & 0xff] < 2) continue;
				
			//displayDebug(w, h, result);
			return result;
		}
		while (true);
	}

	
	public static function createAndValidateUndergroundMap(w:Int, h:Int, depth:Int):Array<Array<Int>>
	{
		var attempt:Int = 0;
		do
		{
			var result:Array<Array<Int>> = createUndergroundMap(w, h, depth);

			var count:Array<Int> = [for(i in 0...50) 0];

			for (i in 0...(w * h))
			{
				count[result[0][i] & 0xff]++;
			}
			if (count[StaticTile.rock.id & 0xff] < 100) continue;
			if (count[StaticTile.dirt.id & 0xff] < 100) continue;
			if (count[(StaticTile.ironOre.id & 0xff) + depth - 1] < 20) continue;
			if (depth < 3) if (count[StaticTile.stairsDown.id & 0xff] < 2) continue;

			//displayDebug(w, h, result);
			return result;

		} while (true);
	}

	public static function createAndValidateSkyMap(w:Int, h:Int):Array<Array<Int>>
	{
		var attempt:Int = 0;
		do {
			var result:Array<Array<Int>> = createSkyMap(w, h);

			var count:Array<Int> = [for(i in 0...50) 0];

			for (i in 0...(w * h))
			{
				count[result[0][i] & 0xff] += 1;
			}
			if (count[StaticTile.cloud.id & 0xff] < 2000) continue;
			if (count[StaticTile.stairsDown.id & 0xff] < 2) continue;

			//displayDebug(w, h, result);
			return result;

		} while (true);
	}
	

	private static function createTopMap(w:Int, h:Int):Array<Array<Int>>
	{
		var mnoise1:LevelGen = new LevelGen(w, h, 16);
		var mnoise2:LevelGen = new LevelGen(w, h, 16);
		var mnoise3:LevelGen = new LevelGen(w, h, 16);
        
		var noise1:LevelGen = new LevelGen(w, h, 32);
		var noise2:LevelGen = new LevelGen(w, h, 32);

		//byte[] map = new byte[w * h];
		//byte[] data = new byte[w * h];
		var map:Array<Int> = [];
		var data:Array<Int> = [];
		
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var i:Int = x + y * w;

				var val:Float = Math.abs(noise1.values[i] - noise2.values[i]) * 3 - 2;
				var mval:Float = Math.abs(mnoise1.values[i] - mnoise2.values[i]);
				mval = Math.abs(mval - mnoise3.values[i]) * 3 - 2;

				var xd:Float = x / (w - 1.0) * 2 - 1;
				var yd:Float = y / (h - 1.0) * 2 - 1;
				if (xd < 0) xd = -xd;
				if (yd < 0) yd = -yd;
				var dist:Float = xd >= yd ? xd : yd;
				dist = dist * dist * dist * dist;
				dist = dist * dist * dist * dist;
				val = val + 1 - dist * 20;

				if (val < -0.5)
				{
					map[i] = StaticTile.water.id;
				}
				else if (val > 0.5 && mval < -1.5)
				{
					map[i] = StaticTile.rock.id;
				}
				else
				{
					map[i] = StaticTile.grass.id;
				}
			}
		}

		for (i in 0...Std.int(w * h / 2800))
		{
			var xs:Int = random.nextInt(w);
			var ys:Int = random.nextInt(h);
			for (k in 0...10)
			{
				var x:Int = xs + random.nextInt(21) - 10;
				var y:Int = ys + random.nextInt(21) - 10;
				for (j in 0...100)
				{
					var xo:Int = x + random.nextInt(5) - random.nextInt(5);
					var yo:Int = y + random.nextInt(5) - random.nextInt(5);
					for (yy in Std.int(Math.abs(yo - 1))...Std.int(Math.abs(yo + 2)))
					{
						for (xx in (xo - 1)...(xo + 2))
						{
							if (xx >= 0 && yy >= 0 && xx < w && yy < h)
							{
								if (map[xx + yy * w] == StaticTile.grass.id)
								{
									map[xx + yy * w] = StaticTile.sand.id;
								}
							}
						}
					}
				}
			}
		}

		/*
		 * for (int i = 0; i < w * h / 2800; i++) { int xs = random.nextInt(w); int ys = random.nextInt(h); for (int k = 0; k < 10; k++) { int x = xs + random.nextInt(21) - 10; int y = ys + random.nextInt(21) - 10; for (int j = 0; j < 100; j++) { int xo = x + random.nextInt(5) - random.nextInt(5); int yo = y + random.nextInt(5) - random.nextInt(5); for (int yy = yo - 1; yy <= yo + 1; yy++) for (int xx = xo - 1; xx <= xo + 1; xx++) if (xx >= 0 && yy >= 0 && xx < w && yy < h) { if (map[xx + yy * w] == Tile.grass.id) { map[xx + yy * w] = Tile.dirt.id; } } } } }
		 */

		for (i in 0...Std.int(w * h / 400))
		{
			var x:Int = random.nextInt(w);
			var y:Int = random.nextInt(h);
			for (j in 0...200)
			{
				var xx:Int = x + random.nextInt(15) - random.nextInt(15);
				var yy:Int = y + random.nextInt(15) - random.nextInt(15);
				if (xx >= 0 && yy >= 0 && xx < w && yy < h)
				{
					if (map[xx + yy * w] == StaticTile.grass.id)
					{
						map[xx + yy * w] = StaticTile.tree.id;
					}
				}
			}
		}

		for (i in 0...Std.int(w * h / 400))
		{
			var x:Int = random.nextInt(w);
			var y:Int = random.nextInt(h);
			var col:Int = random.nextInt(4);
			for (j in 0...30)
			{
				var xx:Int = x + random.nextInt(5) - random.nextInt(5);
				var yy:Int = y + random.nextInt(5) - random.nextInt(5);
				if (xx >= 0 && yy >= 0 && xx < w && yy < h)
				{
					if (map[xx + yy * w] == StaticTile.grass.id)
					{
						map[xx + yy * w] = StaticTile.flower.id;
						data[xx + yy * w] = Std.int((col + random.nextInt(4) * 16));
					}
				}
			}
		}

		for (i in 0...Std.int(w * h / 100))
		{
			var xx:Int = random.nextInt(w);
			var yy:Int = random.nextInt(h);
			if (xx >= 0 && yy >= 0 && xx < w && yy < h)
			{
				if (map[xx + yy * w] == StaticTile.sand.id)
				{
					map[xx + yy * w] = StaticTile.cactus.id;
				}
			}
		}

		var count:Int = 0;
		/*
		stairsLoop: for (int i = 0; i < w * h / 100; i++)
		{
			int x = random.nextInt(w - 2) + 1;
			int y = random.nextInt(h - 2) + 1;

			for (int yy = y - 1; yy <= y + 1; yy++)
				for (int xx = x - 1; xx <= x + 1; xx++) {
					if (map[xx + yy * w] != Tile.rock.id) continue stairsLoop;
				}

			map[x + y * w] = Tile.stairsDown.id;
			count++;
			if (count == 4) break;
		}
		*/
		var breakLoop:Bool = false;
		for (i in 0...Std.int(w * h / 100))
		{
			var x:Int = random.nextInt(w - 2) + 1;
			var y:Int = random.nextInt(h - 2) + 1;

			for (yy in (y - 1)...(y + 2))
			{
				for (xx in (x - 1)...(x + 2))
				{
					if (map[xx + yy * w] == StaticTile.rock.id)
					{
						breakLoop = true;
						break;
					}
				}
				if (breakLoop) break;
			}
			if (breakLoop) break;

			map[x + y * w] = StaticTile.stairsDown.id;
			count++;
			if (count == 4) break;
		}

		return [map, data];
	}
	
	private static function createUndergroundMap(w:Int, h:Int, depth:Int):Array<Array<Int>>
	{
		var mnoise1:LevelGen = new LevelGen(w, h, 16);
		var mnoise2:LevelGen = new LevelGen(w, h, 16);
		var mnoise3:LevelGen = new LevelGen(w, h, 16);
		
		var nnoise1:LevelGen = new LevelGen(w, h, 16);
		var nnoise2:LevelGen = new LevelGen(w, h, 16);
		var nnoise3:LevelGen = new LevelGen(w, h, 16);
               
		var wnoise1:LevelGen = new LevelGen(w, h, 16);
		var wnoise2:LevelGen = new LevelGen(w, h, 16);
		var wnoise3:LevelGen = new LevelGen(w, h, 16);
              
		var noise1:LevelGen= new LevelGen(w, h, 32);
		var noise2:LevelGen= new LevelGen(w, h, 32);

		var map:Array<Int> = [];
		var data:Array<Int> = [];
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var i:Int = x + y * w;

				var val:Float = Math.abs(noise1.values[i] - noise2.values[i]) * 3 - 2;

				var mval:Float = Math.abs(mnoise1.values[i] - mnoise2.values[i]);
				mval = Math.abs(mval - mnoise3.values[i]) * 3 - 2;

				var nval:Float = Math.abs(nnoise1.values[i] - nnoise2.values[i]);
				nval = Math.abs(nval - nnoise3.values[i]) * 3 - 2;

				var wval:Float = Math.abs(wnoise1.values[i] - wnoise2.values[i]);
				wval = Math.abs(nval - wnoise3.values[i]) * 3 - 2;

				var xd:Float = x / (w - 1.0) * 2 - 1;
				var yd:Float = y / (h - 1.0) * 2 - 1;
				if (xd < 0) xd = -xd;
				if (yd < 0) yd = -yd;
				var dist:Float = xd >= yd ? xd : yd;
				dist = dist * dist * dist * dist;
				dist = dist * dist * dist * dist;
				val = val + 1 - dist * 20;

				if (val > -2 && wval < -2.0 + (depth) / 2 * 3)
				{
					if (depth > 2)
					{
						map[i] = StaticTile.lava.id;
					}
					else
					{
						map[i] = StaticTile.water.id;
					}
				}
				else if (val > -2 && (mval < -1.7 || nval < -1.4))
				{
					map[i] = StaticTile.dirt.id;
				}
				else
				{
					map[i] = StaticTile.rock.id;
				}
			}
		}

		{
			var r:Int = 2;
			for (i in 0...Std.int(w * h / 400))
			{
				var x:Int = random.nextInt(w);
				var y:Int = random.nextInt(h);
				for (j in 0...30)
				{
					var xx:Int = x + random.nextInt(5) - random.nextInt(5);
					var yy:Int = y + random.nextInt(5) - random.nextInt(5);
					if (xx >= r && yy >= r && xx < w - r && yy < h - r)
					{
						if (map[xx + yy * w] == StaticTile.rock.id)
						{
							map[xx + yy * w] = (StaticTile.ironOre.id & 0xff) + depth - 1;
						}
					}
				}
			}
		}

		if (depth < 3)
		{
			var breakLoop:Bool = false;
			var count:Int = 0;
			for (i in 0...Std.int(w * h / 100))
			{
				var x:Int = random.nextInt(w - 20) + 10;
				var y:Int = random.nextInt(h - 20) + 10;

				for (yy in (y - 1)...(y + 2))
				{
					for (xx in (x - 1)...(x + 2))
					{
						if (map[xx + yy * w] == StaticTile.rock.id)
						{
							breakLoop = true;
							break;
						}
					}
					if (breakLoop) break;
				}
				if (breakLoop) break;

				map[x + y * w] = StaticTile.stairsDown.id;
				count++;
				if (count == 4) break;
			}
		}

		return [map, data];
	}

	private static function createSkyMap(w:Int, h:Int):Array<Array<Int>>
	{
		var noise1:LevelGen = new LevelGen(w, h, 8);
		var noise2:LevelGen = new LevelGen(w, h, 8);

		var map:Array<Int> = [];
		var data:Array<Int> = [];
		for (y in 0...h)
		{
			for (x in 0...w)
			{
				var i:Int = x + y * w;

				var val:Float = Math.abs(noise1.values[i] - noise2.values[i]) * 3 - 2;

				var xd:Float = x / (w - 1.0) * 2 - 1;
				var yd:Float = y / (h - 1.0) * 2 - 1;
				if (xd < 0) xd = -xd;
				if (yd < 0) yd = -yd;
				var dist:Float = xd >= yd ? xd : yd;
				dist = dist * dist * dist * dist;
				dist = dist * dist * dist * dist;
				val = -val * 1 - 2.2;
				val = val + 1 - dist * 20;

				if (val < -0.25)
				{
					map[i] = StaticTile.infiniteFall.id;
				}
				else
				{
					map[i] = StaticTile.cloud.id;
				}
			}
		}

		var breakLoop:Bool = false;
		for (i in 0...Std.int(w * h / 50))
		{
			var x:Int = random.nextInt(w - 2) + 1;
			var y:Int = random.nextInt(h - 2) + 1;

			for (yy in (y - 1)...(y + 2))
			{
				for (xx in (x - 1)...(x + 2))
				{
					if (map[xx + yy * w] == StaticTile.cloud.id)
					{
						breakLoop = true;
						break;
					}
	
				}
				if (breakLoop) break;
			}
			if (breakLoop) break;
			map[x + y * w] = StaticTile.cloudCactus.id;
		}

		var breakLoop:Bool = false;
		var count:Int = 0;
		for (i in 0...(w * h))
		{
			var x:Int = random.nextInt(w - 2) + 1;
			var y:Int = random.nextInt(h - 2) + 1;

			for (yy in (y - 1)...(y + 2))
			{
				for (xx in (x - 1)...(x + 2))
				{
					if (map[xx + yy * w] == StaticTile.cloud.id)
					{
						breakLoop = true;
						break;
					}
				}
				if (breakLoop) break;
			}

			if (breakLoop) break;
			
			map[x + y * w] = StaticTile.stairsDown.id;
			count++;
			if (count == 2) break;
		}

		return [map, data];
	}
	
	private static function displayDebug(w:Int, h:Int, result:Array<Array<Int>>):Void
	{
		var test:FlxSprite = new FlxSprite(32, 32);
		test.makeGraphic(w, h, FlxColor.WHITE);
		FlxG.state.add(test);
		
		var colors:Array<Int> = [FlxColor.GREEN, FlxColor.GRAY, FlxColor.BLUE, FlxColor.PINK,
		FlxColor.FOREST_GREEN, FlxColor.BROWN, FlxColor.WHEAT,
		FlxColor.TAN, FlxColor.BLACK, FlxColor.FOREST_GREEN,
		FlxColor.TAN, FlxColor.BROWN, FlxColor.TAN, FlxColor.RED,
		FlxColor.GRAY, FlxColor.GRAY, FlxColor.BLACK, FlxColor.WHITE,
		FlxColor.CHARCOAL, FlxColor.BEIGE, FlxColor.YELLOW,
		FlxColor.GREEN, FlxColor.GRAY];
		
		for (i in 0...(w * h))
		{
			if (colors[result[0][i]] != -1)
			{
				test.framePixels.setPixel(Std.int(i % w), Std.int(i / w), colors[result[0][i]]);
			}
			else
			{
				test.framePixels.setPixel(Std.int(i % w), Std.int(i / w), FlxColor.WHITE);
			}
		}
	}
}