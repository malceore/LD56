extends RigidBody2D

var damage = 25
var explosion_force = 2500


func fire():
	$EOLTimer.start()


func die():
	queue_free()


func _on_body_entered(body:Node):
	$CollisionShape2D.disabled = true
	$Explosion.emitting = true
	$AudioStreamPlayer2D.play()
	$Explosion.reparent(get_tree().get_root())
	$AudioStreamPlayer2D.reparent(get_tree().get_root())
	var bodies_in_blast_radius = $BlastRadius.get_overlapping_bodies()
	for affected_body in bodies_in_blast_radius:
		if affected_body.get_parent().has_method("clip"):	
			affected_body.get_parent().clip($BlastRadius/CollisionPolygon2D)		
		if affected_body.has_method("take_damage"):
			affected_body.take_damage(damage)
		if affected_body is CharacterBody2D:
			var direction = (affected_body.get_global_position() - global_position).normalized()
			var distance_factor = get_global_position().distance_to(affected_body.get_global_position()) / 9
			affected_body.velocity += direction * (explosion_force / distance_factor)
	#await $Explosion.finished			
	#await $AudioStreamPlayer2D.finished
	die()	


func _on_eol_timer_timeout():
	die()
