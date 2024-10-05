extends Node2D


func _on_water_body_entered(body:Node2D):
	if body.has_method("die"):
		body.die()
