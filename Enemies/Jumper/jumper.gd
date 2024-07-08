extends Enemybase
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jumptimer = $Jumptimer


const JUMP_VELOCITY: Vector2 = Vector2(150,-250)
const JUMP_TIMER:Vector2 = Vector2(2.0,5.0)


var _jump : bool = false
var _seen_player: bool = false
var health: int = 50
var health_max: int = 50
var taking_damage:bool = false

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
	if !taking_damage:
		if is_on_floor() == false or _seen_player == false or _jump == false:
			return
		velocity = JUMP_VELOCITY
		
		if animated_sprite_2d.flip_h == true:
			velocity.x = velocity.x*-1
		
		_jump = false
		animated_sprite_2d.play("jump")
		start_timer()
	elif taking_damage:
		var knockback = position.direction_to(_player_ref.position)*-50
		velocity = knockback
	
	
	
func flip_me() -> void:
	if(_player_ref.global_position.x > global_position.x and animated_sprite_2d.flip_h == true):
		animated_sprite_2d.flip_h = false
	elif(_player_ref.global_position.x < global_position.x and animated_sprite_2d.flip_h == false):
		animated_sprite_2d.flip_h = true
		
	
func start_timer() -> void:
	jumptimer.wait_time = randf_range(JUMP_TIMER.x,JUMP_TIMER.y)
	jumptimer.start()

func _on_jumptimer_timeout():
	_jump = true

func _on_visible_on_screen_notifier_2d_screen_entered():
	_seen_player = true

func _on_hitbox_area_entered(area):
	if area == Gamemanager.player_damage_area:
		var damage = Gamemanager.player_damage_points
		takedamage(damage)
	
func takedamage(damage):
	if _dead == true:
		return
	taking_damage = true
	health -= damage
	print(health)
	if health <= 0:
		health = 0
		_dead = true
		#animated_sprite_2d.play("dead")
		velocity.y = 100
		if is_on_floor() and health <= 0:
			await get_tree().create_timer(2).timeout
			set_physics_process(false)
			hide()
			queue_free()
	await get_tree().create_timer(0.3).timeout
	taking_damage = false
	
