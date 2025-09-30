# EnemyBehavior.gd
extends Resource
class_name EnemyBehaviour

var enemy
@export var patrolling: bool = false
@export var patrol_distance: int = 64
@export var patrol_speed: float = 60.0
var _patrol_points: Array[Vector2] = []
var _current_patrol_index := 0
var _patrol_origin: Vector2

var vision_area: Area2D
var detected_player: Node2D = null

func setup(e):
	enemy = e
	setup_config()
	vision_area = enemy.get_node("VisionArea")
	vision_area.body_entered.connect(_on_body_entered)
	vision_area.body_exited.connect(_on_body_exited)
	#Добавляем позиции для патрулирования, условно моб идет вправо потом обратно влево и потом вверх/вниз
	if patrolling:
		_patrol_origin = enemy.global_position
		_patrol_points = [
			_patrol_origin + Vector2(patrol_distance, 0),   # right
			_patrol_origin,                                # back left
			_patrol_origin + Vector2(0, -patrol_distance), # up
			_patrol_origin,                                # back down
		]


#применение конфига при инициализации
func setup_config():
	match enemy.entity_id:
		"Slime":
			patrolling = Globals.enemy_config.slime_Patrolling
			patrol_distance = Globals.enemy_config.slime_Patrol_distance
			patrol_speed = Globals.enemy_config.slime_Speed
	setup_config_additional()

func setup_config_additional(): pass
func update(delta): 
	#В случае нахождения игрока отмена патруля
	if detected_player == null:
		update_patrol(delta)
	update_behaviour(delta)

#очистка в случае смерти моба
func cleanup(): 
	if is_instance_valid(vision_area):
		if vision_area.body_entered.is_connected(_on_body_entered):
			vision_area.body_entered.disconnect(_on_body_entered)
		if vision_area.body_exited.is_connected(_on_body_exited):
			vision_area.body_exited.disconnect(_on_body_exited)
	detected_player = null
	cleanup_additional()
#очистка для наследуемых классов
func cleanup_additional(): pass

func update_behaviour(delta): pass

#сама реализация патрулирования
func update_patrol(delta) -> void:
	
	if _patrol_points.is_empty():
		return

	var target = _patrol_points[_current_patrol_index]
	var dir = (target - enemy.global_position).normalized()
	enemy.velocity = dir * patrol_speed
	enemy.move_and_slide()

	# При колизии со стеной скип до след точки в пути
	for i in range(enemy.get_slide_collision_count()):
		var collision = enemy.get_slide_collision(i)
		if collision.get_collider() is TileMapLayer or collision.get_collider() is StaticBody2D:
			_switch_to_next_patrol_point()
			return

	if enemy.global_position.distance_to(target) < 4.0:
		_current_patrol_index = (_current_patrol_index + 1) % _patrol_points.size()

#helper
func _switch_to_next_patrol_point() -> void:
	_current_patrol_index = (_current_patrol_index + 1) % _patrol_points.size()

func _on_body_entered(body: Node2D):
	if body is Player:
		detected_player = body

func _on_body_exited(body: Node2D):
	if body == detected_player:
		detected_player = null
