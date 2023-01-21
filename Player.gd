extends KinematicBody2D
class_name Player


export(int) var JUMP_FORCE = -600
export(int) var DOUBLE_JUMP = -600
export(int) var JUMP_RELEASE_FORCE = -300
export(int) var MAX_SPEED = 300
export (int) var FRICION = 80
export (int) var ACCELERATION = 80
export (int) var GRAVITY = 30
export (int) var ADDITIONAL_FALL_GRAVITY = 15
#export (int) var ROLL_SPEED = 200

var is_paused = false

var velocity = Vector2.ZERO
#var roll_vector = Vector2.LEFT
var double_jump = 1

func _physics_process(delta):
	reset_scene()
	apply_gravity()
	$AnimatedSprite.animation = "Jump"
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input.x == 0:
		apply_friction()
#		$AnimatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
#		$AnimatedSprite.animation = "Walk"
		
		if input.x > 0:
			$AnimatedSprite.flip_h = false
		elif input.x < 0:
			$AnimatedSprite.flip_h = true
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
			double_jump = 1
	else:
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			velocity.y = DOUBLE_JUMP
			double_jump -= 1
			
		#$AnimatedSprite.animation = "Jump"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
#	Pause the Game
	if Input.is_action_just_pressed("ui_esc") and !is_paused:
		show_popup_menu()
	if Input.is_action_just_pressed("ui_esc") and is_paused:
		hide_popup_menu()
#		rolar:
#			
#		if Input.is_action_just_pressed("ui_roll"):
#			velocity.x = roll_vector * ROLL_SPEED
			
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY

	
	velocity = move_and_slide(velocity, Vector2.UP)

#ResetScene
func reset_scene():
	if Input.is_action_just_pressed("ui_r"):
		return get_tree().reload_current_scene()

func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 650)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

func pause_game():
	if Input.is_action_just_pressed("ui_esc") and !is_paused:
		$Camera2D/Control.show()
		is_paused = true
		get_tree().paused = true

	if Input.is_action_just_pressed("ui_esc") and is_paused:
		$Camera2D/Control.hide()
		is_paused = false
		get_tree().paused = false

func show_popup_menu():
	if Input.is_action_just_pressed("ui_esc") and !is_paused:
		$Camera2D/Control.show()
		is_paused = true
		get_tree().paused = true

func hide_popup_menu():
	$Camera2D/Control.hide()
	is_paused = false
	get_tree().paused = false
