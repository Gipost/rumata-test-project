extends Control
var dont_show_again: bool = false
@onready var checkbox := $Control/CheckBox
func _ready() -> void:
	dont_show_again = !Globals.show_tutor 
	if dont_show_again:
		visible = false
	else:
		get_tree().paused = true




func _on_exit_btn_pressed() -> void:
	if checkbox.button_pressed == true:
		Globals.show_tutor = false
	visible = false
	get_tree().paused = false
	
