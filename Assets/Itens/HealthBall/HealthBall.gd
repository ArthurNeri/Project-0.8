extends Area2D
class_name HP_Ball

signal HP_UP(old_value, new_value)

#var HP = 5

func _on_HealthBall_body_entered(body):
	if body is OldPlayer:
#		HP += 1
		queue_free()
