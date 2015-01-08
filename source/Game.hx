package ;

//flixel rendering requirements
import flixel.addons.display.FlxZoomCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;

import entity.Player;
import gfx.Color;
import gfx.Font;
import gfx.Screen;
import gfx.SpriteSheet;
import level.Level;
import level.tile.Tile;
import level.tile.StaticTile;
import screen.DeadMenu;
import screen.LevelTransitionMenu;
import screen.Menu;
import screen.TitleMenu;
import screen.WonMenu;
import crafting.Crafting;

class Game extends FlxState
{	
	//flixel / openfl rendering
	private var surface:FlxSprite;
		
	//private static var long serialVersionUID = 1L;
	private var random:Random = new Random();
	public static var NAME:String = "HxMinicraft";
	public static var HEIGHT:Int = 120;
	public static var WIDTH:Int = 160;
	private static var SCALE:Int = 3;

	//private BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
	private var pixels:Array<Int> = [];
	private var running:Bool = false;
	private var screen:Screen;
	private var lightScreen:Screen;
	private var input:InputHandler;// = new InputHandler(this);

	private var colors:Array<Int> = [];
	private var tickCount:Int = 0;
	public var gameTime:Int = 0;

	private var level:Level;
	private var levels:Array<Level> = [];
	private var currentLevel:Int = 3;
	public var player:Player;

	public var menu:Menu;
	private var playerDeadTime:Int;
	private var pendingLevelChange:Int;
	private var wonTimer:Int = 0;
	public var hasWon:Bool = false;
	
	public function setMenu(menu:Menu):Void
	{
		this.menu = menu;
		if (menu != null) menu.init(this, input);
	}
	
	public function resetGame():Void
	{
		playerDeadTime = 0;
		wonTimer = 0;
		gameTime = 0;
		hasWon = false;
		
		
		currentLevel = 3;
		levels = [for (i in 0...5) null];
		
		levels[4] = new Level(128, 128, 1, null);
		levels[3] = new Level(128, 128, 0, levels[4]);
		levels[2] = new Level(128, 128, -1, levels[3]);
		levels[1] = new Level(128, 128, -2, levels[2]);
		levels[0] = new Level(128, 128, -3, levels[1]);
		
		level = levels[currentLevel];
		player = new Player(this, input);
		player.findStartPos(level);
		
		level.add(player);
		
		for (i in 0...5)
		{
			levels[i].trySpawn(400);
		}
		
	}
	
	private function init():Void
	{
		var pp:Int = 0;
		for (r in 0...6)
		{
			for (g in 0...6)
			{
				for (b in 0...6)
				{
					var rr:Float = (r * 255 / 5);
					var gg:Float = (g * 255 / 5);
					var bb:Float = (b * 255 / 5);
					var mid:Float = (rr * 30 + gg * 59 + bb * 11) / 100;
					
					var r1:Float = ((rr + mid * 1) / 2) * 230 / 255 + 10;
					var g1:Float = ((gg + mid * 1) / 2) * 230 / 255 + 10;
					var b1:Float = ((bb + mid * 1) / 2) * 230 / 255 + 10;
					colors[pp++] = Std.int(r1) << 16 | Std.int(g1) << 8 | Std.int(b1);
				}
			}
		}
		
		/*
		try
		{
			screen = new Screen(WIDTH, HEIGHT, new SpriteSheet(ImageIO.read(Game.class.getResourceAsStream("/icons.png"))));
			lightScreen = new Screen(WIDTH, HEIGHT, new SpriteSheet(ImageIO.read(Game.class.getResourceAsStream("/icons.png"))));
		}
		catch (e:IOException)
		{
			e.printStackTrace();
		}
		*/

		resetGame();
		setMenu(new TitleMenu());
	}
	
	override public function create():Void
	{
		super.create();
		
		//Init the crafting recipes
		Crafting.init();
		//Init the static tile refs
		StaticTile.init();
		
		input = new InputHandler(this);
		
		surface = new FlxSprite(0, 0);
		surface.makeGraphic(WIDTH, HEIGHT, FlxColor.BLUE);
		surface.scale.x = surface.scale.y = SCALE;
		surface.x = (surface.width * SCALE) / 3;
		surface.y = (surface.height * SCALE) / 3;
		add(surface);
			
		screen = new Screen(WIDTH, HEIGHT, new SpriteSheet());
		screen.clear(0);
		//screen.render(0, 0, 5, -1190846796, 0);
		
		lightScreen = new Screen(WIDTH, HEIGHT, new SpriteSheet());
		lightScreen.clear(0);
		//lightScreen.render(0, 0, 5, -1190846796, 0);
		
		pixels = [for (i in 0...(WIDTH * HEIGHT)) 0];
		
		init();
		/*
		long lastTime = System.nanoTime();
		double unprocessed = 0;
		double nsPerTick = 1000000000.0 / 60;
		int frames = 0;
		int ticks = 0;
		long lastTimer1 = System.currentTimeMillis();

		init();

		while (running) {
			long now = System.nanoTime();
			unprocessed += (now - lastTime) / nsPerTick;
			lastTime = now;
			boolean shouldRender = true;
			while (unprocessed >= 1) {
				ticks++;
				tick();
				unprocessed -= 1;
				shouldRender = true;
			}

			try {
				Thread.sleep(2);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

			if (shouldRender) {
				frames++;
				render();
			}

			if (System.currentTimeMillis() - lastTimer1 > 1000) {
				lastTimer1 += 1000;
				System.out.println(ticks + " ticks, " + frames + " fps");
				frames = 0;
				ticks = 0;
			}
		}
		
		*/
	}
	
	override public function update():Void
	{
		if (FlxG.keys.anyPressed(["R"]))
		{
			FlxG.switchState(new Game());
		}
		
		tickCount++;
		if (!hasFocus())
		{
			//input.releaseAll();
		}
		else
		{
			if (!player.removed && !hasWon)
			{
				gameTime++;
			}

			//input.tick();
			if (menu != null)
			{
				menu.tick();
			}
			else
			{
				if (player.removed)
				{
					playerDeadTime++;
					if (playerDeadTime > 60)
					{
						setMenu(new DeadMenu());
					}
				}
				else
				{
					if (pendingLevelChange != 0)
					{
						setMenu(new LevelTransitionMenu(pendingLevelChange));
						pendingLevelChange = 0;
					}
				}
				if (wonTimer > 0)
				{
					if (--wonTimer == 0)
					{
						setMenu(new WonMenu());
					}
				}
				level.tick();
				Tile.tickCount++;
			}
		}
		render();
		super.update();
	}
	
	public function changeLevel(dir:Int):Void
	{
		level.remove(player);
		currentLevel += dir;
		level = levels[currentLevel];
		player.x = (player.x >> 4) * 16 + 8;
		player.y = (player.y >> 4) * 16 + 8;
		level.add(player);
	}
	
	public function render():Void
	{
		var xScroll:Int = Std.int(player.x - screen.w / 2);
		var yScroll:Int = Std.int(player.y - (screen.h - 8) / 2);
		if (xScroll < 16) xScroll = 16;
		if (yScroll < 16) yScroll = 16;
		if (xScroll > level.w * 16 - screen.w - 16) xScroll = level.w * 16 - screen.w - 16;
		if (yScroll > level.h * 16 - screen.h - 16) yScroll = level.h * 16 - screen.h - 16;
		
		if (currentLevel > 3)
		{
			var col:Int = Color.get(20, 20, 121, 121);
			for (y in 0...14)
			{
				for (x in 0...24)
				{
					screen.render(x * 8 - (Std.int((xScroll / 4)) & 7), y * 8 - (Std.int((yScroll / 4)) & 7), 0, col, 0);
				}
			}
		}

		level.renderBackground(screen, xScroll, yScroll);
		level.renderSprites(screen, xScroll, yScroll);

		if (currentLevel < 3)
		{
			lightScreen.clear(0);
			level.renderLight(lightScreen, xScroll, yScroll);
			screen.overlay(lightScreen, xScroll, yScroll);
		}

		renderGui();

		if (!hasFocus()) renderFocusNagger();
		
		for (y in 0...screen.h)
		{
			for (x in 0...screen.w)
			{
				var cc:Int = screen.pixels[x + y * screen.w];
				if (cc < 255) pixels[x + y * WIDTH] = colors[cc];
				
				#if flash
				surface.framePixels.setPixel(x, y, colors[screen.pixels[x + y * WIDTH]]);
				#end
				#if neko
				surface.pixels.setPixel(x, y, colors[screen.pixels[x + y * WIDTH]]);
				#end
			}
		}
	}
	
	private function renderGui():Void
	{
		for (y in 0...2)
		{
			for (x in 0...20)
			{
				screen.render(x * 8, screen.h - 16 + y * 8, 0 + 12 * 32, Color.get(000, 000, 000, 000), 0);
			}
		}

		for (i in 0...10)
		{
			if (i < player.health)
			{
				screen.render(i * 8, screen.h - 16, 0 + 12 * 32, Color.get(000, 200, 500, 533), 0);
			}
			else
			{
				screen.render(i * 8, screen.h - 16, 0 + 12 * 32, Color.get(000, 100, 000, 000), 0);
			}
			
			if (player.staminaRechargeDelay > 0)
			{
				if (player.staminaRechargeDelay / 4 % 2 == 0)
				{
					screen.render(i * 8, screen.h - 8, 1 + 12 * 32, Color.get(000, 555, 000, 000), 0);
				}
				else
				{
					screen.render(i * 8, screen.h - 8, 1 + 12 * 32, Color.get(000, 110, 000, 000), 0);
				}
			}
			else
			{
				if (i < player.stamina)
				{
					screen.render(i * 8, screen.h - 8, 1 + 12 * 32, Color.get(000, 220, 550, 553), 0);
				}
				else
				{
					screen.render(i * 8, screen.h - 8, 1 + 12 * 32, Color.get(000, 110, 000, 000), 0);
				}
			}
		}
		if (player.activeItem != null)
		{
			player.activeItem.renderInventory(screen, 10 * 8, screen.h - 16);
		}

		if (menu != null)
		{
			menu.render(screen);
		}
	}
	
	private function renderFocusNagger():Void
	{
		var msg:String = "Click to focus!";
		var xx:Int = Std.int((WIDTH - msg.length * 8) / 2);
		var yy:Int = Std.int((HEIGHT - 8) / 2);
		var w:Int = msg.length;
		var	h:Int = 1;

		screen.render(xx - 8, yy - 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 0);
		screen.render(xx + w * 8, yy - 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 1);
		screen.render(xx - 8, yy + 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 2);
		screen.render(xx + w * 8, yy + 8, 0 + 13 * 32, Color.get(-1, 1, 5, 445), 3);
		
		for (x in 0...w)
		{
			screen.render(xx + x * 8, yy - 8, 1 + 13 * 32, Color.get(-1, 1, 5, 445), 0);
			screen.render(xx + x * 8, yy + 8, 1 + 13 * 32, Color.get(-1, 1, 5, 445), 2);
		}
		for (y in 0...h)
		{
			screen.render(xx - 8, yy + y * 8, 2 + 13 * 32, Color.get(-1, 1, 5, 445), 0);
			screen.render(xx + w * 8, yy + y * 8, 2 + 13 * 32, Color.get(-1, 1, 5, 445), 1);
		}

		if ((tickCount / 20) % 2 == 0)
		{
			Font.draw(msg, screen, xx, yy, Color.get(5, 333, 333, 333));
		}
		else
		{
			Font.draw(msg, screen, xx, yy, Color.get(5, 555, 555, 555));
		}
	}
	
	public function scheduleLevelChange(dir:Int):Void
	{
		pendingLevelChange = dir;
	}

	public function won():Void
	{
		wonTimer = 60 * 3;
		hasWon = true;
	}
	
	//'stop()'
	override public function destroy():Void
	{
		running = false;
		super.destroy();
	}
	
	private function hasFocus():Bool
	{
		return true;
	}
}