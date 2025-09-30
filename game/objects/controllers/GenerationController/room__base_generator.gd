
class_name  RoomBaseGenerator
extends Node2D
##размер по x
@export var room_width: int = 30
##размер по y
@export var room_height: int = 30
var tilemap: TileMapLayer
##Генерировать ли комнату при инициализации, для premade комнат если таковые будут
@export var gen_room_on_start : bool = true
signal generation_finished
const TERRAIN_WALL := 0
const TERRAIN_GROUND := 1
const Dirt_Tile := Vector2i(0,11)
const Wall_tile := Vector2i(0,0)

var noise := FastNoiseLite.new()
@export var noise_scale: float = 0.1
## Плотность стен
@export var wall_threshold: float = 0.0005
func setup():
	setup_noise()
	if gen_room_on_start:
		generate_room(room_width, room_height)
	emit_signal("generation_finished")

func setup_noise():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = noise_scale
	#проверка на то загрузился ли сид
	if Globals.room_seed == null:
		if Globals.game_load:
			print_debug("No seed loaded!")
		noise.seed = randi()
		Globals.room_seed = noise.seed
	else: 
		noise.seed = Globals.room_seed 


#заполняем землю шумом
func apply_ground_noise(w: int, h: int):
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			var pos := Vector2i(x, y)
			var n := noise.get_noise_2d(x, y)
			if n < wall_threshold:
				tilemap.set_cells_terrain_connect([pos],0, TERRAIN_GROUND,false)

func generate_room(w: int, h: int):
	generate_wall_borders(w,h)
	apply_ground_noise(w,h)
	fill_wall_cells(w,h)

#генерим стены на границе карты
func generate_wall_borders(w: int, h: int):
	# очистка карты перед генерацией
	tilemap.clear()
	for y in range(h):
		for x in range(w):
			var pos := Vector2i(x, y)

			# если граница комнаты → стена
			if x == 0 or x == w - 1 or y == 0 or y == h - 1:
				tilemap.set_cells_terrain_connect([pos],0, TERRAIN_WALL,false)

#заполняем оставшиеся позиции на карте стенами, после генерации земли шумом
func fill_wall_cells(w: int, h: int):
	for y in range(h):
		for x in range(w):
			var pos := Vector2i(x, y)
			var cell_id = tilemap.get_cell_source_id(pos)
			if cell_id == -1:
				tilemap.set_cells_terrain_connect([pos],0, TERRAIN_WALL,false)

#случайный свободный тайл
func get_random_free_tile():
	var ground_tiles: Array[Vector2i] = []
	for y in range(room_height):
		for x in range(room_width):
			var pos := Vector2i(x, y)
			var data = tilemap.get_cell_source_id(pos)
			if data != -1:
				var atlas_coords = tilemap.get_cell_atlas_coords(pos)
				if atlas_coords == Dirt_Tile:  
					ground_tiles.append(pos)

	if ground_tiles.is_empty():
		push_warning("No ground tiles found!")
		return null
	
	var random_pos = ground_tiles[randi() % ground_tiles.size()]
	
	var world_pos = tilemap.map_to_local(random_pos)
	if is_tile_free(world_pos):
		return world_pos
	else:
		return get_random_free_tile()

#helper на проверку свободен ли тайл 
func is_tile_free(world_pos: Vector2i) -> bool:

	var params := PhysicsPointQueryParameters2D.new()
	params.position = world_pos
	params.collide_with_areas = true
	params.collide_with_bodies = true

	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_point(params, 1) 
	return result.is_empty()
