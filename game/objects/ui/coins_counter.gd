extends Control

@onready var counter_label : = $Label
func _ready() -> void:
	update_label()
	GameController.connect("coin_collected",update_label)
func update_label():
	counter_label.text = str(GameController.collected_coins) + "/" + str(GameController.total_coins)
