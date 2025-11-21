extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var pawn = $Pawn

var astar := AStarGrid2D.new()

func _ready():
	setup_astar()

func setup_astar():
	astar.region = Rect2i(0, 0, 100, 100)  # adjust to your map size
	astar.cell_size = Vector2(32, 32)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# global → tilemap local
		var mouse_pos_local = ground_layer.to_local(event.position)
		var target_cell = ground_layer.local_to_map(mouse_pos_local)

		var pawn_local = ground_layer.to_local(pawn.global_position)
		var start_cell = ground_layer.local_to_map(pawn_local)

		print("Start:", start_cell, " Target:", target_cell)

		var path = astar.get_id_path(start_cell, target_cell)

		if not path.is_empty():
			pawn.follow_path(path)
		else:
			print("NO PATH")
