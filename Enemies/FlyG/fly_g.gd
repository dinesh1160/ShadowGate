extends Enemybase

@onready var move_timer = $MoveTimer
@onready var animated_sprite_2d = $AnimatedSprite2D

var _seen_player: bool = false #not used
var dir:Vector2
var _gspeed: float = 60.0


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
func _physics_process(delta):
	super._physics_process(delta)
	move()
	flip_me()
	

func move():
	velocity = position.direction_to(_player_ref.position) * _gspeed
	dir.x =(abs(velocity.x))/(velocity.x)
	move_and_slide()
	
func flip_me() -> void:
	if dir.x == -1:
		animated_sprite_2d.flip_h = false
	elif dir.x == 1:
		animated_sprite_2d.flip_h = true
func _on_visible_on_screen_notifier_2d_screen_exited():
	_seen_player = true  #not used 

	
func _on_move_timer_timeout():
	move_timer.wait_time = randf_range(2,5)
