extends Node2D


@onready var spawn_points = $SpawnPoints.get_children()


func _on_water_body_entered(body:Node2D):
	if body.has_method("die"):
		body.die()
