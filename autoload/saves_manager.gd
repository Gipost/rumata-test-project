extends Node2D

#Сохраняем нужные нам параметры у нод в дикшинари
func save_game():
	var save_data = {}
	save_data["seed"] = Globals.room_seed
	
	var player = Globals.player
	if player:
		save_data["player"] = {
			"pos": [player.global_position.x, player.global_position.y],
			#собранные монеты
			"coins": Globals.GameController.collected_coins 
		}
	
	save_data["enemies"] = []
	for enemy in get_tree().get_nodes_in_group("enemies"):
		save_data["enemies"].append({
			#тип моба по entity_id
			"type": enemy.entity_id,
			"pos": [enemy.global_position.x, enemy.global_position.y]
		})
	
	save_data["coins"] = []
	for coin in get_tree().get_nodes_in_group("coins"):
		save_data["coins"].append([coin.global_position.x, coin.global_position.y])
	
	
	var passage = Globals.LevelController.passage
	if passage:
		save_data["passage"] = {
			"pos": [passage.global_position.x,passage.global_position.y],
			#проверка была ли сыграна уже катцена или нет
			"visible": passage.visible
		}
		
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

#читаем наш сейвфайл
func get_savefile():
	if not FileAccess.file_exists("user://savegame.json"):
		return 
	
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) != TYPE_DICTIONARY:
		return
	return data

func load_seed():
	var data = get_savefile()
	if data:
		Globals.room_seed = data["seed"]
