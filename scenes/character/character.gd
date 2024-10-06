extends CharacterBody2D

@export var health = 100
@export var custom_name = "Moxy"
@onready var name_label = $NameLabel
@onready var health_label = $HealthLabel
@onready var sprite_ap = $Sprite.get_node("AnimationPlayer")
@onready var sprite_body = $Sprite.get_node("Body")

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const labelBoilerplate = "[center]"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active_weapon = null
var active = false
var dead = false
var event_bus

func _ready():
	health_label.text = labelBoilerplate + str(health)
	name_label.text = labelBoilerplate + custom_name


func take_damage(damage):
	if not dead:
		health -= damage
		health_label.text = labelBoilerplate + str(health)
		print_debug("Ouchie!")
		if health <= 0:
			die()


func die():
	dead = true
	sprite_ap.play("dying")
	#await sprite_ap.animation_finished
	health = 0
	health_label.text = labelBoilerplate + "Dead"
	#$CollisionShape2D.disabled = true
	event_bus.emit(self, "dead")


func change_weapon(weapon):
	deactivate_weapon_if_active()
	active_weapon = weapon
	active_weapon.ready()
	add_child(active_weapon)


func deactivate_weapon_if_active():
	if active_weapon != null:	
		remove_child(active_weapon)
		active_weapon.queue_free()


func _process(delta):
	if active_weapon != null:
		active_weapon.process(delta)


func _input(event):
	if active_weapon != null:
		active_weapon.input(event)


func _physics_process(delta):

	if active and !dead:	
		if not is_on_floor():
			velocity.y += gravity * delta
			sprite_ap.play("jump")
		else:
			sprite_ap.play("idle")

		# Handle Movement Controls
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction = Input.get_axis("Move_Left", "Move_Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Handle Animation 
		if velocity.x != 0:
			sprite_ap.play("scurry")

		if velocity.y != 0:
			sprite_ap.play("jump")

		# Handle Sprite Direction
		if velocity.x < 0:
			sprite_body.scale.x = -1
		else:
			sprite_body.scale.x = 1

	move_and_slide()
