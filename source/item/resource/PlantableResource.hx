package item.resource;

import level.tile.Tile;
import level.Level;
import entity.Player;

class PlantableResource extends Resource
{
	private var sourceTiles:Array<Tile>;
	private var targetTile:Tile;
	
	override public function new(name:String, sprite:Int, color:Int, targetTile:Tile, sourceTiles:Array<Tile>) 
	{
		super(name, sprite, color);
		this.sourceTiles = sourceTiles;
		this.targetTile = targetTile;
	}
	
	override public function interactOn(tile:Tile, level:Level, xt:Int, yt:Int, player:Player, attackDir:Int)
	{
		if (sourceTiles.indexOf(tile) > -1)
		{
			level.setTile(xt, yt, targetTile, 0);
			return true;
		}
		return false;
	}
}