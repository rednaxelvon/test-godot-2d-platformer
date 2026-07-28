extends CanvasLayer

@onready var score_label: Label = $UIContainer/MainLayout/TopBar/ScoreLabel
@onready var hearts: Array[TextureRect] = [
	$UIContainer/MainLayout/TopBar/HeartsContainer/Heart1,
	$UIContainer/MainLayout/TopBar/HeartsContainer/Heart2,
	$UIContainer/MainLayout/TopBar/HeartsContainer/Heart3
]
@onready var lives_label: Label = $UIContainer/MainLayout/BottomBar/LivesLabel


# Ссылки на текстуры, чтобы не искать их каждый раз
var heart_full: Texture2D = preload("res://assets/sprites/heart_full.png")
var heart_empty: Texture2D = preload("res://assets/sprites/heart_empty.png")


func _ready():
	# Подписываемся на сигналы GameManager
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.health_changed.connect(_on_health_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	
	# При старте показываем текущие значения (важно при загрузке уровня)
	_on_score_changed(GameManager.score)
	_on_health_changed(GameManager.player_health)
	_on_lives_changed(GameManager.lives)

func _on_score_changed(new_score: int):
	score_label.text = "Score: %d" % new_score

func _on_health_changed(new_health: int):
	# Проходим по всем сердечкам и обновляем их текстуру
	for i in range(hearts.size()):
		if i < new_health:
			hearts[i].texture = heart_full
		else:
			hearts[i].texture = heart_empty

func _on_lives_changed(new_lives: int):
	lives_label.text = "Lives: %d" % new_lives
