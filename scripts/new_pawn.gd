extends SceneTree

func _init():
	var root = Node2D.new()
	root.name = "Pawn"

	var sprite = Sprite2D.new()
	sprite.texture = load("res://icon.png")
	root.add_child(sprite)

	var packed := PackedScene.new()
	var result = packed.pack(root)

	if result != OK:
		push_error("Failed to pack scene")
		quit()

	var save_result = ResourceSaver.save(packed, "res://Pawn.tscn")

	if save_result != OK:
		push_error("Failed to save Pawn.tscn")
	else:
		print("Pawn.tscn created!")

	quit()
