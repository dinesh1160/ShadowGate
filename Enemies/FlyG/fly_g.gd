extends Enemybase

@onready var move_timer = $MoveTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attackarea = $attackarea

var _seen_player: bool = false #not used
var dir:Vector2
var _gspeed: float = 60.0
var health: int = 50
var health_max: int = 50
var taking_damage:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
func _physics_process(delta):
	super._physics_process(delta)
	Gamemanager.fly_damage_area = attackarea
	move()
	flip_me()
	handle_animations()
	

func move():
	if !taking_damage:
		velocity = position.direction_to(_player_ref.position) * _gspeed
		dir.x =(abs(velocity.x))/(velocity.x)
	elif taking_damage:
		var knockback = position.direction_to(_player_ref.position)*-50
		velocity = knockback
		
	
	move_and_slide()
	
func flip_me() -> void:
	if dir.x == -1:
		animated_sprite_2d.flip_h = false
	elif dir.x == 1:
		animated_sprite_2d.flip_h = true

func handle_animations():
	if taking_damage:
		animated_sprite_2d.play("hurt")
	else:
		animated_sprite_2d.play("idle")
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	_seen_player = true 

	
func _on_move_timer_timeout():
	move_timer.wait_time = randf_range(2,5)


func _on_hitbox_area_entered(area):
	if area == Gamemanager.player_damage_area:
		var damage = Gamemanager.player_damage_points
		takedamage(damage)
		
func takedamage(damage):
	if _dead == true:
		return
	taking_damage = true
	health -= damage
	
	if health <= 0:
		health = 0
		_dead = true
		animated_sprite_2d.play("dead")
		velocity.y = 100
		await get_tree().create_timer(2).timeout
		set_physics_process(false)
		hide()
		queue_free()
	await get_tree().create_timer(0.3).timeout
	taking_damage = false
