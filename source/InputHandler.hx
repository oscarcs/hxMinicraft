package ;

//import java.awt.event.KeyEvent;
//import java.awt.event.KeyListener;
//import java.util.ArrayList;
//import java.util.List;

import flixel.FlxG;

class Key
{
	public var presses:Int;
	public var absorbs:Int;
	public var down:Bool;
	public var clicked:Bool;

	public function new()
	{
		InputHandler.keys.push(this);
		
		//FlxG.keys.anyJustPressed
	}

	public function toggle(pressed:Bool):Void
	{
		if (pressed != down)
		{
			down = pressed;
		}
		if (pressed)
		{
			presses++;
		}
	}

	public function tick():Void
	{
		if (absorbs < presses)
		{
			absorbs++;
			clicked = true;
		}
		else
		{
			clicked = false;
		}
	}
}

class InputHandler
{
	public static var keys:Array<Key> = [];
	
	public var up:Key = new Key();
	public var down:Key = new Key();
	public var left:Key = new Key();
	public var right:Key = new Key();
	public var attack:Key = new Key();
	public var menu:Key = new Key();

	public function releaseAll():Void
	{
		for (i in 0...keys.length)
		{
			keys[i].down = false;
		}
	}

	public function tick():Void
	{
		for (i in 0...keys.length)
		{
			keys[i].tick();
		}
	}

	public function new(game:Game)
	{
		//game.addKeyListener(this);
	}

	public function keyPressed(pressedKey:String):Void
	{
		toggle(pressedKey, true);
	}

	public function keyReleased(pressedKey:String):Void
	{
		toggle(pressedKey, false);
	}

	private function toggle(pressedKey:String, pressed:Bool):Void
	{
		//if (FlxG.an) up.toggle(pressed);
		/*
		if (ke.getKeyCode() == KeyEvent.VK_NUMPAD2) down.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_NUMPAD4) left.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_NUMPAD6) right.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_W) up.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_S) down.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_A) left.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_D) right.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_UP) up.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_DOWN) down.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_LEFT) left.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_RIGHT) right.toggle(pressed);

		if (ke.getKeyCode() == KeyEvent.VK_TAB) menu.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_ALT) menu.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_ALT_GRAPH) menu.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_SPACE) attack.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_CONTROL) attack.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_NUMPAD0) attack.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_INSERT) attack.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_ENTER) menu.toggle(pressed);

		if (ke.getKeyCode() == KeyEvent.VK_X) menu.toggle(pressed);
		if (ke.getKeyCode() == KeyEvent.VK_C) attack.toggle(pressed);
		*/
	}

	public function keyTyped(pressedKey:String):Void
	{
	}
}
