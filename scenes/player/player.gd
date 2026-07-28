extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var max_jumps = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = max_jumps
var invulnerable = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite
@onready var invul_timer = $InvulTimer

func _ready():
	add_to_group("player")
	GameManager.player_died.connect(_on_player_died)

func _physics_process(delta):
	# Гравитация и прыжок (как раньше)
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_left = max_jumps
		velocity.y = 0

	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = jump_velocity
		jumps_left -= 1

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		# Разворачиваем спрайт в зависимости от направления
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# --- Управление анимациями ---
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		#else:
			#anim.play("fall")   # если есть отдельная анимация падения
	else:
		if direction != 0:
			anim.play("walk")
		else:
			anim.play("idle")
	# ---

	move_and_slide()

func _on_invul_timer_timeout():
	invulnerable = false

func _on_player_died():
	# Отключаем управление
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	# Ждём и перезапускаем уровень (или можно сразу)
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
