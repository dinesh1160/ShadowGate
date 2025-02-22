extends CharacterBody2D

class_name Enemy
const BULLET = preload("res://Player/bullet.tscn")
@onready var player = get_parent().get_node("player1")

var direction: Vector2
const SPEED = 200
var max_health = 5

@onready var shoot_timer = $ShootTimer
@onready var mouthmarker = $mouthmarker

func _process(delta):
	velocity.x = position.direction_to(player.position).x * SPEED
	position.y = 0
	#if shoot_timer.timeout:
		#print("Shoot")
		#shoot()
		#shoot_timer.start()
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.is_in_group("Bullet"):
		
		if max_health <= 0:
			queue_free()
		else:
			print(max_health)
			max_health -= 1

func shoot():
	var angle = global_position.angle_to_point(player.position)
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = mouthmarker.global_position
	bullet_instance.rotation = angle + randf_range(deg_to_rad(-5),deg_to_rad(5))


func _on_shoot_timer_timeout():
	shoot()
	shoot_timer.start()
