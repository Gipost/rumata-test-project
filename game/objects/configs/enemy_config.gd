extends Resource
class_name EnemyConfig
@export_category("Slime settings:")
##скорость слизня в преследовании
@export var slime_Speed : float = 60.0
##юзает ли слизень деш
@export var slime_useCharge : bool = true
##скорость деша
@export var slime_ChargeSpeed : float = 200.0
##время перед дешем
@export var slime_ChargePrep : float = 0.5
##откат деша в секундах
@export var slime_ChargeCooldown : float = 1.5
##патрулирует ли слизень
@export var slime_Patrolling : bool = true
##дистанция отрезка патрулирования
@export var slime_Patrol_distance : int = 64
##скорость во время патрулирования
@export var slime_Patrol_speed: float = 60

@export_category("Minotaur settings:")
@export var minotaur_Speed : float = 80.0
##юзает ли слизень деш
@export var minotaur_useCharge : bool = false
##скорость деша
@export var minotaur_ChargeSpeed : float = 200.0
##время перед дешем
@export var minotaur_ChargePrep : float = 0.5
##откат деша в секундах
@export var minotaur_ChargeCooldown : float = 1.5
##патрулирует ли слизень
@export var minotaur_Patrolling : bool = true
##дистанция отрезка патрулирования
@export var minotaur_Patrol_distance : int = 64
##скорость во время патрулирования
@export var minotaur_Patrol_speed: float = 80
