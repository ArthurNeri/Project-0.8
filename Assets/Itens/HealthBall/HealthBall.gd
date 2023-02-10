extends Area2D

#var HP = 5

func _on_HealthBall_body_entered(body):
	if body is Player:
#		HP += 1
		queue_free()
