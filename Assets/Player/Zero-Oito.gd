extends KinematicBody2D


export(int) var SPEED = 450
export(int) var GRAVITY = 300
export(int) var FRICTION = 160
export(int) var MAX_SPEED = 600
export(int) var ACCELERATION = 120
export(int) var JUMPFORCE = 300

var state = State.WALK
var velocity = Vector2.ZERO
var can_double_jump = true
enum State {JUMP, WALK, ROLL}


func _physics_process(delta):
	match state:
		State.WALK:
			move_state(delta)
			
		State.JUMP:
			jump_state(delta)
		
#		State.ROLL:
#			roll_state(delta)


func move_state(delta):
	var input = Vector2.ZERO
	can_double_jump = true
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	apply_gravity()

	if input.x != 0:
		apply_acceleration(input.x)
		
	else:
		apply_friction()
		
	if Input.is_action_just_pressed("ui_up"):
		state = State.JUMP
	if Input.is_action_just_pressed("ui_r"):
		state = State.ROLL


func jump_state(amount):
	velocity.y = JUMPFORCE
	
	if is_on_floor():
		state = State.WALK
	elif Input.is_action_pressed("ui_up") && can_double_jump:
		velocity.y = JUMPFORCE



func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_gravity():
	velocity.y = GRAVITY
	velocity.y = min(velocity.y, 650)
