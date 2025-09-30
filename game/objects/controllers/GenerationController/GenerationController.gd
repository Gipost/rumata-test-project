class_name  GenerationController

extends Node2D
@export var room_generator : RoomBaseGenerator

func _on_tile_map_layer_ready(source: Node) -> void:
	room_generator.tilemap = source 
	room_generator.setup()

func spawn_player(player_scene:PackedScene,entities_path:Node2D):
	var pos = room_generator.get_random_free_tile()
	var player = player_scene.instantiate()
	entities_path.add_child(player)
	player.global_position = pos
	return player
func spawn_coins(CoinScene : PackedScene,interactibles_path:Node2D):
	for coin in GameController.total_coins:
		var pos = room_generator.get_random_free_tile()
		var coin_node = CoinScene.instantiate()
		interactibles_path.add_child(coin_node)
		coin_node.global_position = pos
func spawn_enemies(enemy_count:int,EnemyScenes:Dictionary,enemies_path:Node2D):
	for i in enemy_count:
		var pos = room_generator.get_random_free_tile()
		var enemy_scene = WeightHelper.pick_weighted(EnemyScenes)
		var enemy_node = enemy_scene.instantiate()
		enemies_path.add_child(enemy_node)
		enemy_node.global_position = pos
