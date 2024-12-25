package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

class PlayState extends FlxState {
	private static final PADDLE_SPEED:Int = 10;
	private static final AI_SPEED:Int = 5;
	private var paddle1:Paddle;
	private var paddle2:Paddle;
	private var ball:Ball;
	private var player1Score:Int = 0;
	private var player2Score:Int = 0;
	private var hud:HUD;
	public var goal:Int = 5;
	private var menu:Menu;
	private var inGame:Bool = false;
	public var paddle1Ai:Bool = true;
	private var paddle2Ai:Bool = true;
	private var beep1:FlxSound = FlxG.sound.load("assets/sounds/plip.ogg");
	private var beep2:FlxSound = FlxG.sound.load("assets/sounds/low-plip.ogg");
	private var beep3:FlxSound = FlxG.sound.load("assets/sounds/high-plip.ogg");
	private var chime:FlxSound = FlxG.sound.load("assets/sounds/chime.ogg");

	override public function create() {
		super.create();

		// Show the mouse.
		FlxG.mouse.visible = true;

		// Set background color.
		bgColor = getRandomColor();

		// Add player 1 paddle to state.
		paddle1 = new Paddle(20, FlxG.height / 2 - Paddle.PADDLE_HEIGHT / 2);
		add(paddle1);

		// Add player 2 paddle to state.
		paddle2 = new Paddle(FlxG.width - Paddle.PADDLE_WIDTH - 20, FlxG.height / 2 - Paddle.PADDLE_HEIGHT / 2);
		add(paddle2);

		// Add ball to state.
		ball = new Ball(FlxG.width / 2, FlxG.height / 2);
		add(ball);

		// Create HUD.
		hud = new HUD();

		// Add menu.
		menu = new Menu(this);
		add(menu);
	}

	private function getRandomColor():Int {
		// Define range so that colors are 'muted' by keeping r, g, and b values close together.
		var r:Int, g:Int, b:Int;

		do {
			var base:Int = Math.floor(Math.random() * 128);
			var variance:Int = Math.floor(Math.random() * 64);

			r = Std.int(Math.min(255, base + Math.floor(Math.random() * variance)));
			g = Std.int(Math.min(255, base + Math.floor(Math.random() * variance)));
			b = Std.int(Math.min(255, base + Math.floor(Math.random() * variance)));
		} while (colorSimilarCheck(r, g, b));

		return FlxColor.fromRGB(r, g, b);
	}

	// Check the difference between inputted color and paddleColor.
	private function colorSimilarCheck(r:Int, g:Int, b:Int) {
		var paddleColor = {r: 112, g: 128, b: 144};

		var diff = Math.abs(r - paddleColor.r) + Math.abs(g - paddleColor.g) + Math.abs(b - paddleColor.b);

		return diff < 75;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Basic paddle1 controls.
		if (!paddle1Ai) {
			if (FlxG.keys.pressed.W && paddle1.y > 0) {
				paddle1.y -= PADDLE_SPEED;
			}
			else if (FlxG.keys.pressed.S && paddle1.y < FlxG.height - paddle1.height) {
				paddle1.y += PADDLE_SPEED;
			}
		} else {
			// AI for paddle1.
			if (paddle1.y + paddle1.height / 2 < ball.y) {
				paddle1.y += AI_SPEED;
			} else if (paddle1.y + paddle1.height / 2 > ball.y) {
				paddle1.y -= AI_SPEED;
			}

			// Limit paddle1 movement within bounds of screen.
			paddle1.y = Math.max(0, Math.min(FlxG.height - paddle1.height, paddle1.y));
		}

		// Basic paddle2 controls.
		if (!paddle2Ai) {
			if (FlxG.keys.pressed.UP && paddle2.y > 0) {
				paddle2.y -= PADDLE_SPEED;
			}
			else if (FlxG.keys.pressed.DOWN && paddle2.y < FlxG.height - paddle2.height) {
				paddle2.y += PADDLE_SPEED;
			}
		} else {
			// AI for paddle2.
			if (paddle2.y + paddle2.height / 2 < ball.y) {
				paddle2.y += AI_SPEED;
			} else if (paddle2.y + paddle2.height / 2 > ball.y) {
				paddle2.y -= AI_SPEED;
			}

			// Limit paddle2 movement within bounds of screen.
			paddle2.y = Math.max(0, Math.min(FlxG.height - paddle2.height, paddle2.y));
		}

		// Check for collision between ball and paddles
		if (FlxG.overlap(ball, paddle1)) {
			// Move the ball outside of the collision area to that it won't get "stuck" to the paddle.
			ball.x = paddle1.x + paddle1.width;
			ball.onPaddleHit();
			beep1.play(true);
		}

		if (FlxG.overlap(ball, paddle2)) {
			// Move the ball outside of the collision area to that it won't get "stuck" to the paddle.
			ball.x = paddle2.x - ball.width;
			ball.onPaddleHit();
			beep2.play(true);
		}

		// Check if a player scores/misses.
		if (ball.x < 0) {
			if (inGame) {
				player2Score++;
				hud.addScoreToPlayer2();
				beep3.play();
			}

			ball.resetBall();
		}
		else if (ball.x > FlxG.width) {
			if (inGame) {
				player1Score++;
				hud.addScoreToPlayer1();
				beep3.play();
			}

			ball.resetBall();
		}

		// Update HUD
		hud.update();

		// Check if a player has won.
		if (player1Score == goal) {
			gameOver("player1");
		}
		else if (player2Score == goal) {
			gameOver("player2");
		}
	}

	override public function draw():Void {
		super.draw();
		hud.draw();
	}

	public function gameOver(winner):Void {
		chime.play();
		hud.displayWinner(winner);
		player1Score = 0;
		player2Score = 0;
		add(menu);
		inGame = false;
		paddle1Ai = true;
		paddle2Ai = true;
		bgColor = getRandomColor();
		FlxG.mouse.visible = true;
	}

	public function resetGame():Void {
		player1Score = 0;
		player2Score = 0;
		paddle1.y = FlxG.height / 2 - Paddle.PADDLE_HEIGHT / 2;
		paddle2.y = FlxG.height / 2 - Paddle.PADDLE_HEIGHT / 2;
		ball.resetBall();
		hud.resetScore();
		inGame = true;
		paddle1Ai = menu.player1Ai;
		paddle2Ai = menu.player2Ai;
		FlxG.mouse.visible = false;
	}
}
