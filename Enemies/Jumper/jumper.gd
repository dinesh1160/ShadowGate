extends Enemybase
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jumptimer = $Jumptimer


const JUMP_VELOCITY: Vector2 = Vector2(150,-250)
const JUMP_TIMER:Vector2 = Vector2(2.0,5.0)

var _jump : bool = false
var _seen_player: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	start_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	
	if is_on_floor() == false:
		velocity.y += _gravity*delta
	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	apply_jump()
	move_and_slide()
	flip_me()
		
		
func apply_jump() -> void:
	if is_on_floor() == false or _seen_player == false or _jump == false:
		return
	velocity = JUMP_VELOCITY
	
	if animated_sprite_2d.flip_h == false:
		velocity.x = velocity.x*-1
	
	_jump = false
	animated_sprite_2d.play("jump")
	start_timer()
	
	
	
	
func flip_me() -> void:
	if(_player_ref.global_position.x > global_position.x and animated_sprite_2d.flip_h == false):
		animated_sprite_2d.flip_h = true
	elif(_player_ref.global_position.x < global_position.x and animated_sprite_2d.flip_h == true):
		animated_sprite_2d.flip_h = false
		
	
func start_timer() -> void:
	jumptimer.wait_time = randf_range(JUMP_TIMER.x,JUMP_TIMER.y)
	jumptimer.start()

func _on_jumptimer_timeout():
	_jump = true

func _on_visible_on_screen_notifier_2d_screen_entered():
	_seen_player = true
