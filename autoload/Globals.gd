extends Node
var GameController
var LevelController
var Menu
var player
var game_config: GameConfig = load("res://configs/game_config.tres")
var enemy_config: EnemyConfig = load("res://configs/enemy_config.tres")
var show_tutor: bool = true
signal game_controller_ready

var room_seed

var game_load:bool = true
func _ready() -> void:
	#загрузка сейва
	setup_savefile()
func restart_run():
	GameController = null
	
func setup_savefile():
	if game_load and SavesManager.get_savefile():
		SavesManager.load_seed()
		SavesManager.load_tutor_state()
	else: game_load = false
