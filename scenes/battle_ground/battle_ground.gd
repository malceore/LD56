extends Node2D

@export var active_character: CharacterBody2D = null 
@export var debug = false
@onready var turn_handler = $Camera2D/TurnHandler
@onready var spawn_points = $Terrain.spawn_points

signal event_bus(transmitter, event)

var mouse_scene = preload("res://scenes/character/character.tscn")


func dummy_team_date():
	var player1 = player.new()
	player1.team_name = "Cheese2MeetU"
	player1.team_color = Color.GREEN
	player1.mice = [
		mouse_scene.instantiate(),
		mouse_scene.instantiate(),
		mouse_scene.instantiate()
	]

	var player2 = player.new()
	player2.team_name = "PlaugeCarriers"
	player2.team_color = Color.RED
	player2.mice = [
		mouse_scene.instantiate(),
		mouse_scene.instantiate(),
		mouse_scene.instantiate()
	]

	turn_handler.players.append_array([
		player1,
		player2
	])


func _ready():
	if Globals.match_setup_data == {}:
		dummy_team_date()
	else:
		for player in Globals.match_setup_data["players"]:
			for mouse in player.mouse_count:		
				player.mice.append(mouse_scene.instantiate())
				
		turn_handler.players.append_array(Globals.match_setup_data["players"])
	event_bus.connect(handle_event)
	spawn_mice()
	turn_handler.start()


func handle_event(transmitter, event):
	if debug:
		print_debug(transmitter.name + " " + event)
	if event == "weapon_fired" or event == "dead":
		await get_tree().create_timer(3.0).timeout
		turn_handler.change_turn()


func won():
	$Camera2D/GameSummary.start()


func set_active_character(char):
	active_character = char


func spawn_mice():
	spawn_points.shuffle()
	var next_spawn_index = 0
	for player in turn_handler.players:
		for mouse in player.mice:
			print_debug(mouse.name)
			add_child(mouse)
			mouse.position = spawn_points[next_spawn_index].position
			next_spawn_index += 1
			mouse.name_label.modulate = player.team_color
			mouse.health_label.modulate = player.team_color
			mouse.event_bus = event_bus


