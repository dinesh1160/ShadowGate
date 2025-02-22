extends Node2D

const BULLET = preload("res://Player/bullet.tscn")
@onready var muzzle = $Muzzle


func _ready():
	pass 

func _process(delta):
	#points the gun sprite towards the mouse position
	look_at(get_global_mouse_position()) 
	
	#rotates the gun
	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	if Input.is_action_just_pressed("left_mouse"):
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation + randf_range(deg_to_rad(-5),deg_to_rad(5))
		
