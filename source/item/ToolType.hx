package item;

class ToolType
{
	public static var shovel:ToolType = new ToolType("Shvl", 0);
	public static var hoe:ToolType = new ToolType("Hoe", 1);
	public static var sword:ToolType = new ToolType("Swrd", 2);
	public static var pickaxe:ToolType = new ToolType("Pick", 3);
	public static var axe:ToolType = new ToolType("Axe", 4);

	public var name:String;
	public var sprite:Int;

	public function new(name:String, sprite:Int)
	{
		this.name = name;
		this.sprite = sprite;
	}
}