extends ColorRect


func start():
	visible = true
	get_tree().paused = true


func _on_button_pressed():
	Globals.match_setup_data = {}
	get_tree().change_scene_to_file("res://scenes/match_select_menu/match_select_menu.tscn")