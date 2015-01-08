package entity;

import item.Item;
import item.ResourceItem;
import item.resource.Resource;

class Inventory
{
	public var items:Array<Item> = [];
	
	public function add(item:Item)
	{
		add2(items.length, item);
	}
	
	public function add2(slot:Int, item:Item):Void
	{
		if (Std.is(item, ResourceItem))
		{
			//TODO cast?
			var toTake:ResourceItem = cast item;
			var has:ResourceItem = findResource(toTake.resource);
			if (has == null)
			{
				items.insert(slot, toTake);
			}
			else
			{
				has.count += toTake.count;
			}
		}
		else
		{
			items.insert(slot, item);
		}
	}
	
	private function findResource(resource:Resource):ResourceItem
	{
		for (i in 0...items.length)
		{
			if (Std.is(items[i], ResourceItem))
			{
				//TODO cast?
				var has:ResourceItem = cast items[i];
				if (has.resource == resource) return has;
			}
		}
		return null;
	}
	
	public function hasResources(r:Resource, count:Int):Bool
	{
		var ri:ResourceItem = findResource(r);
		if (ri == null) return false;
		return ri.count >= count;
	}
	
	public function removeResource(r:Resource, count:Int):Bool
	{
		var ri:ResourceItem = findResource(r);
		if (ri == null) return false;
		if (ri.count < count) return false;
		ri.count -= count;
		if (ri.count <= 0) items.remove(ri);
		return true;
	}
	
	public function count(item:Item):Int
	{
		if (Std.is(item, ResourceItem))
		{
			var unsafeCast:ResourceItem = cast item;
			var ri:ResourceItem = findResource((unsafeCast).resource);
			if (ri!=null) return ri.count;
		}
		else
		{
			var count:Int = 0;
			for (i in 0...items.length )
			{
				if (items[i].matches(item)) count++;
			}
			return count;
		}
		return 0;
	}
}