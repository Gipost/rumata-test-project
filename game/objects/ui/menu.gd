extends Control
enum States {POPUP,VICTORY,DEATH}
var CurrentState : States = States.POPUP
@onready var Result_label := $Result_label
func _ready():
	Globals.Menu = self
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_button") and CurrentState == States.POPUP:
		visible = !visible
		get_tree().paused = !get_tree().paused


func _on_retry_btn_pressed() -> void:
	Globals.restart_run()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/scenes/Game.tscn")

func switch_state(State:States):
	match State:
		States.VICTORY:
			get_tree().paused = true
			visible = true
			CurrentState = States.VICTORY
			Result_label.visible = true
			Result_label.text = "You won!"
			
		States.DEATH:
			get_tree().paused = true
			visible = true
			CurrentState = States.DEATH
			Result_label.visible = true
			Result_label.text = " You died! \n Try again?"
