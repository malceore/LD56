extends Weapon


func _ready():
	damage = 25
	speed = 25000
	weapon_name = "Bazooka"


func process(delta):
	if !fired:
		look_at(get_global_mouse_position())
	if Input.is_action_pressed("Shoot"):
		if hold_time < 2.0:
			speed += speed_ramp
		hold_time += delta
	elif Input.is_action_just_released("Shoot"):
		fire()


func fire():
	fired = true
	current_ammo -= 1
	apply_central_force(speed * (get_global_mouse_position() - global_position).normalized())
	$EOLTimer.start()


func _on_eol_timer_timeout():
	queue_free()


func _on_body_entered(body:Node):
	print_debug("BOOOOM!")
	var bodies_in_blast_radius = $BlastRadius.get_overlapping_bodies()
	for affected_body in bodies_in_blast_radius:
		if affected_body.has_method("take_damage"):
			affected_body.take_damage(damage)
	queue_free()

