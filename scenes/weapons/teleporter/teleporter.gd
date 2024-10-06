extends Weapon


func process(delta):
	look_at(get_global_mouse_position())

 
func teleport():
	$CPUParticles2D.emitting = true
	position = get_global_mouse_position()	
	get_parent().position = get_global_mouse_position()
	await $CPUParticles2D.finished
	get_parent().event_bus.emit(get_parent(), "weapon_fired")
	fired = true
	current_ammo -= 1
	queue_free()


func input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			teleport()
			