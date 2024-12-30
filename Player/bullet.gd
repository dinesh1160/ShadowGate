class_name Bullet
extends Area2D

 
 
const SPEED: int = 1500
 
 
func _process(delta):
	position += transform.x * SPEED * delta

	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
