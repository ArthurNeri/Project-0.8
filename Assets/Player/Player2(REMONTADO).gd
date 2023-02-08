extends KinematicBody2D
class_name Player2


###VARIABLES###{
export(int) var JUMP_FORCE = -650
export(int) var JUMP_RELEASE_FORCE = -300
export(int) var MAX_SPEED = 400
export (int) var FRICION = 80
export (int) var ACCELERATION = 80
export (int) var GRAVITY = 30
export (int) var ADDITIONAL_FALL_GRAVITY = 15
export (int) var ROLL_SPEED = 440

#}


###STATE_LIST###
enum State{
	MOVE,
	ATTACK,
	ROLL,
	JUMP
}

#}

###BASIC_VAR###
var state = State.MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
var double_jump = 1


###FUNCTION_MOVEMENTS###
func _physics_process(delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

#	if Input.is_action_just_pressed("ui_roll"):
#		apply_roll()

	if input.x == 0:
		apply_friction()
		$AnimatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		$AnimatedSprite.animation = "Walk"
		
		if input.x > 0:
			$AnimatedSprite.flip_h = false
		elif input.x < 0:
			$AnimatedSprite.flip_h = true
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
			
#		rolar:
#			
#	else:
		#$AnimatedSprite.animation = "Jump"
#		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
#			velocity.y = JUMP_RELEASE_FORCE
			
			
		
#		if velocity.y > 0:
#			velocity.y += ADDITIONAL_FALL_GRAVITY
	
#	velocity = move_and_slide(velocity, Vector2.UP)


#func apply_roll():
#	velocity.x = ROLL_SPEED * roll_vector
#	velocity.y = min(velocity.x, -80)

func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 650)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)


###FUNCTION_ANIMATIONS###


###STATES###
#func _process(delta):
#	match state:
#		MOVE:
#			move_state()

#		ATTACK:
#			attack_state()

#		ROLL:
#			roll_state()

#		JUMP:
#			jump_state()

#func move_state():
#	var input = Vector2.ZERO
#	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	input = input.normalized()







