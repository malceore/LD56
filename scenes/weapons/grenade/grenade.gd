extends Weapon

@onready var power_gauge= get_parent().get_node("PowerGauge")

var projectile = preload("res://scenes/weapons/grenade/grenade.tscn")
var explosion_force = 4500


func _ready():
	damage = 35
	weapon_name = "Grenade"


func process(delta):
	if !fired:
		look_at(get_global_mouse_position())

	if Input.is_action_pressed("Shoot"):
		if hold_time < 1.5:
			speed += speed_ramp
		hold_time += delta
		power_gauge.value += delta
		power_gauge.visible = true		

	elif Input.is_action_just_released("Shoot"):
		fire()
		power_gauge.value = 0
		power_gauge.visible = false		


func _on_timer_timeout():
	$Explosion.emitting = true
	$AudioStreamPlayer2D.play()
	$Explosion.reparent(get_tree().get_root())
	$AudioStreamPlayer2D.reparent(get_tree().get_root())
	var bodies_in_blast_radius = $BlastRadius.get_overlapping_bodies()
	for affected_body in bodies_in_blast_radius:
		#print_debug(affected_body)
		if affected_body.get_parent().has_method("clip"):	
			affected_body.get_parent().clip($BlastRadius/CollisionPolygon2D)
		if affected_body.has_method("take_damage"):
			affected_body.take_damage(damage)
		if affected_body is CharacterBody2D:
			var direction = (affected_body.get_global_position() - global_position).normalized()
			var distance_factor = get_global_position().distance_to(affected_body.get_global_position()) / 9
			affected_body.velocity += direction * (explosion_force / distance_factor)			
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
