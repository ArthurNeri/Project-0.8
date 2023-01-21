extends PopupMenu

var is_paused = false

func check_jump():
	if Input.is_action_just_pressed("ui_up"):
		print("you jumped")
#func _ready():
#	check_jump()
#	hide_popup_menu()
#	show_popup_menu()


#var paused = show_popup_menu()
#var resumed = hide_popup_menu()
#var check = check_jump()


func pressed():
	if Input.is_action_just_pressed("ui_esc"):
		print("fui apertado")

func show_popup_menu():
	if Input.is_action_just_pressed("ui_esc") and is_paused == false:
		$Camera2D/Control.show()
		is_paused = true
		get_tree().paused = true

func hide_popup_menu():
	if Input.is_action_just_pressed("ui_esc") and is_paused == true:
		$Camera2D/Control.hide()
		is_paused = false
		get_tree().paused = false
