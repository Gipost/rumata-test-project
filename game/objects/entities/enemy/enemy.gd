class_name Enemy
extends Entity
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var behaviour: EnemyBehaviour  # ИИ моба
@export var animated_spr : AnimatedSprite2D
var target: Node2D = null


func _ready():
	if behaviour:
		behaviour.setup(self)

func _physics_process(delta):
	if behaviour:
		behaviour.update(delta)
	_update_animation()
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


func _update_animation() -> void:
	if velocity.length() > 0.1:
		if animated_spr.sprite_frames.has_animation("walk"):
			if not animated_spr.is_playing() or animated_spr.animation != "walk":
				animated_spr.play("walk")
	else:
		if animated_spr.sprite_frames.has_animation("idle"):
			if not animated_spr.is_playing() or animated_spr.animation != "idle":
				animated_spr.play("idle")

	if velocity.x != 0:
		animated_spr.scale.x = -1*sign(velocity.x) 
