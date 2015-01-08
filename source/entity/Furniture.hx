package entity;

import gfx.Screen;
import item.FurnitureItem;
import item.PowerGloveItem;

class Furniture extends Entity
{
	private var pushTime:Int = 0;
	private var pushDir:Int = -1;
	public var col:Int;
	public var sprite:Int;
	public var name:String;
	private var shouldTake:Player;

	override public function new(name:String)
	{
		super();
		this.name = name;
		xr = 3;
		yr = 3;
	}

	override public function tick():Void
	{
		if (shouldTake != null)
		{
			if (Std.is(shouldTake.activeItem, PowerGloveItem))
			{
				remove();
				shouldTake.inventory.add2(0, shouldTake.activeItem);
				shouldTake.activeItem = new FurnitureItem(this);
			}
			shouldTake = null;
		}
		if (pushDir == 0) move(0, 1);
		if (pushDir == 1) move(0, -1);
		if (pushDir == 2) move(-1, 0);
		if (pushDir == 3) move(1, 0);
		pushDir = -1;
		if (pushTime > 0) pushTime--;
	}

	override public function render(screen:Screen):Void
	{
		screen.render(x - 8, y - 8 - 4, sprite * 2 + 8 * 32, col, 0);
		screen.render(x - 0, y - 8 - 4, sprite * 2 + 8 * 32 + 1, col, 0);
		screen.render(x - 8, y - 0 - 4, sprite * 2 + 8 * 32 + 32, col, 0);
		screen.render(x - 0, y - 0 - 4, sprite * 2 + 8 * 32 + 33, col, 0);
	}

	override public function blocks(e:Entity):Bool
	{
		return true;
	}

	override public function touchedBy(entity:Entity):Void
	{
		if (Std.is(entity, Player) && pushTime == 0)
		{
			trace('touched');
			var unsafeCast:Player = cast entity;
			pushDir = unsafeCast.dir;
			pushTime = 10;
		}
	}

	public function take(player:Player):Void
	{
		shouldTake = player;
	}
}