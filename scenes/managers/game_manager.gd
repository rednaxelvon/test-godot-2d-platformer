extends Node

signal score_changed(new_score)
signal health_changed(new_health)
signal lives_changed(new_lives)       # новый сигнал
signal player_died                    # теперь означает "потеря жизни"
signal game_over                      # конец игры

var score: int = 0
var player_health: int = 3
var max_health: int = 3
var lives: int = 3                    # стартовое количество жизней
var current_level: int = 1

func add_score(amount: int):
	score += amount
	emit_signal("score_changed", score)

func damage_player(amount: int):
	player_health -= amount
	if player_health < 0:
		player_health = 0
	emit_signal("health_changed", player_health)
	if player_health == 0:
		lose_life()

func lose_life():
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives > 0:
		# Ещё есть жизни – восстанавливаем здоровье и перезапускаем уровень
		player_health = max_health
		emit_signal("health_changed", player_health)
		emit_signal("player_died")   # сигнал для перезапуска уровня
	else:
		emit_signal("game_over")

func reset_game():
	score = 0
	player_health = max_health
	lives = 3
	current_level = 1
	# Перезапустим игру с первого уровня
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")
	# Или показать главное меню

func next_level():
	current_level += 1
	var level_path = "res://scenes/levels/Level%d.tscn" % current_level
	if ResourceLoader.exists(level_path):
		get_tree().change_scene_to_file(level_path)
	else:
		get_tree().change_scene_to_file("res://scenes/ui/win_screen.tscn")

func _ready():
	game_over.connect(_on_game_over)

func _on_game_over():
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
