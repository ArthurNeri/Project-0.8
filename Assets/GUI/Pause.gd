extends Control

var is_paused = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_esc"):
		is_paused = !is_paused
		pause(is_paused)
		visible = is_paused

func _on_Resume_pressed():
	is_paused = !is_paused
	pause(is_paused)

func pause(is_paused):
	get_tree().paused = is_paused
