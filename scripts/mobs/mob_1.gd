extends CharacterBody2D

@export var speed: float = 100.0
@export var direction: int = -1   # 1 или -1

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var hitbox: Area2D = $Hitbox

@onready var anim: AnimatedSprite2D = $AnimatedSprite

func _ready():
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta):
	# Гравитация
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0

	# Движение
	velocity.x = direction * speed

	# Разворот, если луч не видит пол (край платформы)
	if ray_cast.is_colliding() == false:
		direction *= -1
		$AnimatedSprite.flip_h = direction < 0
		# Смещаем луч вперёд при развороте, чтобы он смотрел в новом направлении
		ray_cast.target_position.x = abs(ray_cast.target_position.x) * direction
		
	# В _physics_process:
	if velocity.x != 0:
		anim.play("walk")
	else:
		anim.play("idle")
	anim.flip_h = direction < 0   # подбирай, как нужно

	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		GameManager.damage_player(1)
		# Опционально: отбросить игрока
		body.velocity = (body.global_position - global_position).normalized() * 300.0
