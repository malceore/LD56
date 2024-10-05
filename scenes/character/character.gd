extends CharacterBody2D

@export var health = 100
@export var custom_name = "Moxy"

const SPEED = 150.0
const JUMP_VELOCITY = -200.0
const labelBoilerplate = "[center]"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var color = Color(0.342008, 0.204449, 0.0826466, 1)
var active_weapon = null


func _ready():
	$HealthLabel.text = labelBoilerplate + str(health)
	$HealthLabel.modulate = color
	$NameLabel.text = labelBoilerplate + custom_name
	$NameLabel.modulate = color


func take_damage(damage):
	health -= damage
	$HealthLabel.text = labelBoilerplate + str(health)
	print_debug("Ouchie!")

func change_weapon(weapon):
	if active_weapon != null:
		remove_child(active_weapon)
		active_weapon.queue_free()
	active_weapon = weapon
	active_weapon.ready()
	add_child(active_weapon)


func _process(delta):
	if active_weapon != null:
		active_weapon.process(delta)


func _input(event):
	if active_weapon != null:
		active_weapon.input(event)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction = Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
