extends Node2D

@export var players: Array[player]
@export var current_player = -1
@export var debug = false

@onready var prev_player_label = $PreviousPlayer/MarginContainer/RichTextLabel
@onready var curr_player_label = $CurrentPlayer/MarginContainer/RichTextLabel
@onready var next_player_label = $NextPlayer/MarginContainer/RichTextLabel
@onready var camera = get_parent()

const boilerplate: String = "[center]"
var started = false
var parent


func start():
	if !debug:
		players.shuffle()
	parent = get_parent().get_parent()
	change_turn()
	started = true	


func _process(delta):
	if started:
		if Input.is_action_just_pressed("Skip_Turn"):
			change_turn()

		if parent.active_character != null:
			camera.position = parent.active_character.position


func did_someone_win():
	var players_with_mice = []
	for player in players:
		var living_mice = []
		for mouse in player.mice:
			if !mouse.dead:
				living_mice.append(mouse)
		if living_mice.size() > 0:
			players_with_mice.append(player)
	# If only one player has mice, they have won!
	if players_with_mice.size() > 1:
		return false
	return true


func change_turn():
	if did_someone_win():
		parent.won()
		return
	set_next_player()
	set_active_mouse()


func set_active_mouse():
	if parent.active_character != null:
		parent.active_character.deactivate_weapon_if_active()
		parent.active_character.active = false
	var mouse = players[current_player].get_next_mouse()
	if mouse == null:
		change_turn()
	else:
		parent.active_character = mouse
		mouse.active = true


func set_next_player():
	# Handle all the label swapping and edge cases.
	if current_player == players.size()-1:
		current_player = 0
	else:
		current_player += 1
	curr_player_label.text = boilerplate + "[wave]Current Player\n" + players[current_player].team_name

	if current_player == 0:
		prev_player_label.text = boilerplate + "Previous Player\n" + players[players.size()-1].team_name
	else:
		prev_player_label.text = boilerplate + "Previous Player\n" + players[current_player].team_name

	if current_player == players.size()-1:
		next_player_label.text = boilerplate + "Next Player\n" + players[0].team_name
	else:
		next_player_label.text = boilerplate + "Next Player\n" + players[current_player + 1].team_name

