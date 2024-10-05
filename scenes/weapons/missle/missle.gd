extends RigidBody2D

var damage = 25


func fire():
	$EOLTimer.start()


func die():
	queue_free()


func _on_body_entered(body:Node):
	print_debug("BOOOOM!")
	var bodies_in_blast_radius = $BlastRadius.get_overlapping_bodies()
	for affected_body in bodies_in_blast_radius:
		if affected_body.has_method("take_damage"):
			affected_body.take_damage(damage)
	die()	


func _on_eol_timer_timeout():
	die()
