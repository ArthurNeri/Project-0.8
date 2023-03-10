extends Control

var is_paused = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_esc"):
		is_paused = !is_paused
		var check = is_paused
		set_is_paused(check)

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Resume_pressed():
	is_paused = false

func _on_Quit_pressed():
	get_tree().quit()
