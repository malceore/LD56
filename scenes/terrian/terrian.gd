extends Node2D


@onready var spawn_points = $SpawnPoints.get_children()
@onready var terrain_polygons = $StaticBody2D/Polygon2D
@onready var graphic_polygons = $Polygon2D


func _on_water_body_entered(body:Node2D):
	if body.has_method("die"):
		body.die()

func clip(poly):
	var offset_poly = Transform2D(0, poly.global_position) * poly.polygon
	var res = Geometry2D.clip_polygons(terrain_polygons.polygon, offset_poly)
	graphic_polygons.polygon = res[0]
	terrain_polygons.set_deferred("polygon", res[0])
