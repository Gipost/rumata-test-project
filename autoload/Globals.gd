extends Node
var GameController
var LevelController
var Menu
var player

signal game_controller_ready

var room_seed
var total_coins = 10
var game_load:bool = true
func _ready() -> void:
	#загрузка сейва
	setup_savefile()
func restart_run():
	GameController = null
	
func setup_savefile():
	if game_load and SavesManager.get_savefile():
		SavesManager.load_seed()
	else: game_load = false
