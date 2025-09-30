class_name  GenerationController

extends Node2D
@export var room_generator : RoomBaseGenerator

func _on_tile_map_layer_ready(source: Node) -> void:
	room_generator.tilemap = source 
	room_generator.setup()


#Спавнер игрока на случайном свободном тайле
func spawn_player(player_scene:PackedScene,entities_path:Node2D):
	var pos = room_generator.get_random_free_tile()
	var player = player_scene.instantiate()
	entities_path.add_child(player)
	player.global_position = pos
	return player

#спавнер монеток
func spawn_coins(CoinScene : PackedScene,interactibles_path:Node2D):
	for coin in Globals.total_coins:
		var pos = room_generator.get_random_free_tile()
		var coin_node = CoinScene.instantiate()
		interactibles_path.add_child(coin_node)
		coin_node.global_position = pos

#спавнер врагов
func spawn_enemies(enemy_count:int,EnemyScenes:Dictionary,enemies_path:Node2D):
	for i in enemy_count:
		var pos = room_generator.get_random_free_tile()
		var enemy_scene = WeightHelper.pick_weighted(EnemyScenes)
		var enemy_node = enemy_scene.instantiate()
		enemies_path.add_child(enemy_node)
		enemy_node.global_position = pos

#спавнер прохода 
func spawn_passage(PassageScene : PackedScene,interactibles_path:Node2D):
	var pos = room_generator.get_random_free_tile()
	var passage_node = PassageScene.instantiate()
	interactibles_path.add_child(passage_node)
	passage_node.global_position = pos
	return passage_node





#--Загрузка объектов--#
func load_entities(player_scene:PackedScene,entity_path:Node2D):
	var data = SavesManager.get_savefile()
	if data:
		var player = player_scene.instantiate()
		var pdata = data["player"]
		player.global_position = Vector2(pdata["pos"][0], pdata["pos"][1])
		entity_path.add_child(player)
		# restore enemies
		for enemy_data in data["enemies"]:
			var enemy_scene = get_enemy_scene(enemy_data["type"])
			var enemy = enemy_scene.instantiate()
			enemy.global_position = Vector2(enemy_data["pos"][0], enemy_data["pos"][1])
			entity_path.add_child(enemy)
		return player

func load_coins(CoinScene : PackedScene,interactibles_path:Node2D):
	var data = SavesManager.get_savefile()
	if data:
		for coin_pos in data["coins"]:
			var coin = CoinScene.instantiate()
			coin.global_position = Vector2(coin_pos[0], coin_pos[1])
			interactibles_path.add_child(coin)

func load_passage(PassageScene : PackedScene,interactibles_path:Node2D):
	var data = SavesManager.get_savefile()
	if data:
		var passage = PassageScene.instantiate()
		var pdata = data["passage"]
		passage.global_position = Vector2(pdata["pos"][0], pdata["pos"][1])
		passage.visible = pdata["visible"]
		interactibles_path.add_child(passage)
		return passage


#helper на получение сцены врага
func get_enemy_scene(entity_ID:String):
	match entity_ID:
		"Slime":
			return load("res://game/scenes/slime.tscn")
