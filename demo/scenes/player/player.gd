extends CharacterBody2D

@export var GRAVITY: float = 1800.0
@export var MAX_SPEED: float = 240.0
@export var ACCELERATION: float = 2600.0
@export var FRICTION: float = 2200.0
@export var SPRINT_MULT: float = 1.6
@export var JUMP_VELOCITY: float = -720.0
@export var MAX_FALL_SPEED: float = 1400.0

@export var COYOTE_TIME: float = 0.12
@export var JUMP_BUFFER_TIME: float = 0.12

var facing_right: bool = true
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

func _ready():
	if not is_in_group("player"):
		add_to_group("player")
	attack_area.monitoring = false

func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y = min(velocity.y + GRAVITY * delta, MAX_FALL_SPEED)
	else:
		if velocity.y > 0:
			velocity.y = 0

	# input
	var input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var is_sprinting = Input.is_action_pressed("sprint")
	var target_speed = MAX_SPEED * (SPRINT_MULT if is_sprinting else 1.0)
	var desired_vel_x = input_dir * target_speed

	if abs(desired_vel_x) > 0.01:
		velocity.x = move_toward(velocity.x, desired_vel_x, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# jump buffer
	if Input.is_action_just_pressed("ui_up"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer = max(0.0, jump_buffer_timer - delta)

	# coyote
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer = max(0.0, coyote_timer - delta)

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# flip
	if input_dir > 0:
		facing_right = true
		sprite.flip_h = false
	elif input_dir < 0:
		facing_right = false
		sprite.flip_h = true

	# attack
	if Input.is_action_just_pressed("attack"):
		_do_attack()

	_update_animation()
	# use CharacterBody2D move_and_slide() without args
	move_and_slide()

func _do_attack():
	attack_area.monitoring = true
	await get_tree().create_timer(0.12).timeout
	attack_area.monitoring = false

func _update_animation():
	if not is_on_floor():
		if velocity.y < 0:
			sprite.animation = "jump"
		else:
			sprite.animation = "fall"
	else:
		if abs(velocity.x) < 10:
			sprite.animation = "idle"
		else:
			if abs(velocity.x) > MAX_SPEED * 0.9 and sprite.frames.has_animation("run_fast"):
				sprite.animation = "run_fast"
			else:
				sprite.animation = "run"
