extends Node2D

var health_increase=25

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("body.name")
	
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(-health_increase)
