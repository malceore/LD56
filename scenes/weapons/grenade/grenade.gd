extends Weapon


var projectile = preload("res://scenes/weapons/grenade/grenade.tscn")


func _ready():
	damage = 35
	weapon_name = "Grenade"


func process(delta):
	if !fired:
		look_at(get_global_mouse_position())
	if Input.is_action_pressed("Shoot"):
		if hold_time < 2.0:
			speed += speed_ramp
		hold_time += delta
	elif Input.is_action_just_released("Shoot"):
		fire()


func _on_timer_timeout():
	$Explosion.emitting = true
	await $Explosion.finished
	#$Explosion.reparent(get_tree().get_root())

	print_debug("explosion!!!")
	var bodies_in_blast_radius = $BlastRadius.get_overlapping_bodies()
	for affected_body in bodies_in_blast_radius:
		if affected_body.has_method("take_damage"):
			affected_body.take_damage(damage)
	die()


func die():
	queue_free()
	

func fire():
	get_parent().event_bus.emit(get_parent(), "weapon_fired")
	fired = true
	current_ammo -= 1
	var projectile_instance = projectile.instantiate()
	projectile_instance.global_position = global_position
	projectile_instance.rotation = (get_global_mouse_position() - global_position).normalized().angle()
	get_tree().get_root().add_child(projectile_instance)
	projectile_instance.apply_central_force(speed * (get_global_mouse_position() - global_position).normalized())
	projectile_instance.get_node("Timer").start()
	queue_free()




