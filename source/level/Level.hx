package level;

import entity.Entity;
import entity.Mob;
import entity.Player;
import entity.Zombie;
import entity.Slime;
import flixel.FlxG;
import flixel.text.FlxText;
import gfx.Screen;
import level.levelgen.LevelGen;
import level.tile.Tile;
import level.tile.StaticTile;
import entity.AirWizard;

class Level
{
	private var random:Random = new Random();
	
	public var w:Int;
	public var h:Int;
	public var tiles:Array<Int>;
	public var data:Array<Int>;
	public var entitiesInTiles:Array<Array<Entity>>;
	
	public var grassColor:Int = 141;
	public var dirtColor:Int = 322;
	public var sandColor:Int = 550;
	private var depth:Int;
	public var monsterDensity:Int = 8;
	
	public var entities:Array<Entity> = [];
	
	
	private var rowSprites:Array<Entity> = [];
	public var player:Player;
	
	//private spriteSorter
	
	public function new(w:Int, h:Int, levelno:Int, parentLevel:Level)
	{			
		if (levelno < 0)
		{
			dirtColor = 222;
		}
		this.depth = levelno;
		this.w = w;
		this.h = h;
		var maps:Array<Array<Int>>;
		
		if (levelno == 1)
		{
			dirtColor = 444;
		}
		
		if (levelno == 0)
		{
			//maps = CreateMap.createAndValidateTopMap(w, h);
			maps = LevelGen.createAndValidateTopMap(w, h);
			//maps = [for (y in 0...h) [for (x in 0...w) 0]];
		}
		else if (levelno < 0)
		{
			maps = LevelGen.createAndValidateUndergroundMap(w, h, -levelno);
			//maps = [for (y in 0...h) [for (x in 0...w) 0]];
			monsterDensity = 4;
		}
		else
		{
			maps = LevelGen.createAndValidateSkyMap(w, h);
			//maps = [for (y in 0...h) [for (x in 0...w) 0]];
			monsterDensity = 4;
		}
		
		tiles = maps[0];
		data = maps[1];
		
		if (parentLevel != null)
		{
			for (y in 0...h)
			{
				for (x in 0...w)
				{
					if (parentLevel.getTile(x, y) == StaticTile.stairsDown)
					{
						setTile(x, y, StaticTile.stairsUp, 0);
						if (levelno == 0)
						{
							setTile(x - 1, y, StaticTile.hardRock, 0);
							setTile(x + 1, y, StaticTile.hardRock, 0);
							setTile(x, y - 1, StaticTile.hardRock, 0);
							setTile(x, y + 1, StaticTile.hardRock, 0);
							setTile(x - 1, y - 1, StaticTile.hardRock, 0);
							setTile(x - 1, y + 1, StaticTile.hardRock, 0);
							setTile(x + 1, y - 1, StaticTile.hardRock, 0);
							setTile(x + 1, y + 1, StaticTile.hardRock, 0);
						}
						else
						{
							setTile(x - 1, y, StaticTile.dirt, 0);
							setTile(x + 1, y, StaticTile.dirt, 0);
							setTile(x, y - 1, StaticTile.dirt, 0);
							setTile(x, y + 1, StaticTile.dirt, 0);
							setTile(x - 1, y - 1, StaticTile.dirt, 0);
							setTile(x - 1, y + 1, StaticTile.dirt, 0);
							setTile(x + 1, y - 1, StaticTile.dirt, 0);
							setTile(x + 1, y + 1, StaticTile.dirt, 0);
						}
					}
				}
			}
		}
		
		entitiesInTiles = [[]];
		for (i in 0...(w * h))
		{
			entitiesInTiles[i] = [];
		}
		
		//entitiesInTiles = [for (x in 0...w) [for (y in 0...h) null]];
		
		if (levelno == 1)
		{
			var aw:AirWizard = new AirWizard();
			aw.x = w * 8;
			aw.y = h * 8;
			add(aw);
		}
	}
	
	public function renderBackground(screen:Screen, xScroll:Int, yScroll:Int):Void
	{
		var xo:Int = xScroll >> 4;
		var yo:Int = yScroll >> 4;
		var w:Int = (screen.w + 15) >> 4;
		var h:Int = (screen.h + 15) >> 4;
		screen.setOffset(xScroll, yScroll);
		for (y in yo...(h + yo + 1))
		{
			for (x in xo...(w + xo + 1))
			{
				getTile(x, y).render(screen, this, x, y);
			}
		}
		screen.setOffset(0, 0);
	}
	
	public function renderSprites(screen:Screen, xScroll:Int, yScroll:Int):Void 
	{
		var xo:Int = xScroll >> 4;
		var yo:Int = yScroll >> 4;
		var w:Int = (screen.w + 15) >> 4;
		var h:Int = (screen.h + 15) >> 4;
		
		screen.setOffset(xScroll, yScroll);
		for (y in yo...(h + yo + 1))
		{
			for (x in xo...(w + xo + 1))
			{
				if (x < 0 || y < 0 || x >= this.w || y >= this.h) continue;
				rowSprites = rowSprites.concat(entitiesInTiles[x + y * this.w]);
			}
			if (rowSprites.length > 0)
			{
				sortAndRender(screen, rowSprites);
			}
			rowSprites = [];
		}
		screen.setOffset(0, 0);
	}
	
	public function renderLight(screen:Screen, xScroll:Int, yScroll:Int):Void
	{
		var xo:Int = xScroll >> 4;
		var yo:Int = yScroll >> 4;
		var w:Int = (screen.w + 15) >> 4;
		var h:Int = (screen.h + 15) >> 4;
		
		screen.setOffset(xScroll, yScroll);
		var r:Int = 4;
		for (y in (yo - r)...(h + yo + r + 1))
		{
			for (x in (xo - r)...(w + xo + r + 1))
			{
				if (x < 0 || y < 0 || x >= this.w || y >= this.h) continue;
				var entities:Array<Entity> = entitiesInTiles[x + y * this.w];
				for (i in 0...entities.length)
				{
					var e:Entity = entities[i];
					var lr:Int = e.getLightRadius();
					if (lr > 0) screen.renderLight(e.x - 1, e.y - 4, lr * 8);
				}
			}
		}
		screen.setOffset(0, 0);
	}
	
	private function sortAndRender(screen:Screen, list:Array<Entity>):Void
	{
		//TODO: sort the list with the sprite sorter.
		list.sort(function(a:Entity, b:Entity):Int
		{
			if (a.y == b.y) return 0;
			if (a.y > b.y) return 1;
			else return -1;
		});
		
		for (i in 0...list.length)
		{
			list[i].render(screen);
		}
	}
	
	public function getTile(x:Int, y:Int):Tile
	{
		if (x < 0 || y < 0 || x >= w || y >= h) return StaticTile.rock;
		return Tile.tiles[tiles[x + y * w]];
	}
	
	public function setTile(x:Int, y:Int, t:Tile, dataVal:Int):Void
	{
		if (x < 0 || y < 0 || x >= w || y >= h) return;
		tiles[x + y * w] = t.id;
		data[x + y * w] = dataVal;
	}
	
	public function getData(x:Int, y:Int):Int
	{
		if (x < 0 || y < 0 || x >= w || y >= h) return 0;
		return data[x + y * w];// & 0xff;
	}
	
	public function setData(x:Int, y:Int, val:Int):Void
	{
		if (x < 0 || y < 0 || x >= w || y >= h) return;
		data[x + y * w] = val;
	}
	
	public function add(entity:Entity):Void
	{
		//TODO fix this?
		if (Std.is(entity, Player))
		{
			player = cast entity;
		}
		entity.removed = false;
		entities.push(entity);
		entity.init(this);
		
		insertEntity(entity.x >> 4, entity.y >> 4, entity);
	}
	
	public function remove(e:Entity):Void
	{
		entities.remove(e);
		var xto:Int = e.x >> 4;
		var yto:Int = e.y >> 4;
		removeEntity(xto, yto, e);
	}
	
	private function insertEntity(x:Int, y:Int, e:Entity):Void
	{
		if (x < 0 || y < 0 || x >= w || y >= h) return;
		entitiesInTiles[x + y * w].push(e);
	}
	
	private function removeEntity(x:Int, y:Int, e:Entity):Void
	{
		if (x < 0 || y < 0 || x >= w || y >= h) return;
		entitiesInTiles[x + y * w].remove(e);
	}
	
	public function trySpawn(count:Int)
	{
		for (i in 0...count)
		{
			var mob:Mob;
			
			var minLevel:Int = 1;
			var maxLevel:Int = 1;
			if (depth < 0)
			{
				maxLevel = ( -depth) + 1;
			}
			if (depth > 0)
			{
				minLevel = maxLevel = 4;
			}
			
			var lvl:Int = random.nextInt(maxLevel - minLevel + 1) + minLevel;
			if (random.nextInt(2) == 0)
			{
				mob = new Slime(lvl);
			}
			else
			{
				mob = new Zombie(lvl);
			}
			if (mob != null)
			{
				if (mob.findStartPos(this))
				{
					this.add(mob);
				}
			}
		}
	}
	
	public function tick():Void
	{
		//trySpawn(1);
		
		for (i in 0...Std.int(w * h / 50))
		{
			var xt:Int = random.nextInt(w);
			var yt:Int = random.nextInt(w);
			getTile(xt, yt).tick(this, xt, yt);
		}
		
		var i:Int = 0;
		//for (i in 0...entities.length)
		while(i < entities.length)
		{
			var e:Entity = entities[i];
			var xto:Int = e.x >> 4;
			var yto:Int = e.y >> 4;
			
			e.tick();
			
			if (e.removed)
			{
				entities.remove(entities[i--]);
				removeEntity(xto, yto, e);
			}
			else
			{
				var xt:Int = e.x >> 4;
				var yt:Int = e.y >> 4;
				
				if (xto != xt || yto != yt)
				{
					removeEntity(xto, yto, e);
					insertEntity(xt, yt, e);
				}
			}
			++i;
		}
	}
	
	public function getEntities(x0:Int, y0:Int, x1:Int, y1:Int):Array<Entity>
	{
		var result:Array<Entity> = [];
		var xt0:Int = (x0 >> 4) - 1;
		var yt0:Int = (y0 >> 4) - 1;
		var xt1:Int = (x0 >> 4) + 1;
		var yt1:Int = (y0 >> 4) + 1;
		for (y in yt0...(yt1 + 1))
		{
			for (x in xt0...(xt1 + 1))
			{
				if (x < 0 || y < 0 || x >= w || y >= h) continue;
				var entities:Array<Entity> = entitiesInTiles[x + y * this.w];
				for (i in 0...entities.length)
				{
					var e:Entity = entities[i];
					if (e.intersects(x0, y0, x1, y1)) result.push(e);
				}
			}
		}
		return result;
	}
}