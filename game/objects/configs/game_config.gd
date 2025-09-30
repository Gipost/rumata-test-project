extends Resource
class_name GameConfig
@export_category("Room settings:")
@export var room_width: int = 30
@export var room_height: int = 30
@export var enemy_count: int = 5
@export var total_coins: int = 10
@export_category("Player settings:")
@export var speed: float = 200.0
@export var dash_speed = 300.0
@export var dash_time = 0.5
@export var bounce_multiplier = 0.3
