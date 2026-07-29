extends CharacterBody2D

@export var SPEED: float = 80.0
@export var START_HEALTH: int = 1
var health: int

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var patrol_a: Node2D = $PatrolA
@onready var patrol_b: Node2D = $PatrolB

var target_pos: Vector2

func _ready():
	health = START_HEALTH
	target_pos = patrol_b.global_position

func _physics_process(delta):
	var dir = (target_pos - global_position).normalized()
	velocity.x = dir.x * SPEED
	move_and_slide()
	_check_reached()

func _check_reached():
	if global_position.distance_to(target_pos) < 8:
		if target_pos == patrol_b.global_position:
			target_pos = patrol_a.global_position
		else:
			target_pos = patrol_b.global_position

func take_damage(amount: int = 1):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()
	var mgr = get_node_or_null("/root/demo_game_manager")
	if mgr:
		mgr.add_score(10)
