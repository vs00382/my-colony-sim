extends Node2D

@onready var ground_layer := $GroundLayer

func _ready():
	var map = MapGenerator.new()
	map.generate(ground_layer)
