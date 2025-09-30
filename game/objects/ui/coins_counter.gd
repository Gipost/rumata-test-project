extends Control
#счетчик монет 
@onready var counter_label : = $Label
func _ready() -> void:
	#присоединяем сигнал на сбор монеты после готовности game контроллера
	Globals.connect("game_controller_ready", _on_gc_ready)

func update_label():
	counter_label.text = str(Globals.GameController.collected_coins) + "/" + str(Globals.game_config.total_coins)

func _on_gc_ready():
	update_label()
	Globals.GameController.connect("coin_collected", update_label)
