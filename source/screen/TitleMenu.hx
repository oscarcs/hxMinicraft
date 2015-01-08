package screen;

import flixel.FlxG;

import gfx.Color;
import gfx.Font;
import gfx.Screen;
//import sound.Sound;

class TitleMenu extends Menu
{
	private var selected:Int = 0;
	private static var options:Array<String> = [ "Start game", "How to play", "About" ];

	public function new() 
	{
		//super();
	}
	
	override public function tick():Void
	{
		if (FlxG.keys.anyJustPressed(G.upKeys)) selected--;
		if (FlxG.keys.anyJustPressed(G.downKeys)) selected++;
		
		var len:Int = options.length;
		if (selected < 0) selected += len;
		if (selected >= len) selected -= len;

		if (FlxG.keys.anyJustPressed(G.attackKeys) || FlxG.keys.anyJustPressed(G.menuKeys))
		{
			if (selected == 0)
			{
				//Sound.test.play();
				game.resetGame();
				game.setMenu(null);
			}
			if (selected == 1) game.setMenu(new InstructionsMenu(this));
			if (selected == 2) game.setMenu(new AboutMenu(this));
		}
		
	}
	
	override public function render(screen:Screen):Void
	{
		screen.clear(0);

		var h:Int = 2;
		var w:Int = 13;
		var titleColor:Int = Color.get(0, 010, 131, 551);		
		var xo:Int = Std.int((screen.w - w * 8) / 2);
		var yo:Int = 24;
		for (y in 0...h)	
		{
			for (x in 0...w)
			{
				screen.render(xo + x * 8, yo + y * 8, x + (y + 6) * 32, titleColor, 0);
			}
		}

		for (i in 0...3)
		{
			var msg:String = options[i];
			var col:Int = Color.get(0, 222, 222, 222);
			if (i == selected)
			{
				msg = "> " + msg + " <";
				col = Color.get(0, 555, 555, 555);
			}
			Font.draw(msg, screen, Std.int((screen.w - msg.length * 8) / 2), (8 + i) * 8, col);
		}

		Font.draw("(Arrow keys,X and C)", screen, 0, screen.h - 8, Color.get(0, 111, 111, 111));
	}
	
}