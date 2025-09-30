# ChaserBehavior.gd
extends EnemyBehaviour
class_name ChaserBehaviour
#скорость преследования
@export var speed: float = 60.0
##использование дешей врагом
@export var use_charging: bool = false
##скорость деша
@export var charge_speed: float = 200.0
##задержка перед дешем
@export var charge_prep_time: float = 0.5
##кулдаун деша
@export var charge_cooldown: float = 3.0

var charging := false
var can_charge := true
var vision_area: Area2D
var detected_player: Node2D = null

func setup(e):
	enemy = e
	vision_area = enemy.get_node("VisionArea")
	vision_area.body_entered.connect(_on_body_entered)
	vision_area.body_exited.connect(_on_body_exited)

func update(delta):
	if enemy:
		if not detected_player:
			enemy.velocity = Vector2.ZERO
			enemy.move_and_slide()
			return

		if charging:
			enemy.move_and_slide()
			return

		var dist = enemy.global_position.distance_to(detected_player.global_position)

		# Ренджа преследования моба (делаем меньше чтобы вблизи моб не юзал деш)
		var chase_radius = (vision_area.get_node("Collision").shape.radius*0.8)

		if dist < chase_radius:
			# проделываем путь к найденному игроку через нав агента
			enemy.nav_agent.target_position = detected_player.global_position
			var dir = (enemy.nav_agent.get_next_path_position() - enemy.global_position).normalized()
			enemy.velocity = dir * speed
			enemy.move_and_slide()
		else:
			if can_charge:
				_start_charge(enemy)

func _start_charge(enemy):
	charging = true
	can_charge = false
	enemy.velocity = Vector2.ZERO

	await enemy.get_tree().create_timer(charge_prep_time).timeout

	if detected_player:
		var dir = (detected_player.global_position - enemy.global_position).normalized()
		enemy.velocity = dir * charge_speed
		enemy.move_and_slide()

	# dash lasts short burst
		await enemy.get_tree().create_timer(0.3).timeout
		enemy.velocity = Vector2.ZERO
		charging = false

		# cooldown before next charge
		await enemy.get_tree().create_timer(charge_cooldown).timeout
		can_charge = true


func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		detected_player = body

func _on_body_exited(body: Node2D):
	if body == detected_player:
		detected_player = null


func cleanup():
	#очистка, чтобы таймеры не коллили уже удаленный instance
	if is_instance_valid(vision_area):
		if vision_area.body_entered.is_connected(_on_body_entered):
			vision_area.body_entered.disconnect(_on_body_entered)
		if vision_area.body_exited.is_connected(_on_body_exited):
			vision_area.body_exited.disconnect(_on_body_exited)
	detected_player = null
	charging = false
