package;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.display.Sprite;

class Menu extends FlxGroup {
	private var playButton:FlxButton;
	private var player1Toggle:FlxButton;
	private var player2Toggle:FlxButton;
	public var player1Ai:Bool = false;
	public var player2Ai:Bool = true;
	private var playState:PlayState;
	private var goalUpButton:FlxButton;
	private var goalButton:FlxButton;
	private var goalDownButton:FlxButton;
	private var goal:Int = 5;

	public function new(playState:PlayState) {
		super();
		this.playState = playState;

		// Create background.
		var background:FlxSprite = new FlxSprite(0,0);
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 200));
		add(background);

		// Create play button.
		playButton = new FlxButton(FlxG.width / 2 - 50, FlxG.height / 2 - 10, "Play", onPlayButtonClick);
		playButton.color = FlxColor.WHITE;
		add(playButton);

		// Create player 1 button.
		player1Toggle = new FlxButton(30, 100, getPlayerButtonText(player1Ai), onPlayer1Toggle);
		add(player1Toggle);

		// Create player 2 button.
		player2Toggle = new FlxButton(FlxG.width - 130, 100, getPlayerButtonText(player2Ai), onPlayer2Toggle);
		add(player2Toggle);

		// Create goal buttons.
		goalUpButton = new FlxButton(FlxG.width / 2 - 50, FlxG.height / 2 + 20, "+", onGoalUpButtonClick);
		goalButton = new FlxButton(FlxG.width / 2 - 50, FlxG.height / 2 + 40, getGoalButtonText(), onGoalUpButtonClick);
		goalDownButton = new FlxButton(FlxG.width / 2 - 50, FlxG.height / 2 + 60, "-", onGoalDownButtonClick);
		add(goalUpButton);
		add(goalButton);
		add(goalDownButton);

		// Create title.
		var title:FlxText = new FlxText(0, FlxG.height / 2 - 50, FlxG.width, "PONG");
		title.setFormat(null, 32, FlxColor.WHITE, "center");
		add(title);

		// Create controls message.
		var controls:FlxText = new FlxText(0, FlxG.height / 2 + 70, FlxG.width - 40, "Controls:\nPlayer 1: W/S\nPlayer 2: Up/Down");
		controls.setFormat(null, 20, FlxColor.WHITE, "left");
		add(controls);
	}

	private function onPlayButtonClick():Void {
		// Hide menu.
		FlxG.state.remove(this);

		// Start a new game.
		playState.resetGame();
	}

	private function getPlayerButtonText(toggle:Bool):String {
		return toggle ? "CPU":"Human";
	}

	private function getGoalButtonText():String {
		return Std.string(goal);
	}

	private function onGoalUpButtonClick():Void {
		if (goal < 100) {
			goal = goal + 5;
		} else {
			goal = 5;
		}

		goalButton.label.text = getGoalButtonText();
		playState.goal = goal;
	}

	private function onGoalDownButtonClick():Void {
		if (goal > 5) {
			goal = goal - 5;
		} else {
			goal = 100;
		}

		goalButton.label.text = getGoalButtonText();
		playState.goal = goal;
	}

	private function onPlayer1Toggle():Void {
		player1Ai = !player1Ai;
		player1Toggle.text = getPlayerButtonText(player1Ai);
	}

	private function onPlayer2Toggle():Void {
		player2Ai = !player2Ai;
		player2Toggle.text = getPlayerButtonText(player2Ai);
	}
}
