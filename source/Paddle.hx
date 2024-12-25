package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Paddle extends FlxSprite {
	public static final PADDLE_WIDTH:Int = 12;
	public static final PADDLE_HEIGHT:Int = 90;

	public function new (x:Float, y:Float) {
		super(x, y);

		// Set dimensions of the paddle.
		this.setSize(PADDLE_WIDTH, PADDLE_HEIGHT);
		this.makeGraphic(PADDLE_WIDTH, PADDLE_HEIGHT, FlxColor.fromString("#708090"));

		this.immovable = true;
	}
}
