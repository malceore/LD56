extends Weapon

@onready var power_gauge= get_parent().get_node("PowerGauge")

var projectile = preload("res://scenes/weapons/missle/missle.tscn")


func _ready():
	speed_ramp = 250
	speed = 20000
	weapon_name = "Bazooka"


func process(delta):
	if !fired:
		look_at(get_global_mouse_position())
	if Input.is_action_pressed("Shoot"):
		if hold_time < 3.0:
			speed += speed_ramp
		hold_time += delta
		power_gauge.value += delta
		power_gauge.visible = true			
	elif Input.is_action_just_released("Shoot"):
		fire()
		power_gauge.value = 0
		power_gauge.visible = false				


func fire():
	get_parent().event_bus.emit(get_parent(), "weapon_fired")
	if debug:
		print_debug("firing " + str(speed) + "  Rotation:" + str((get_global_mouse_position() - global_position).normalized())) 
	fired = true
	current_ammo -= 1
	var projectile_instance = projectile.instantiate()
	projectile_instance.global_position = global_position
	projectile_instance.rotation = (get_global_mouse_position() - global_position).normalized().angle()
	get_tree().get_root().add_child(projectile_instance)
	projectile_instance.apply_central_force(speed * (get_global_mouse_position() - global_position).normalized())
	get_parent().deactivate_weapon_if_active()
