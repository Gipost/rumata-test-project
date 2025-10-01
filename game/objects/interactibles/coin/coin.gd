class_name Coin
extends Interactible

func item_pickUP(body: Node2D) -> void:
	if body is Player:
		if has_node("PickUpRange"):
			$PickUpRange.monitoring = false

		# tween to player
		var tween := create_tween()
		tween.tween_property(self, "global_position", body.global_position, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

		# кд перед исчезновением
		await get_tree().create_timer(0.2).timeout

		Globals.GameController.collected_coins += 1
		Globals.GameController.emit_signal("coin_collected")
		body.coin_sfx()

		if Globals.GameController.collected_coins == Globals.GameController.total_coins:
			Globals.GameController.start_victory_cutscene()

		queue_free()
