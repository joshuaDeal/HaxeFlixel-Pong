package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.sound.FlxSound;

class Ball extends FlxSprite {
	private static final SIZE:Int = 12;
	private static final INITIAL_SPEED:Int = 200;
	private static final SPEED_INCREMENT:Int = 100;
	private var speed:Int = INITIAL_SPEED;
	private var velocityX:Float;
	private var velocityY:Float;
	private var rally:Int;
	private var bell:FlxSound = FlxG.sound.load("assets/sounds/bell.ogg");
	private var beep:FlxSound = FlxG.sound.load("assets/sounds/lowest-plip.ogg");

	public function new(x:Float, y:Float) {
		super(x, y);

		this.setSize(SIZE, SIZE);
		this.makeGraphic(SIZE, SIZE, FlxColor.fromString("#708090"));

		resetBall();
	}

	public function resetBall():Void {
		// Reset speed and rally
		rally = 0;
		speed = INITIAL_SPEED;

		// Return the ball to the center.
		this.x = FlxG.width / 2;
		this.y = FlxG.height / 2;

		// Set ball to travel in random direction within a specified range.
		var num = Math.random();
		var agnle:Float;

		if (num < 0.5) {
			agnle = Math.random() * (60) + 120;
		}
		else {
			agnle = Math.random() * 120 - 60;
		}

		this.velocityX = Math.cos(agnle * Math.PI / 180) * speed;
		this.velocityY = Math.sin(agnle * Math.PI / 180) * speed;

		// Start moving the ball in set direction.
		this.velocity.x = velocityX;
		this.velocity.y = velocityY;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Check for top and bottom bounds.
		if (this.y < 0 || this.y > FlxG.height - this.height) {
			// Reverse Y velocity.
			this.velocity.y *= -1;
			beep.play(true);
		}

	}

	public function onPaddleHit():Void {
		// Get current angle of movement.
		var angle = Math.atan2(velocityY, velocityX);

		// Reverse X direction.
		this.velocity.x *= -1;

		// Add randomness to Y direction.
		var offset = Math.random() * (Math.PI / 6) - (Math.PI / 12);
		var newAngle = angle + offset;

		rally++;

		// Increase speed every 4 rallies.
		if (rally > 1 && rally % 4 == 0) {
			speed = speed + SPEED_INCREMENT;

			bell.play();

			// Recalculate velocity based on speed and random angle.
			this.velocityX = Math.cos(newAngle) * speed;
			this.velocityY = Math.sin(newAngle) * speed;

			// Set new adjusted velocities.
			this.velocity.x = this.velocityX;
			this.velocity.y = this.velocityY;
		} else {
			// Y velocity should change using the random angle each time this function is called. X only needs to change when the speed changes.
			this.velocityY = Math.sin(newAngle) * speed;
			this.velocity.y = this.velocityY;
		}
	}
}
