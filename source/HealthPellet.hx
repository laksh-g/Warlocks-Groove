import flixel.FlxSprite;

class HealthPellet extends Item
{
	public function new(x:Float, y:Float, unlocked:Bool)
	{
		super(x, y);
		RESTORE = 5;
		// loadGraphic("assets/images/Door.png", true, 32, 32);
		// animation.add("l", [2], 1, false);
		// animation.add("u", [1], 1, false);
	}

	override function update(elapsed:Float)
	{
		// if (_unlocked)
		// {
		// 	animation.play("u");
		// }
		// else
		// {
		// 	animation.play("l");
		// }
		super.update(elapsed);
	}
}
