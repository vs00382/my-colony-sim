extends Node2D

@export var SPEED: float = 4.0             # tiles per second
const CELL_SIZE: float = 16.0

var path: Array[Vector2i] = []
var current_index: int = 0

func _ready():
	snap_to_grid()

func snap_to_grid():
	var cell := Vector2i(global_position.x / CELL_SIZE, global_position.y / CELL_SIZE)
	global_position = Vector2(cell.x * CELL_SIZE, cell.y * CELL_SIZE)

func follow_path(new_path: Array[Vector2i]):
	path = new_path
	current_index = 0

func _physics_process(delta: float) -> void:
	if current_index >= path.size():
		return

	var cell: Vector2i = path[current_index]
	var target_pos: Vector2 = Vector2(cell.x * CELL_SIZE, cell.y * CELL_SIZE)
	var dir: Vector2 = target_pos - global_position
	var distance := dir.length()

	# Step size (scaled automatically for diagonal)
	var step: float = SPEED * CELL_SIZE * delta

	# Snap to tile center when close enough
	if distance <= step:
		global_position = target_pos
		current_index += 1
		return

	# Move smoothly toward target (handles diagonal cases)
	global_position += dir.normalized() * step
