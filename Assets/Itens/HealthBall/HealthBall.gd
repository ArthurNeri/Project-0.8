extends Area2D

#var HP = 5

func _on_HealthBall_body_entered(body):
	if body is OldPlayer:
#		HP += 1
		queue_free()
