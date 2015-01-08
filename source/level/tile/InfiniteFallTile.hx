package level.tile;

//import entity.AirWizard;
import entity.Entity;
import gfx.Screen;
import level.Level;

class InfiniteFallTile extends Tile
{
	override public function new(id:Int)
	{
		super(id);
	}

	override public function render(screen:Screen, level:Level, x:Int, y:Int):Void
	{
		
	}

	override public function tick(level:Level, xt:Int, yt:Int):Void
	{
		
	}

	override public function mayPass(level:Level, x:Int, y:Int, e:Entity):Bool
	{
		//if (Std.is(e, AirWizard)) return true;
		return false;
	}
}
