extends Node2D
var total_coins : int = 10
var collected_coins : int = 0
signal coin_collected

func _ready() -> void:
	total_coins = Globals.total_coins
	Globals.GameController = self
	Globals.emit_signal("game_controller_ready")
