extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer

# Tile atlas coords for your terrain
const SOURCE_ID := 0
const WATER   := Vector2i(4, 20)
const SAND    := Vector2i(15, 3)
const GRASS   := Vector2i(11, 2)
const FOREST  := Vector2i(9, 12)
const ROCK    := Vector2i(5, 1)

# World size
const MAP_WIDTH := 200
const MAP_HEIGHT := 200

func _ready():
	generate_world()


func generate_world():
	var noise := FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.015
	noise.fractal_octaves = 4

	for x in MAP_WIDTH:
		for y in MAP_HEIGHT:
			var n := noise.get_noise_2d(float(x), float(y))
			var atlas := get_tile_from_noise(n)

			# (source_id, atlas_coords, alternative=0)
			ground_layer.set_cell(Vector2i(x, y), SOURCE_ID, atlas, 0)


func get_tile_from_noise(n: float) -> Vector2i:
	# Tune thresholds as you like
	if n < -0.35:
		return WATER
	elif n < -0.15:
		return SAND
	elif n < 0.25:
		return GRASS
	elif n < 0.55:
		return FOREST
	else:
		return ROCK
