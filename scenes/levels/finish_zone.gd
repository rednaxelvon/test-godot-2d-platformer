extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Можно остановить игрока, как раньше
		body.set_physics_process(false)
		body.velocity = Vector2.ZERO
		# Переходим на следующий уровень
		await get_tree().create_timer(0.5).timeout  # небольшая пауза
		GameManager.next_level()
