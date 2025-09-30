class_name Coin
extends Interactible

func item_pickUP(body: Node2D) -> void:
	if body is Player:
		Globals.GameController.collected_coins += 1
		Globals.GameController.emit_signal("coin_collected")
		self.queue_free()
