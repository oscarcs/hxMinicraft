package entity;

import flixel.FlxG;

import Game;
import InputHandler;
import entity.particle.TextParticle;
import gfx.Color;
import gfx.Screen;
import item.FurnitureItem;
import item.Item;
import item.PowerGloveItem;
import item.ResourceItem;
import item.ToolItem;
import item.ToolType;
import item.resource.Resource;
import level.Level;
import level.tile.Tile;
import level.tile.StaticTile;
import screen.InventoryMenu;
//import sound.Sound;

class Player extends Mob
{
	private var input:InputHandler;
	private var attackTime:Int;
	private var attackDir:Int;

	public var game:Game;
	public var inventory:Inventory = new Inventory();
	public var attackItem:Item;
	public var activeItem:Item;
	public var stamina:Int;
	public var staminaRecharge:Int = 0;
	public var staminaRechargeDelay:Int = 0;
	public var score:Int;
	public var maxStamina:Int = 10;
	private var onStairDelay:Int;
	public var invulnerableTime:Int = 0;
	
	override public function new(game:Game, input:InputHandler)
	{
		super();
		this.game = game;
		this.input = input;
		x = 24;
		y = 24;
		stamina = maxStamina;
		
		inventory.add(new FurnitureItem(new Workbench()));
		inventory.add(new PowerGloveItem());
	}
	
	override public function tick():Void
	{
		super.tick();
		
		if (FlxG.keys.anyJustPressed(["L"])) changeLevel(-1);
		if (FlxG.keys.anyJustPressed(["K"])) changeLevel( 1);
		
		if (invulnerableTime > 0) invulnerableTime--;
		var onTile:Tile = level.getTile(x >> 4, y >> 4);
		if (onTile == StaticTile.stairsDown || onTile == StaticTile.stairsUp)
		{
			if (onStairDelay == 0)
			{
				changeLevel((onTile == StaticTile.stairsUp) ? 1 : -1);
				onStairDelay = 10;
				return;
			}
			onStairDelay = 10;
		}
		else
		{
			if (onStairDelay > 0) onStairDelay--;
		}

		if (stamina <= 0 && staminaRechargeDelay == 0 && staminaRecharge == 0)
		{
			staminaRechargeDelay = 40;
		}

		if (staminaRechargeDelay > 0)
		{
			staminaRechargeDelay--;
		}

		if (staminaRechargeDelay == 0)
		{
			staminaRecharge++;
			if (isSwimming())
			{
				staminaRecharge = 0;
			}
			while (staminaRecharge > 10)
			{
				staminaRecharge -= 10;
				if (stamina < maxStamina) stamina++;
			}
		}

		var xa:Int = 0;
		var ya:Int = 0;
		if (FlxG.keys.anyPressed(G.upKeys)) ya--;
		if (FlxG.keys.anyPressed(G.downKeys)) ya++;
		if (FlxG.keys.anyPressed(G.leftKeys)) xa--;
		if (FlxG.keys.anyPressed(G.rightKeys)) xa++;
		if (isSwimming() && tickTime % 60 == 0)
		{
			if (stamina > 0)
			{
				stamina--;
			}
			else
			{
				hurt(this, 1, dir ^ 1);
			}
		}

		if (staminaRechargeDelay % 2 == 0)
		{
			move(xa, ya);
		}

		if (FlxG.keys.anyJustPressed(G.attackKeys))
		{
			if (stamina == 0)
			{
				//can't attack
			}
			else
			{
				stamina--;
				staminaRecharge = 0;
				attack();
			}
		}
		if (FlxG.keys.anyJustPressed(G.menuKeys))
		{
			if (!use(null, 0))
			{
				game.setMenu(new InventoryMenu(this));
			}
		}
		if (attackTime > 0) attackTime--;
	}
	
	override public function use(p:Player, a:Int):Bool
	{
		if (use1())
		{
			return true;
		}
		return false;
	}
	
	
	public function use1():Bool
	{
		var yo:Int = -2;
		if (dir == 0 && use2(x - 8, y + 4 + yo, x + 8, y + 12 + yo)) return true;
		if (dir == 1 && use2(x - 8, y - 12 + yo, x + 8, y - 4 + yo)) return true;
		if (dir == 3 && use2(x + 4, y - 8 + yo, x + 12, y + 8 + yo)) return true;
		if (dir == 2 && use2(x - 12, y - 8 + yo, x - 4, y + 8 + yo)) return true;

		var xt:Int = x >> 4;
		var yt:Int = (y + yo) >> 4;
		var r:Int = 12;
		if (attackDir == 0) yt = (y + r + yo) >> 4;
		if (attackDir == 1) yt = (y - r + yo) >> 4;
		if (attackDir == 2) xt = (x - r) >> 4;
		if (attackDir == 3) xt = (x + r) >> 4;

		if (xt >= 0 && yt >= 0 && xt < level.w && yt < level.h)
		{
			if (level.getTile(xt, yt).use(level, xt, yt, this, attackDir)) return true;
		}

		return false;
	}
	
	private function use2(x0:Int, y0:Int, x1:Int, y1:Int):Bool
	{
		var entities:Array<Entity> = level.getEntities(x0, y0, x1, y1);
		for (i in 0...entities.length)
		{
			var e:Entity = entities[i];
			if (e != this) if (e.use(this, attackDir)) return true;
		}
		return false;
	}
	
	private function attack():Void
	{
		walkDist += 8;
		attackDir = dir;
		attackItem = activeItem;
		var done:Bool = false;

		if (activeItem != null)
		{
			attackTime = 10;
			var yo:Int = -2;
			var range:Int = 12;
			if (dir == 0 && interact(x - 8, y + 4 + yo, x + 8, y + range + yo)) done = true;
			if (dir == 1 && interact(x - 8, y - range + yo, x + 8, y - 4 + yo)) done = true;
			if (dir == 3 && interact(x + 4, y - 8 + yo, x + range, y + 8 + yo)) done = true;
			if (dir == 2 && interact(x - range, y - 8 + yo, x - 4, y + 8 + yo)) done = true;
			if (done) return;

			var xt:Int = x >> 4;
			var yt:Int = (y + yo) >> 4;
			var r:Int = 12;
			if (attackDir == 0) yt = (y + r + yo) >> 4;
			if (attackDir == 1) yt = (y - r + yo) >> 4;
			if (attackDir == 2) xt = (x - r) >> 4;
			if (attackDir == 3) xt = (x + r) >> 4;

			if (xt >= 0 && yt >= 0 && xt < level.w && yt < level.h)
			{
				if (activeItem.interactOn(level.getTile(xt, yt), level, xt, yt, this, attackDir))
				{
					done = true;
				}
				else
				{
					if (level.getTile(xt, yt).interact(level, xt, yt, this, activeItem, attackDir))
					{
						done = true;
					}
				}
				if (activeItem.isDepleted())
				{
					activeItem = null;
				}
			}
			
		}
		
		if (done) return;

		if (activeItem == null || activeItem.canAttack())
		{
			attackTime = 5;
			var yo:Int = -2;
			var range:Int = 20;
			if (dir == 0) hurt(x - 8, y + 4 + yo, x + 8, y + range + yo);
			if (dir == 1) hurt(x - 8, y - range + yo, x + 8, y - 4 + yo);
			if (dir == 3) hurt(x + 4, y - 8 + yo, x + range, y + 8 + yo);
			if (dir == 2) hurt(x - range, y - 8 + yo, x - 4, y + 8 + yo);

			var xt:Int = x >> 4;
			var yt:Int = (y + yo) >> 4;
			var r:Int = 12;
			if (attackDir == 0) yt = (y + r + yo) >> 4;
			if (attackDir == 1) yt = (y - r + yo) >> 4;
			if (attackDir == 2) xt = (x - r) >> 4;
			if (attackDir == 3) xt = (x + r) >> 4;

			if (xt >= 0 && yt >= 0 && xt < level.w && yt < level.h)
			{
				level.getTile(xt, yt).hurt(level, xt, yt, this, random.nextInt(3) + 1, attackDir);
			}
		}
	}

	//as below - '~/filthy ha(xe|cks)/;'
	override public function interact(x0:Int, y0:Int, x1:Int, ?y1:Int):Bool
	{
		var entities:Array<Entity> = level.getEntities(x0, y0, x1, y1);
		for (i in 0...entities.length)
		{
			var e:Entity = entities[i];
			if (e != this)
			{
				if (e.interact(this, activeItem, attackDir)) return true;
			}
		}
		return false;
	}
	
	//more filthy hacks to subvert Haxe's function signatures checker.
	override public function hurt(x0:Dynamic, y0:Dynamic, x1:Int, ?y1:Int):Void
	{
		
		if (Std.is(x0, Mob))
		{
			//doHurt(lvl + 1, dir);
			doHurt(y0, x1);
		}
		else
		{
			var entities:Array<Entity> = level.getEntities(x0, y0, x1, y1);
			for (i in 0...entities.length)
			{
				var e:Entity = entities[i];
				if (e != this) e.hurt(this, getAttackDamage(e), attackDir);
			}
		}
	}
	
	private function getAttackDamage(e:Entity):Int
	{
		var dmg:Int = random.nextInt(3) + 1;
		if (attackItem != null)
		{
			dmg += attackItem.getAttackDamageBonus(e);
		}
		return dmg;
	}
	
	override public function render(screen:Screen):Void
	{
		//render what
		var xt:Int = 0;
		var yt:Int = 14;

		//flip what
		var flip1:Int = (walkDist >> 3) & 1;
		var flip2:Int = (walkDist >> 3) & 1;

		
		
		//up
		if (dir == 1)
		{
			xt += 2;
		}
		//if left or right
		if (dir > 1)
		{
			flip1 = 0;
			flip2 = ((walkDist >> 4) & 1);
			//left
			if (dir == 2)
			{
				flip1 = 1;
			}
			xt += 4 + ((walkDist >> 3) & 1) * 2;
		}

		//render where
		var xo:Int = x - 8;
		var yo:Int = y - 11;
		
		if (isSwimming())
		{
			yo += 4;
			var waterColor:Int = Color.get(-1, -1, 115, 335);
			if (tickTime / 8 % 2 == 0)
			{
				waterColor = Color.get(-1, 335, 5, 115);
			}
			screen.render(xo + 0, yo + 3, 5 + 13 * 32, waterColor, 0);
			screen.render(xo + 8, yo + 3, 5 + 13 * 32, waterColor, 1);
		}

		if (attackTime > 0 && attackDir == 1)
		{
			screen.render(xo + 0, yo - 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 0);
			screen.render(xo + 8, yo - 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 1);
			if (attackItem != null)
			{
				attackItem.renderIcon(screen, xo + 4, yo - 4);
			}
		}
		var col:Int = Color.get(-1, 100, 220, 532);
		if (hurtTime > 0)
		{
			col = Color.get(-1, 555, 555, 555);
		}

		if (Std.is(activeItem,FurnitureItem))
		{
			yt += 2;
		}
		
		//render head
		screen.render(xo + 8 * flip1, yo + 0, xt + yt * 32, col, flip1);
		screen.render(xo + 8 - 8 * flip1, yo + 0, xt + 1 + yt * 32, col, flip1);
		if (!isSwimming())
		{
			//render body
			screen.render(xo + 8 * flip2, yo + 8, xt + (yt + 1) * 32, col, flip2);
			screen.render(xo + 8 - 8 * flip2, yo + 8, xt + 1 + (yt + 1) * 32, col, flip2);
		}

		if (attackTime > 0 && attackDir == 2)
		{
			screen.render(xo - 4, yo, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 1);
			screen.render(xo - 4, yo + 8, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 3);
			if (attackItem != null)
			{
				attackItem.renderIcon(screen, xo - 4, yo + 4);
			}
		}
		if (attackTime > 0 && attackDir == 3)
		{
			screen.render(xo + 8 + 4, yo, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 0);
			screen.render(xo + 8 + 4, yo + 8, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 2);
			if (attackItem != null)
			{
				attackItem.renderIcon(screen, xo + 8 + 4, yo + 4);
			}
		}
		if (attackTime > 0 && attackDir == 0)
		{
			screen.render(xo + 0, yo + 8 + 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 2);
			screen.render(xo + 8, yo + 8 + 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 3);
			if (attackItem != null)
			{
				attackItem.renderIcon(screen, xo + 4, yo + 8 + 4);
			}
		}

		if (Std.is(activeItem, FurnitureItem))
		{
			var unsafeCast:FurnitureItem = cast activeItem;
			var furniture:Furniture = unsafeCast.furniture;
			furniture.x = x;
			furniture.y = yo;
			furniture.render(screen);

		}
	}
	
	override public function touchItem(itemEntity:ItemEntity):Void
	{
		itemEntity.take(this);
		inventory.add(itemEntity.item);
	}
	
	override public function canSwim():Bool
	{
		return true;
	}
	
	override public function findStartPos(level:Level):Bool
	{
		while (true)
		{
			var x:Int = random.nextInt(level.w);
			var y:Int = random.nextInt(level.h);
			if (level.getTile(x, y) == StaticTile.grass)
			{
				this.x = x * 16 + 8;
				this.y = y * 16 + 8;
				return true;
			}
		}
	}
	
	public function payStamina(cost:Int):Bool
	{
		if (cost > stamina) return false;
		stamina -= cost;
		return true;
	}
	
	public function changeLevel(dir:Int)
	{
		game.scheduleLevelChange(dir);
	}
	
	override public function getLightRadius():Int
	{
		var r:Int = 2;
		if (activeItem != null)
		{
			// ... fuck.
			if (Std.is(activeItem, FurnitureItem))
			{
				var unsafeCast:FurnitureItem = cast activeItem;
				var rr:Int = unsafeCast.furniture.getLightRadius();
				if (rr > r) r = rr;
			}
		}
		return r;
	}
	
	override private function die():Void
	{
		super.die();
		//Sound.playerDeath.play();
	}
	
	override private function touchedBy(entity:Entity):Void
	{
		//change this ish
		if (!(Std.is(entity, Player)))
		{
			entity.touchedBy(this);
		}
	}
	
	override private function doHurt(damage:Int, attackDir:Int):Void
	{
		if (hurtTime > 0 || invulnerableTime > 0) return;

		//Sound.playerHurt.play();
		level.add(new TextParticle("" + damage, x, y, Color.get(-1, 504, 504, 504)));
		health -= damage;
		if (attackDir == 0) yKnockback = 6;
		if (attackDir == 1) yKnockback = -6;
		if (attackDir == 2) xKnockback = -6;
		if (attackDir == 3) xKnockback = 6;
		hurtTime = 10;
		invulnerableTime = 30;	
	}
	
	public function gameWon()
	{
		level.player.invulnerableTime = 60 * 5;
		game.won();
	}
}