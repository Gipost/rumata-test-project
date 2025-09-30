extends Node2D
@export var GenController : GenerationController
@export var tilemap : TileMapLayer
@export var PlayerScene : PackedScene
@export var CoinScene : PackedScene
@export var EnemyScenes: Dictionary = {load("res://game/scenes/slime.tscn") : 1.0}
var passage
var PlayerNode
func _ready() -> void:
	Globals.LevelController = self
func on_gen_finished() -> void:
	PlayerNode = GenController.spawn_player(PlayerScene,$entities)
	GenController.spawn_coins(CoinScene,$interactibles)
	GenController.spawn_enemies(5,EnemyScenes,$entities)
	passage = GenController.spawn_passage(load("res://game/scenes/Passage.tscn"),$interactibles)
	
