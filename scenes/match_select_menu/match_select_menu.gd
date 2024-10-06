extends Node2D


@onready var player1 = {
	"team_name": $Menu/MarginContainer/HBoxContainer/PlayerSetup1/VBoxContainer/TextEdit,
	"team_color": $Menu/MarginContainer/HBoxContainer/PlayerSetup1/VBoxContainer/ColorPickerButton,
	"mouse_count": $Menu/MarginContainer/HBoxContainer/PlayerSetup1/VBoxContainer/MouseCountOption,
	"ui": $Menu/MarginContainer/HBoxContainer/PlayerSetup1
}

@onready var player2 = {
	"team_name": $Menu/MarginContainer/HBoxContainer/PlayerSetup2/VBoxContainer/TextEdit,
	"team_color": $Menu/MarginContainer/HBoxContainer/PlayerSetup2/VBoxContainer/ColorPickerButton,
	"mouse_count": $Menu/MarginContainer/HBoxContainer/PlayerSetup2/VBoxContainer/MouseCountOption,
	"ui": $Menu/MarginContainer/HBoxContainer/PlayerSetup2
}

@onready var player3 = {
	"team_name": $Menu/MarginContainer/HBoxContainer/PlayerSetup1/VBoxContainer/TextEdit,
	"team_color": $Menu/MarginContainer/HBoxContainer/PlayerSetup3/VBoxContainer/ColorPickerButton,
	"mouse_count": $Menu/MarginContainer/HBoxContainer/PlayerSetup3/VBoxContainer/MouseCountOption,
	"ui": $Menu/MarginContainer/HBoxContainer/PlayerSetup3
}

@onready var player4 = {
	"team_name": $Menu/MarginContainer/HBoxContainer/PlayerSetup4/VBoxContainer/TextEdit,
	"team_color": $Menu/MarginContainer/HBoxContainer/PlayerSetup4/VBoxContainer/ColorPickerButton,
	"mouse_count": $Menu/MarginContainer/HBoxContainer/PlayerSetup4/VBoxContainer/MouseCountOption,
	"ui": $Menu/MarginContainer/HBoxContainer/PlayerSetup4
}

var players


func _ready():
	players = [player1, player2, player3, player4]


func _on_option_button_item_selected(index:int):
	for player in players:
		player.ui.visible = false
	# Plus two because we don't include a single person option and 
	index += 2
	for i in index:
		players[i].ui.visible = true


func _on_play_button_pressed():
	var active_player_data = []
	for single_player in players:
		if single_player.ui.visible == true:
			var temp = player.new()		
			temp.team_name = single_player.team_name.get_text()
			temp.team_color = single_player.team_color.get_pick_color()
			temp.mouse_count = single_player.mouse_count.get_selected()+1
			active_player_data.append(temp)

	# Store all the data in globals so we can transition the scene.
	Globals.match_setup_data = {
		"players": active_player_data
	}

	# Select the map
	var selected_level = $Menu/MapSelect/MapOptionButton.get_selected_id()
	if selected_level == 0:
		get_tree().change_scene_to_file("res://scenes/battle_ground/desolate_dunes.tscn")
	elif selected_level == 1:
		get_tree().change_scene_to_file("res://scenes/battle_ground/erdtree.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/battle_ground/battle_ground.tscn")


func _on_map_option_button_item_selected(index:int):
	$Menu/MapSelect/MapSprite.frame = index
