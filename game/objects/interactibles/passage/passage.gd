extends Interactible


func _on_reach_range_body_entered(body: Node2D) -> void:
	if visible and (body is Player):
		Globals.Menu.switch_state(Globals.Menu.States.VICTORY)
