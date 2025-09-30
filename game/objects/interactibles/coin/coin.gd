class_name Coin
extends Interactible

func item_pickUP(body: Node2D) -> void:
	if body is Player:
		Globals.GameController.collected_coins += 1
		Globals.GameController.emit_signal("coin_collected")
		body.coin_sfx()
		if Globals.GameController.collected_coins == Globals.GameController.total_coins:
			Globals.GameController.start_victory_cutscene()
		self.queue_free()
