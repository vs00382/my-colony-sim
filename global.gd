extends Node2D

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var pawn: Node2D = $Pawn

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Convert global mouse position to TileMapLayer local coordinates
		var mouse_pos_global = event.position
		var mouse_pos_local = ground_layer.to_local(mouse_pos_global)
		
		# Convert to grid cell
		var cell = ground_layer.local_to_map(mouse_pos_local)
		print("Clicking cell:", cell)
		
		# Initiate pawn movement
		pawn.move_to(cell)
