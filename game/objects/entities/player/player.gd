class_name Player
extends Entity
enum State { IDLE, MOVE, DASH }
@onready var player_spr := $PlayerSprite
@onready var dash_particles := $PlayerSprite/dash_particles
var current_state: State = State.IDLE
var speed: float = 200.0
var tween: Tween
func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			idle_state(delta)
		State.MOVE:
			move_state(delta)






# States

func idle_state(delta: float) -> void:
	var input_dir = get_input()
	if input_dir != Vector2.ZERO:
		switch_state(State.MOVE)

func move_state(delta: float) -> void:
	var input_dir = get_input()
	if input_dir == Vector2.ZERO:
		switch_state(State.IDLE)
	else:
		velocity = input_dir * speed
		move_and_slide()



func get_input() -> Vector2:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		dir.x += 1
		$PlayerSprite.scale = Vector2(-1.0,1.0)
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
		$PlayerSprite.scale = Vector2(1.0,1.0)
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	return dir.normalized()
func switch_state(state : State):
	match state:
		State.IDLE:
			player_spr.play("idle")
			current_state = State.IDLE
		State.MOVE:
			player_spr.play("run")
			current_state = State.MOVE
		State.DASH:
			player_spr.play("atk") 
			current_state = State.DASH
func start_dash(target_pos: Vector2) -> void:
	switch_state(State.DASH)

	var dir = (target_pos - global_position).normalized()
	var dash_speed = 300.0
	var dash_time = 0.5
	var bounce_multiplier = 0.3
	var velocity = dir * dash_speed
	dash_particles.emitting = true
	var timer := get_tree().create_timer(dash_time)

	while timer.time_left > 0:
		var collision := move_and_collide(velocity * get_process_delta_time())
		if collision:
			# Reflect velocity to bounce
			velocity = velocity.bounce(collision.get_normal()) * bounce_multiplier
		await get_tree().process_frame

	switch_state(State.IDLE)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if current_state != State.DASH: # prevent spamming
			var mouse_pos = get_global_mouse_position()
			if self.global_position.x > mouse_pos.x:
				player_spr.scale = Vector2(1,1)
			else:
				player_spr.scale = Vector2(-1,1)
			start_dash(mouse_pos)
