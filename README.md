# My Godot Platformer

Godot version: 4.7

Краткое описание:
- 2D пиксель‑арт платформер, прототип: 2 уровня, игрок, один тип врага, монеты, переход между уровнями.

Структура:
- project.godot
- scenes/          — .tscn сцены (Main.tscn, Player.tscn и т.д.) и скрипты
- assets/
  - sprites/
  - audio/
- levels/

Как запустить:
1. Скачать репозиторий.
2. Открыть Godot 4.7 -> Open Project -> выбрать папку с проектом.
3. Проверить Input Map в Project Settings -> Input Map. Рекомендуемые действия:
   - ui_left, ui_right, ui_up (прыжок), ui_down (при необходимости)
   - attack
   - sprint
   - pause

Примечания:
- Папка .import не включается в репозиторий.
- Если появятся большие ассеты (>100 MB), используйте Git LFS.
