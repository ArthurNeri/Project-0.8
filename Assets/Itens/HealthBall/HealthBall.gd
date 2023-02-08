extends Area2D

var HP = 5

func _on_HealthBall_body_entered(body):
	print(HP)
	if body is Player:
		HP += 1
		print(HP)
		get_parent().queue_free()
