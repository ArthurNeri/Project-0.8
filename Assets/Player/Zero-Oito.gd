class_name Player
extends KinematicBody2D

export(int) var MOVE_SPEED := 10
export(int) var RUN_SPEED := 25
export(int) var GRAVITY := 110
export(int) var FRICTION := 160
export(int) var ACCELERATION := 5
export(int) var JUMPFORCE := 7000

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum {
	IDLE,
	MOVE,
	RUN,
	JUMP,
	ROLL,
	FALL
}

var HP := 5
var state = MOVE
var velocity = Vector2.ZERO
var can_double_jump := true

func _ready():
	$AnimationTree.active = true

func _process(delta):
	reset_scene()
	change_state()
	match state:
		MOVE:
			move_state(delta)
			
#		JUMP:
#			jump_state(delta)
		
#		State.ROLL:
#			roll_state(delta)

		RUN:
			run_state(delta)

func move_state(delta):
	apply_gravity()
	var input = Vector2.ZERO
	var move := 0
	
	if Input.is_action_pressed("Left"):
		$AnimationPlayer.play("Walk")
		$"PlaceHolder(96X96)".flip_h = true
		move = -1
	elif Input.is_action_pressed("Right"):
		$AnimationPlayer.play("Walk")
		$"PlaceHolder(96X96)".flip_h = false
		move = 1
	else:
		$AnimationPlayer.play("Idle")
	
	input.x = move * MOVE_SPEED
	if input.x > RUN_SPEED:
		input.x = RUN_SPEED
		
	input = move_and_slide(input)
	
	if input != Vector2.ZERO:
		apply_acceleration(delta)
	
	else:
		apply_friction()
		
		
	var high = 0
	if Input.is_action_just_pressed("Jump"):
		high += 1
	else:
		if Input.is_action_just_pressed("Jump") and can_double_jump:
			high += 1
			can_double_jump = false
			
	input.y = high * JUMPFORCE * delta
	input = move_and_slide(input, Vector2.UP)
	if is_on_floor():
		high = 0
		can_double_jump = true


func jump_state(delta):
	apply_gravity()
	$"PlaceHolder(96X96)".flip_v = true
	var move = 0
	var velocity = Vector2.ZERO
	if Input.is_action_just_pressed("Jump"):
		velocity.y = JUMPFORCE
	else:
		if Input.is_action_just_pressed("Jump") and can_double_jump:
			velocity.y = JUMPFORCE
			can_double_jump = false
		
	if Input.is_action_pressed("Left"):
		$"PlaceHolder(96X96)".flip_h = true
		move = -1
	if Input.is_action_pressed("Right"):
		$"PlaceHolder(96X96)".flip_h = false
		move = 1
	velocity.x = move * MOVE_SPEED
	if velocity.x > 2 * RUN_SPEED:
		velocity.x = 2 * RUN_SPEED
		
	if velocity != Vector2.ZERO:
		apply_friction()
	else:
		apply_acceleration(velocity.x)


func run_state(delta):
	var move = 0
	var velocity = Vector2.ZERO
	apply_gravity()
	if Input.is_action_pressed("Left"):
		$"PlaceHolder(96X96)".flip_h = true
		move = -1
	if Input.is_action_pressed("Right"):
		$"PlaceHolder(96X96)".flip_h = false
		move = 1
	if move != 0:
		if Input.is_action_pressed("Run"):
			move = move + move
	velocity.x = move * MOVE_SPEED
	if velocity.x > 2 * RUN_SPEED:
		velocity.x = 2 * RUN_SPEED

	if velocity != Vector2.ZERO:
		apply_acceleration(velocity.x)
		velocity = velocity.move_toward(velocity * RUN_SPEED, ACCELERATION * delta)
		
	else:
		apply_friction()
		
	velocity = move_and_slide(velocity)


func change_state():
	var move = 0
#	if Input.is_action_just_pressed("Jump"):
#		state = JUMP
	if Input.is_action_just_pressed("Run"):
		state = RUN
	if move != 0:
		can_double_jump = true
		if Input.is_action_pressed("Left"):
			move = -1
		if Input.is_action_pressed("Right"):
			move = 1
		state = MOVE

#		state = IDLE

#	if !is_on_floor():
#		state = WALK

func apply_gravity():
	velocity.y = GRAVITY * MOVE_SPEED

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(delta):
	velocity = velocity.move_toward(velocity * RUN_SPEED, delta * ACCELERATION)

func move(delta):
	var velocity = Vector2.ZERO
	var move := 0
	
	if Input.is_action_pressed("Left"):
		$AnimationPlayer.play("Walk")
		$"PlaceHolder(96X96)".flip_h = true
		move = -1
	elif Input.is_action_pressed("Right"):
		$AnimationPlayer.play("Walk")
		$"PlaceHolder(96X96)".flip_h = false
		move = 1
	else:
		$AnimationPlayer.play("Idle")
	
	velocity.x = move * MOVE_SPEED
	if velocity.x > RUN_SPEED:
		velocity.x = RUN_SPEED
		
	velocity = move_and_slide(velocity)

func apply_acceleration_or_friction(delta, amount):
	if velocity != Vector2.ZERO:
		apply_acceleration(amount)
		velocity = velocity.move_toward(velocity * RUN_SPEED, ACCELERATION * delta)
	
	else:
		apply_friction()

func reset_scene():
	if Input.is_action_just_pressed("Roll"):
		get_tree().reload_current_scene()
	return null
