package level.tile;

import item.resource.Resource;
import item.resource.StaticResource;

class StaticTile
{
	/*
	public static var grass:GrassTile = new GrassTile(0);
	public static var rock:RockTile = new RockTile(1);
	public static var water:WaterTile = new WaterTile(2);
	public static var flower:FlowerTile = new FlowerTile(3);
	public static var tree:TreeTile = new TreeTile(4);
	public static var dirt:DirtTile = new DirtTile(5);
	public static var sand:SandTile = new SandTile(6);
	public static var cactus:CactusTile = new CactusTile(7);
	public static var hole:HoleTile = new HoleTile(8);
	public static var treeSapling:SaplingTile = new SaplingTile(9, grass, tree);
	public static var cactusSapling:SaplingTile = new SaplingTile(10, sand, cactus);
	public static var farmland:FarmTile = new FarmTile(11);
	public static var wheat:WheatTile = new WheatTile(12);
	public static var lava:LavaTile = new LavaTile(13);
	public static var stairsDown:StairsTile = new StairsTile(14, false);
	public static var stairsUp:StairsTile = new StairsTile(15, true);
	public static var infiniteFall:InfiniteFallTile = new InfiniteFallTile(16);
	public static var cloud:CloudTile = new CloudTile(17);
	public static var hardRock:HardRockTile = new HardRockTile(18);
	public static var ironOre:OreTile = new OreTile(19, Resource.ironOre);
	public static var goldOre:OreTile = new OreTile(20, Resource.goldOre);
	public static var gemOre:OreTile = new OreTile(21, Resource.gem);
	public static var cloudCactus:CloudCactusTile = new CloudCactusTile(22);
	*/
	
	public static var grass:GrassTile;
	public static var rock:RockTile;
	public static var water:WaterTile;
	public static var flower:FlowerTile;
	public static var tree:TreeTile;
	public static var dirt:DirtTile;
	public static var sand:SandTile;
	public static var cactus:CactusTile;
	public static var hole:HoleTile;
	public static var treeSapling:SaplingTile;
	public static var cactusSapling:SaplingTile;
	public static var farmland:FarmTile;
	public static var wheat:WheatTile;
	public static var lava:LavaTile;
	public static var stairsDown:StairsTile;
	public static var stairsUp:StairsTile;
	public static var infiniteFall:InfiniteFallTile;
	public static var cloud:CloudTile;
	public static var hardRock:HardRockTile;
	public static var ironOre:OreTile;
	public static var goldOre:OreTile;
	public static var gemOre:OreTile;
	public static var cloudCactus:CloudCactusTile;
	
	public static function init()
	{
		grass = new GrassTile(0);
		rock = new RockTile(1);
		water = new WaterTile(2);
		flower = new FlowerTile(3);
		tree = new TreeTile(4);
        dirt = new DirtTile(5);
        sand = new SandTile(6);
        cactus = new CactusTile(7);
        hole = new HoleTile(8);
        treeSapling = new SaplingTile(9, grass, tree);
        cactusSapling = new SaplingTile(10, sand, cactus);
        farmland = new FarmTile(11);
        wheat = new WheatTile(12);
        lava = new LavaTile(13);
        stairsDown = new StairsTile(14, false);
        stairsUp = new StairsTile(15, true);
        infiniteFall = new InfiniteFallTile(16);
        cloud = new CloudTile(17);
        hardRock = new HardRockTile(18);
        ironOre = new OreTile(19, StaticResource.ironOre);
        goldOre = new OreTile(20, StaticResource.goldOre);
        gemOre = new OreTile(21, StaticResource.gem);
        cloudCactus = new CloudCactusTile(22);	
	}  
}      
       