package item.resource;

import entity.Player;
import gfx.Color;
import level.Level;
import level.tile.Tile;
import level.tile.StaticTile;

class StaticResource
{
	public static var wood:Resource = new Resource("Wood", 1 + 4 * 32, Color.get(-1, 200, 531, 430));
	public static var stone:Resource = new Resource("Stone", 2 + 4 * 32, Color.get(-1, 111, 333, 555));
	public static var flower:PlantableResource = new PlantableResource("Flower", 0 + 4 * 32, Color.get(-1, 10, 444, 330), StaticTile.flower, [StaticTile.grass]);
	public static var acorn:PlantableResource = new PlantableResource("Acorn", 3 + 4 * 32, Color.get(-1, 100, 531, 320), StaticTile.treeSapling, [StaticTile.grass]);
	public static var dirt:PlantableResource = new PlantableResource("Dirt", 2 + 4 * 32, Color.get(-1, 100, 322, 432), StaticTile.dirt, [StaticTile.hole, StaticTile.water, StaticTile.lava]);
	public static var sand:PlantableResource = new PlantableResource("Sand", 2 + 4 * 32, Color.get(-1, 110, 440, 550), StaticTile.sand, [StaticTile.grass, StaticTile.dirt]);
	public static var cactusFlower:PlantableResource = new PlantableResource("Cactus", 4 + 4 * 32, Color.get(-1, 10, 40, 50), StaticTile.cactusSapling, [StaticTile.sand]);
	public static var seeds:PlantableResource = new PlantableResource("Seeds", 5 + 4 * 32, Color.get(-1, 10, 40, 50), StaticTile.wheat, [StaticTile.farmland]);
	public static var wheat:Resource = new Resource("Wheat", 6 + 4 * 32, Color.get(-1, 110, 330, 550));
	public static var bread:Resource = new FoodResource("Bread", 8 + 4 * 32, Color.get(-1, 110, 330, 550), 2, 5);
	public static var apple:Resource = new FoodResource("Apple", 9 + 4 * 32, Color.get( -1, 100, 300, 500), 1, 5);
	
	public static var coal:Resource = new Resource("COAL", 10 + 4 * 32, Color.get(-1, 000, 111, 111));
	public static var ironOre:Resource = new Resource("I.ORE", 10 + 4 * 32, Color.get(-1, 100, 322, 544));
	public static var goldOre:Resource = new Resource("G.ORE", 10 + 4 * 32, Color.get(-1, 110, 440, 553));
	public static var ironIngot:Resource = new Resource("IRON", 11 + 4 * 32, Color.get(-1, 100, 322, 544));
	public static var goldIngot:Resource = new Resource("GOLD", 11 + 4 * 32, Color.get( -1, 110, 330, 553));
	
	public static var slime:Resource = new Resource("SLIME", 10 + 4 * 32, Color.get(-1, 10, 30, 50));
	public static var glass:Resource = new Resource("glass", 12 + 4 * 32, Color.get(-1, 555, 555, 555));
	public static var cloth:Resource = new Resource("cloth", 1 + 4 * 32, Color.get(-1, 25, 252, 141));
	public static var cloud:PlantableResource = new PlantableResource("cloud", 2 + 4 * 32, Color.get(-1, 222, 555, 444), StaticTile.cloud, [StaticTile.infiniteFall]);
	public static var gem:Resource = new Resource("gem", 13 + 4 * 32, Color.get(-1, 101, 404, 545));
}