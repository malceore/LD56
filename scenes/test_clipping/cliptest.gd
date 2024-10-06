extends Node2D

@onready var terrain_polygons = $StaticBody2D/Polygon2D
@onready var graphic_polygons = $Polygon2D
@onready var clipped_polygons = $ClippedPolygons

func clip(poly):
	# var offset_poly = Polygon2D.new()
	# var new_values = []
	# for point in poly.polygon:
	# 	#print(point + poly.global_position)
	# 	new_values.append(point + poly.global_position)
	var offset_poly = Transform2D(0, poly.global_position) * poly.polygon
	# print(poly.polygon)
	# print(offset_poly)

	# offset_poly.polygon = PackedVector2Array(new_values)
	var res = Geometry2D.clip_polygons(graphic_polygons.polygon, offset_poly)
	print(res[0])
	print(graphic_polygons.polygon)
	graphic_polygons.polygon = res[0]
	terrain_polygons.set_deferred("polygon", res)


func _on_button_pressed():
	clip(clipped_polygons)

func _on_button_2_pressed():
	get_tree().reload_current_scene()