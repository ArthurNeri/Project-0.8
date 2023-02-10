class_name Player
extends KinematicBody2D

export(int) var MOVE_SPEED = 10
export(int) var RUN_SPEED = 25
export(int) var GRAVITY = 120
export(int) var FRICTION = 160
export(int) var ACCELERATION = 5
export(int) var JUMPFORCE = -700

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum {
	IDLE,
	WALK,
	RUN,
	JUMP,
	ROLL,
	FALL
}

var HP = 5
var state = WALK
var velocity = Vector2.ZERO
var can_double_jump = true

func _ready():
	$AnimationTree.active = true

func _process(delta):
	reset_scene()
	change_state()
	match state:
		WALK:
			move_state(delta)
			
		JUMP:
			jump_state(delta)
		
#		State.ROLL:
#			roll_state(delta)

		RUN:
			run_state(delta)

func move_state(delta):
	apply_gravity()
	
	var input = Vector2.ZERO
	var move = 0
	if move != 0:
		$AnimationPlayer.travel("Walk")
	else:
		$AnimationPlayer.play("Idle")
	
	if Input.is_action_pressed("Left"):
		$"PlaceHolder(96X96)".flip_h = true
		move = -1
	if Input.is_action_pressed("Right"):
		$"PlaceHolder(96X96)".flip_h = false
		move = 1
		
	input.x = move * MOVE_SPEED
	if input.x > RUN_SPEED:
		input.x = RUN_SPEED
		
	velocity = move_and_slide(velocity)

	if input != Vector2.ZERO:
		apply_acceleration(input.x)
		input = input.move_toward(input * RUN_SPEED, ACCELERATION * delta)
		
	else:
		apply_friction()


func jump_state(delta):
	var input = Vector2.ZERO
	var high = 0
	if Input.is_action_pressed("Jump"):
		can_double_jump = true
		if Input.is_action_pressed("Jump") and can_double_jump:
			can_double_jump = false
			high += 1
		high = 1
		input.y = high * JUMPFORCE

	var move = 0
	if Input.is_action_pressed("Left"):
		$"PlaceHolder(96X96)".flip_h = true
		move = -1
	if Input.is_action_pressed("Right"):
		$"PlaceHolder(96X96)".flip_h = false
		move = 1
		
	input.x = move * MOVE_SPEED
	if input.x > RUN_SPEED:
		input.x = RUN_SPEED
		
	velocity = move_and_slide(velocity)

func run_state(delta):
	var move = 0
	var input = Vector2.ZERO
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
	input.x = move * MOVE_SPEED
	if input.x > 2 * RUN_SPEED:
		input.x = 2 * RUN_SPEED

	if input != Vector2.ZERO:
		apply_acceleration(input.x)
		input = input.move_toward(input * RUN_SPEED, ACCELERATION * delta)
		
	else:
		apply_friction()
		
	velocity = move_and_slide(velocity)


func change_state():
	var move = 0
	var high = 0
	if Input.is_action_just_pressed("Jump"):
		state = JUMP
	if Input.is_action_just_pressed("Run"):
		state = RUN
		if Input.is_action_pressed("Left"):
			move = -1
		if Input.is_action_pressed("Right"):
			move = 1
		
	if is_on_floor():
		if move != 0:
			if Input.is_action_pressed("Run"):
				state = RUN
		state = WALK
		high = 0

#		state = IDLE

#	if !is_on_floor():
#		state = WALK

func apply_gravity():
	velocity.y = GRAVITY * MOVE_SPEED 

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, RUN_SPEED * amount, ACCELERATION)


func reset_scene():
	if Input.is_action_just_pressed("Roll"):
		get_tree().reload_current_scene()
