class_name Coin
extends Interactible

func item_pickUP(body: Node2D) -> void:
	if body is Player:
		GameController.collected_coins += 1
		GameController.emit_signal("coin_collected")
		self.queue_free()
