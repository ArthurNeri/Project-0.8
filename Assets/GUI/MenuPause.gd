extends Control

var is_paused := false

func _unhandled_input(event):
	if event.is_action_pressed("ui_esc"):
		is_paused = !is_paused
		pause(is_paused)

func _on_Button_pressed():
	is_paused = !is_paused
	pause(is_paused)

func _on_Button2_pressed():
	is_paused = !is_paused
	pause(is_paused)
	get_tree().reload_current_scene()

func pause(value):
	get_tree().paused = value
	visible = value
