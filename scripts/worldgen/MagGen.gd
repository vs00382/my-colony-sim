class_name MapGenerator
extends RefCounted

# your constants go here
const SOURCE_ID := 0
const WATER   := Vector2i(4, 20)
const SAND    := Vector2i(15, 3)
const GRASS   := Vector2i(11, 2)
const FOREST  := Vector2i(9, 12)
const ROCK    := Vector2i(5, 1)

const MAP_WIDTH := 200
const MAP_HEIGHT := 200

func generate(tilemap: TileMapLayer):
	var noise := FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.015
	noise.fractal_octaves = 4
	
	for x in MAP_WIDTH:
		for y in MAP_HEIGHT:
			var n := noise.get_noise_2d(x, y)
			var atlas := get_tile_from_noise(n)
			tilemap.set_cell(Vector2i(x, y), SOURCE_ID, atlas, 0)


func get_tile_from_noise(n: float) -> Vector2i:
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
