extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var pawn: Node2D = $Pawn

var astar := AStarGrid2D.new()

func _ready():
	build_astar_from_tilemap()

func build_astar_from_tilemap():
	# Use tilemap’s actual tile size
	astar.cell_size = ground_layer.tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS

	# Get all used tiles in the tilemap
	var used := ground_layer.get_used_cells()
	if used.is_empty():
		push_warning("TileMapLayer has no tiles!")
		return

	# Determine bounding box of painted tiles
	var min_x = used[0].x
	var min_y = used[0].y
	var max_x = used[0].x
	var max_y = used[0].y

	for c in used:
		min_x = min(min_x, c.x)
		min_y = min(min_y, c.y)
		max_x = max(max_x, c.x)
		max_y = max(max_y, c.y)

	astar.region = Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)

	# Mark all walkable tiles
	for c in used:
		astar.set_point_solid(c, false)

	# Mark all non-painted tiles inside region as blocked
	for x in astar.region.size.x:
		for y in astar.region.size.y:
			var c = Vector2i(min_x + x, min_y + y)
			if not used.has(c):
				astar.set_point_solid(c, true)

	astar.update()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_local = ground_layer.to_local(event.position)
		var target_cell = ground_layer.local_to_map(mouse_local)

		var pawn_local = ground_layer.to_local(pawn.global_position)
		var start_cell = ground_layer.local_to_map(pawn_local)

		var path = astar.get_id_path(start_cell, target_cell)
		print("PATH:", path)

		if path.is_empty():
			print("NO PATH")
			return

		pawn.follow_path(path)
