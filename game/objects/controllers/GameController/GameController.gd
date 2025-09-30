extends Node2D
var player
var total_coins : int = 10
var collected_coins : int = 0
signal coin_collected

@onready var camera = $CutsceneCam
var secret_passage # path to passage
@export var camera_pan_time: float = 2.0
@export var pause_time: float = 1.5

func _ready() -> void:
	total_coins = Globals.game_config.total_coins
	Globals.GameController = self
	if Globals.game_load:
		load_collected_coins()
	Globals.emit_signal("game_controller_ready")


#загрузка монет с сейва
func load_collected_coins():
	var data = SavesManager.get_savefile()
	if data:
		var pdata = data["player"]
		collected_coins = pdata["coins"]


#--CUTSCENE STUFF--#
var cutscene_running := false

func start_victory_cutscene():
	secret_passage = Globals.LevelController.passage
	if cutscene_running: 
		return
	Globals.player.switch_state(Globals.player.State.CUTSCENE)
	cutscene_running = true
	#Чтобы меню не работало во время катцены
	Globals.Menu.process_mode = PROCESS_MODE_PAUSABLE
	get_tree().paused = true
	camera.global_position = Globals.player.global_position
	Globals.player.player_cam.enabled = false
	camera.enabled = true
	secret_passage.visible = true
	await _pan_camera_to(secret_passage.global_position)
	await get_tree().create_timer(pause_time).timeout
	#Плавные переходы камеры к проходу и обратно к игроку
	if Globals.player:
		await _pan_camera_to(Globals.player.global_position)
		camera.enabled = false
		Globals.player.player_cam.enabled = true
		Globals.player.switch_state(Globals.player.State.IDLE)
	cutscene_running = false
	get_tree().paused = false
	#возращаем в работу меню
	Globals.Menu.process_mode = PROCESS_MODE_ALWAYS

#плавный переход камеры через tween
func _pan_camera_to(target_pos: Vector2) -> Signal:
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "global_position", target_pos, camera_pan_time)
	return tween.finished
