extends KinematicBody2D
class_name OldPlayer


export(int) var JUMP_FORCE = -600
export(int) var DOUBLE_JUMP = -600
export(int) var JUMP_RELEASE_FORCE = -300
export(int) var MAX_SPEED = 300
export (int) var FRICION = 80
export (int) var ACCELERATION = 80
export (int) var GRAVITY = 70
export (int) var ADDITIONAL_FALL_GRAVITY = 25
export (int) var HEALTH = 5
#export (int) var ROLL_SPEED = 200

var state = State.WALK
var velocity = Vector2()
#var roll_vector = Vector2.LEFT
var double_jump := 1

enum State {WALK, RUN, ATTACK, ROLL, BLOCK, JUMP}

func _process(delta):
	change_state()
	match state:
		State.WALK:
			walk_state(delta)
		State.RUN:
			run_state(delta)
		State.JUMP:
			jump_state(delta)
		State.ATTACK:
			pass
		State.ROLL:
			pass
		State.BLOCK:
			pass

func walk_state(delta):
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if velocity.x == 0:
		$AnimationPlayer.play("Idle")
		apply_friction()
	else:
		$AnimationPlayer.play("Walk")
		apply_acceleration(velocity.x)
		
		if velocity.x > 0:
			$"PlaceHolder(96X96)".flip_h = false
		elif velocity.x < 0:
			$"PlaceHolder(96X96)".flip_h = true
	
	_move_and_slide()
	apply_gravity(delta)
	
	if Input.is_action_pressed("Run"):
		state = State.RUN
	if Input.is_action_just_pressed("ui_up"):
		state = State.JUMP

#	ROLAR:
#	if Input.is_action_just_pressed("Roll"):
#		velocity.x = roll_vector * ROLL_SPEED


func jump_state(delta):
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
		
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if velocity.x == 0:
		$AnimationPlayer.play("Idle")
		apply_friction()
	else:
		$AnimationPlayer.play("Walk")
		apply_acceleration(velocity.x)
		
		if velocity.x > 0:
			$"PlaceHolder(96X96)".flip_h = false
		elif velocity.x < 0:
			$"PlaceHolder(96X96)".flip_h = true

	_move_and_slide()
	apply_gravity(delta)
	
func run_state(delta):
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = velocity.x * 2 

	if velocity.x == 0:
		$AnimationPlayer.play("Idle")
		apply_friction()
	else:
		$AnimationPlayer.play("Walk")
		apply_acceleration(velocity.x)
		
		if velocity.x > 0:
			$"PlaceHolder(96X96)".flip_h = false
		elif velocity.x < 0:
			$"PlaceHolder(96X96)".flip_h = true

	_move_and_slide()
	apply_gravity(delta)
	


#	CONTINUAR NESSE VÍDEO:
#		https://www.youtube.com/watch?v=PEsxqii5r_I






#func _physics_process(delta):
#	reset_scene()
#	apply_gravity()
#	$AnimatedSprite.play("Jump")
#	var velocity = Vector2.ZERO
#	velocity.x = velocity.get_action_strength("ui_right") - velocity.get_action_strength("ui_left")
#
#	if velocity.x == 0:
#		apply_friction()
#	else:
#		apply_acceleration(velocity.x)
#		
#		if velocity.x > 0:
#			$AnimatedSprite.flip_h = false
#		elif velocity.x < 0:
#			$AnimatedSprite.flip_h = true
#	
#	if is_on_floor():
#		if Input.is_action_just_pressed("ui_up"):
#			velocity.y = JUMP_FORCE
#			double_jump = 1
#	else:
#		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
#			velocity.y = DOUBLE_JUMP
#			double_jump -= 1

			
		#$AnimatedSprite.animation = "Jump"
#		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
#			velocity.y = JUMP_RELEASE_FORCE
#		
#		if velocity.y > 0:
#			velocity.y += ADDITIONAL_FALL_GRAVITY
#
#		rolar:
#			
#		if Input.is_action_just_pressed("ui_roll"):
#			velocity.x = roll_vector * ROLL_SPEED
			

	
#	velocity = move_and_slide(velocity, Vector2.UP)

func reset_scene():
	if Input.is_action_just_pressed("ui_r"):
		return get_tree().reload_current_scene()

	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

func change_state():
	var move = 0
	if Input.is_action_just_pressed("Jump"):
		state = State.JUMP
	if Input.is_action_just_pressed("Run"):
		state = State.RUN
	if move != 0:
		state = State.WALK
	if Input.is_action_just_released("Run"):
		state = State.WALK

func apply_gravity(delta):
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, 650)

func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP)

func health():
	pass


func _on_HealthBall_HP_UP(old_value, new_value):
	pass
