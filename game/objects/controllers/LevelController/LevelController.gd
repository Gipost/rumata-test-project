extends Node2D

@export var GenController : GenerationController
@export var tilemap : TileMapLayer
@export var PlayerScene : PackedScene
@export var CoinScene : PackedScene
##дикшинари с мобами и весами для определения шанса их спавнов
@export var EnemyScenes: Dictionary = {load("res://game/scenes/slime.tscn") : 0.5, load("res://game/scenes/minotaur.tscn") : 0.5}

var passage
var PlayerNode

func _ready() -> void:
	Globals.LevelController = self

func on_gen_finished() -> void:
	#генерация объектов на карте
	if !Globals.game_load:
		PlayerNode = GenController.spawn_player(PlayerScene,$entities)
		GenController.player_node = PlayerNode
		GenController.spawn_coins(CoinScene,$interactibles)
		GenController.spawn_enemies(Globals.game_config.enemy_count,EnemyScenes,$entities)
		passage = await GenController.spawn_passage(load("res://game/scenes/Passage.tscn"),$interactibles)
	#загрузка объектов с сейва
	else: 
		PlayerNode = GenController.load_entities(PlayerScene,$entities)
		GenController.player_node = PlayerNode
		GenController.load_coins(CoinScene,$interactibles)
		passage = GenController.load_passage(load("res://game/scenes/Passage.tscn"),$interactibles)
