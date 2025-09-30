extends Node2D
@export var GenController : GenerationController
@export var tilemap : TileMapLayer
@export var PlayerScene : PackedScene
@export var CoinScene : PackedScene
@export var EnemyScenes : Array[PackedScene]
var PlayerNode
func on_gen_finished() -> void:
	PlayerNode = GenController.spawn_player(PlayerScene,$entities)
	GenController.spawn_coins(CoinScene,$interactibles)
	GenController.spawn_enemies(5,EnemyScenes,$entities)
