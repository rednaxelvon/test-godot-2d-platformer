# Demo: 5-level Godot 4.7 platformer

This is an autonomous demo project placed in demo/ so it won't affect your main project.

How to open:
1. In Godot 4.7 choose "Import" -> open the folder `demo/` as a project, or use "Open Existing Project" and select `demo/project.godot`.
2. Open `scenes/Level1.tscn` and run the project.

Included:
- 5 simple levels: scenes/Level1..Level5.tscn
- Player scene: scenes/player/Player.tscn with player.gd
- Enemy scene: scenes/mobs/Enemy.tscn with enemy.gd
- Simple UI: scenes/ui/MainMenu.tscn, HUD.tscn, GameOver.tscn
- Placeholder SVG sprites (256x256) in assets/sprites/ (player, enemy, coin, tiles, cloud, heart_full, heart_empty)

Notes:
- I included simple placeholder SVG images (256x256) so you can open and test immediately. Replace them with your own PNGs later if you want.
- Input Map used in demo: ui_left (A/Left), ui_right (D/Right), ui_up (Space/W/Up), attack (J/Z), sprint (Shift), pause (Esc).
