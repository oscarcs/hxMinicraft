package screen;

import Game;
import InputHandler;
import gfx.Color;
import gfx.Font;
import gfx.Screen;

class Menu
{
	private var game:Game;
	private var input:InputHandler;
	
	public function init(game:Game, input:InputHandler):Void
	{
		this.input = input;
		this.game = game;
	}
	
	public function tick():Void
	{
		
	}
	
	public function render(screen:Screen):Void
	{
		
	}
	
	public function renderItemList(screen:Screen, xo:Int, yo:Int, x1:Int, y1:Int, listItems:Array<ListItem>, selected:Int):Void
	{
		var renderCursor:Bool = true;
		if (selected < 0)
		{
			selected = -selected - 1;
			renderCursor = false;
		}
		var w:Int = x1 - xo;
		var h:Int = y1 - yo - 1;
		var i0:Int = 0;
		var i1 = listItems.length;
		if (i1 > h) i1 = h;
		var io:Int = Std.int(selected - h / 2);
		if (io > listItems.length - h) io = listItems.length - h;
		if (io < 0) io = 0;
		
		for (i in i0...i1)
		{
			listItems[i + io].renderInventory(screen, (1 + xo) * 8, (i + 1 + yo) * 8);
		}
		
		if (renderCursor)
		{
			var yy:Int = selected + 1 - io + yo;
			Font.draw(">", screen, (xo + 0) * 8, yy * 8, Color.get(5, 555, 555, 555));
			Font.draw("<", screen, (xo + w) * 8, yy * 8, Color.get(5, 555, 555, 555));
		}
	}
}