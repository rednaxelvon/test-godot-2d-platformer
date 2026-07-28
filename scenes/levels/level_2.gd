# level_base.gd (присоедини к корню каждого уровня)
extends Node2D

@onready var spawn_point = $SpawnPoint

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.global_position = spawn_point.global_position
		# Здоровье уже хранится в GameManager, UI обновится по сигналу
	# Обновим UI при старте (если ещё не подписан)
	GameManager.health_changed.emit(GameManager.player_health)
	GameManager.score_changed.emit(GameManager.score)
