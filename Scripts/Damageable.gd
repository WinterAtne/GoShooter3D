extends Area3D





func _on_body_entered(body):
	if body.is_in_group("damager"):
		queue_free()
	pass # Replace with function body.
