package;

/**
 * May eventually properly reimplement Java's Random Class,
 * As documented in http://docs.oracle.com/javase/8/docs/api/java/util/Random.html
 */
class Random
{
	private var seed:Int;
	private var haveNextNextGaussian:Bool = true;
	private var nextNextGaussian:Float;
	
	public function new(?seed:Int)
	{
		if (seed != null)
		{
			setSeed(seed);
		}
		else
		{
			seed = (Std.int(Math.random()) << 16);
		}
	}
	
	public function setSeed(seed:Int)
	{
		this.seed = seed;
		seed = (seed ^ Std.int(25214903917)) & ((1 << 48) - 1);
	}
	
	public function next(bits:Int)
	{
		//seed = Std.int((seed * 25214903917 + 0xB)) & ((1 << 48) - 1);
		//return Std.int(Std.int(seed) >> (48 - bits));
	}
	
	public function nextInt(bound:Int):Int
	{
		/*
		if (bound <= 0)
		{
			throw "bound must be positive";
		}

		if ((bound & -bound) == bound)  // i.e., bound is a power of 2
		{
			return Std.int(((bound * next(31)) >> 31));
		}

		var bits, val;
		do
		{
			bits = next(31);
			val = bits % bound;
		}
		while (bits - val + (bound - 1) < 0);
		return val;	
		*/
		return Std.random(bound);
	}
	
	public function nextLong():Float
	{
		//return (next(32) << 32) + next(32);
		return Math.random();
	}
	
	public function nextBoolean():Bool
	{
		return Std.random(1) > 0;
	}
	
	public function nextFloat():Float
	{
		//return next(24) / ((1 << 24));
		return Math.random();
	}
	
	public function nextGaussian() 
	{
		/*
		if (haveNextNextGaussian)
		{
			haveNextNextGaussian = false;
			return nextNextGaussian;
		}	
		else
		{
			var v1, v2, s;
			do
			{
				v1 = 2 * nextFloat() - 1;   // between -1.0 and 1.0
				v2 = 2 * nextFloat() - 1;   // between -1.0 and 1.0
				s = v1 * v1 + v2 * v2;
			}
			while (s >= 1 || s == 0);
			
			var multiplier:Float = Math.sqrt(-2 * Math.log(s)/s);
			nextNextGaussian = v2 * multiplier;
			haveNextNextGaussian = true;
			return v1 * multiplier;
		}
		*/
		return Math.random();
	}

	
}