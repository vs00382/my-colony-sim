extends Node2D

const SPEED: float = 4.0      # tiles per second
const CELL_SIZE: float = 32.0

var target_cell: Vector2i = Vector2i.ZERO
var is_moving: bool = false

func move_to(cell: Vector2i) -> void:
	target_cell = cell
	is_moving = true

func _physics_process(delta: float) -> void:
	if not is_moving:
		return

	var target_pos = Vector2(target_cell) * CELL_SIZE
	var dir = target_pos - global_position

	if dir.length() < 1.0:
		global_position = target_pos
		is_moving = false
		return

	global_position += dir.normalized() * SPEED * CELL_SIZE * delta
