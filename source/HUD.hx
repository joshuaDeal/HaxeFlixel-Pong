package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import haxe.Timer;

class HUD {
	private var player1Score:Int;
	private var player2Score:Int;
	private var player1ScoreText:FlxText;
	private var player2ScoreText:FlxText;
	private var winText:FlxText;

	public function new() {
		player1Score = player2Score = 0;

		// Create score text objects.
		player1ScoreText = new FlxText(40, 20, 100, Std.string(player1Score));
		player1ScoreText.setFormat(null, 32, 0xFFFFFF, "left");

		player2ScoreText = new FlxText(FlxG.width - 140, 20, 100, Std.string(player2Score));
		player2ScoreText.setFormat(null, 32, 0xFFFFFF, "right");

		// Initialize winner text.
		winText = null;
	}

	public function update():Void {
		player1ScoreText.text = Std.string(player1Score);
		player2ScoreText.text = Std.string(player2Score);
	}

	public function draw():Void {
		player1ScoreText.draw();
		player2ScoreText.draw();

		if (winText != null) {
			winText.draw();
			Timer.delay(resetWinner, 5000);
		}
	}

	public function addScoreToPlayer1():Void {
		player1Score++;
	}

	public function addScoreToPlayer2():Void {
		player2Score++;
	}

	public function resetScore():Void {
		player1Score = 0;
		player2Score = 0;
	}

	private function resetWinner():Void {
		winText = null;
	}

	public function displayWinner(winner) {
		winText = new FlxText(0, FlxG.height / 2 - 130, FlxG.width, winner + " wins!");
		winText.setFormat(null, 20, 0xFFFFFF, "center");
	}
}
