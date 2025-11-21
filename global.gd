extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var pawn: Node2D = $Pawn

var astar := AStarGrid2D.new()

func _ready():
	setup_astar()

func setup_astar():
	# Make grid larger than needed (fine for now)
	astar.region = Rect2i(0, 0, 300, 300)

	# Use your actual tile size
	astar.cell_size = ground_layer.tile_set.tile_size

	# Enable 8-direction connectivity
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS

	# Make all tiles walkable (not solid)
	for x in astar.region.size.x:
		for y in astar.region.size.y:
			astar.set_point_solid(Vector2i(x, y), false)

	astar.update()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_local: Vector2 = ground_layer.to_local(event.position)
		var target_cell: Vector2i = ground_layer.local_to_map(mouse_local)

		var pawn_local: Vector2 = ground_layer.to_local(pawn.global_position)
		var start_cell: Vector2i = ground_layer.local_to_map(pawn_local)

		var path = astar.get_id_path(start_cell, target_cell)
		print("PATH:", path)

		if path.is_empty():
			print("NO PATH!")
			return

		pawn.follow_path(path)
