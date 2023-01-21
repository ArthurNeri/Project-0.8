extends Area2D

func _on_Spikes_body_entered(body):
	if body is Player:
		return get_tree().reload_current_scene()
	
