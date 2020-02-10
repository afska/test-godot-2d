extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func update_score(score):
	$ScoreLabel.text = str(score)

func show_game_over():
	show_message("Game Over")

	yield($MessageTimer, "timeout") # wait until MessageTimer's timeout

	$MessageLabel.text = "Dodge the Creeps!"
	$MessageLabel.show()

	yield(get_tree().create_timer(1), "timeout") # wait 1 second

	$StartButton.show()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
