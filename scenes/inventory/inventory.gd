extends CanvasGroup

const grenade = preload("res://scenes/weapons/grenade/grenade.tscn")
const bazooka = preload("res://scenes/weapons/bazooka/bazooka.tscn")
const uzi = preload("res://scenes/weapons/grenade/grenade.tscn")
const lead_pipe = preload("res://scenes/weapons/grenade/grenade.tscn")
const teleporter = preload("res://scenes/weapons/teleporter/teleporter.tscn")


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_Q:
			visible = not visible
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			visible = not visible


func _on_button_pressed():
	get_parent().get_parent().active_character.change_weapon(grenade.instantiate())

func _on_button_4_pressed():
	get_parent().get_parent().active_character.change_weapon(bazooka.instantiate())

func _on_button_5_pressed():
	get_parent().get_parent().active_character.change_weapon(teleporter.instantiate())
