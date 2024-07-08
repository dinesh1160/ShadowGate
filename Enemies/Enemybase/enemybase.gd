extends CharacterBody2D



class_name Enemybase

const OFF_SCREEN_KILL_LIMIT: float = 1000.00
@export var points: int  =1


var _speed: float = 100.00
var _gravity: float = 800.00
var _player_ref: Player
var _dead: bool  = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_player_ref = get_tree().get_nodes_in_group(Gamemanager.GROUP_PLAYER)[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	offscreen_kill()
	
	
func offscreen_kill():
	if global_position.y > OFF_SCREEN_KILL_LIMIT:
		queue_free() 
		
func die():
	if _dead == true:
		return
	else:
		_dead = true
		Signalmanager.on_enemy_hit.emit(points,global_position)
		set_physics_process(false)
		hide()
		queue_free()
		


func _on_visible_on_screen_notifier_2d_screen_entered():
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass # Replace with function body.
