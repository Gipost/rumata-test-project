class_name Enemy
extends Entity
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var behaviour: EnemyBehaviour  # This will be a Resource
var target: Node2D = null

func _ready():
	if behaviour:
		behaviour.setup(self)
	
func _physics_process(delta):
	if behaviour:
		behaviour.update(delta)
#интеракт моба с игроком, деш наносит урон enemy, в остальных случаях урон получает игрок
func _on_contact_area_body_entered(body: Node2D) -> void:
	if body is Player:
		match body.current_state:
			Player.State.DASH:
				self.take_damage()
			_:
				body.take_damage()

#получение урона мобом
func take_damage():
	if behaviour:
		behaviour.cleanup()
	queue_free()
