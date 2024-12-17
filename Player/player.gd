extends CharacterBody2D

class_name Player

@onready var animation_player = $AnimatedSprite2D
@onready var sprite_2d = $AnimatedSprite2D
@onready var attack_zone = $attack_zone

const JUMP_COUNT_MAX = 2
const GRAVITY : float = 700.0
const JUMP_VELOCITY : float = -500.0
const RUN_VELOCITY : float = 150.0
const MAX_FALL : float = 400.0


var jump_count = 0
var attack_type:String
var current_attack:bool = false

var health:int = 10
var can_take_damage:bool
var dead:bool = false

enum PLAYER_STATE{IDLE, RUN, JUMP, FALL, HURT}  #for different actions and easy use of each state

var _state : PLAYER_STATE = PLAYER_STATE.IDLE  

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _physics_process(delta):
	Gamemanager.player_damage_area = attack_zone
	
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
		
	get_input() #getting input and deciding velocity
	move_and_slide() #after velocity
	calculate_state() #animation

#display_debuglabel()
#func display_debuglabel() -> void:
	#debug_label.text = "Floor: %s\n %s\n, %.1f, %.1f\n " % [
		#is_on_floor(),
		#PLAYER_STATE.keys()[_state],
		#velocity.x,velocity.y
		#
	#]
	#
	

func get_input() -> void:
	velocity.x = 0
	
	if !current_attack and !dead:
		if Input.is_action_pressed("left"): 
			velocity.x = -RUN_VELOCITY
			sprite_2d.flip_h = true
			attack_zone.scale.x = -1
			
		elif Input.is_action_pressed("right"):
			velocity.x = RUN_VELOCITY
			sprite_2d.flip_h = false
			attack_zone.scale.x = 1
				
		if is_on_floor() and jump_count!= 0:
			jump_count = 0
					
		if jump_count < 2:
			if Input.is_action_just_pressed("jump") and !current_attack:
					velocity.y = JUMP_VELOCITY
					jump_count += 1
				
	if current_attack == false:
		if Input.is_action_just_pressed("left_mouse") or Input.is_action_just_pressed("right_mouse"):
			current_attack = true
			if Input.is_action_just_pressed("left_mouse"):
				if is_on_floor():
					attack_type = "f_single"
					#print("f_single")
				else:
					attack_type = "a_single" 
					#print("a_single")
			elif Input.is_action_just_pressed("right_mouse"):
				if is_on_floor():
					attack_type = "f_double"
					#print("f_d")
				else:
					attack_type = "a_double"
					#print("a_d")
			set_attack_damage(attack_type)
			attack_animations(attack_type)
	
	velocity.y = clampf(velocity.y,JUMP_VELOCITY,MAX_FALL)
	
		
func calculate_state() -> void:
	
	if _state == PLAYER_STATE.HURT:  #invincible for some time and the animation plays
		return
	if !current_attack:
		if is_on_floor() == true:
			if velocity.x == 0:
				animation_player.play("idle")
			else:
				animation_player.play("run")
		else:
			if velocity.y > 300:
				animation_player.play("fall") 
			else:
				animation_player.play("jump")
				
			
#func set_state(new_state: PLAYER_STATE) -> void:
	#if new_state == _state:  #if we are already in the state on need to proceed furthur
		#return
		#
	##if _state == PLAYER_STATE.FALL:
		##if new_state == PLAYER_STATE.IDLE or PLAYER_STATE.RUN:
			##Soundmanager.play_clip(sound_player,Soundmanager.SOUND_LAND)
			##
	#
	#_state = new_state
	#
	#match _state:               
		#PLAYER_STATE.IDLE:
			#animation_player.play("idle")
		#PLAYER_STATE.JUMP:
			#animation_player.play("jump")
		#PLAYER_STATE.RUN:
			#animation_player.play("run")
		#PLAYER_STATE.FALL:
			#animation_player.play("fall") 
			
			
			
func attack_animations(ani):
	if current_attack == true:
		animation_player.play(ani)
		toggle_attack_zone(ani)
	
func toggle_attack_zone(a_type):
	var attack_collision = attack_zone.get_node("CollisionShape2D")
	var wait_time:float
	if a_type == "f_single":
		wait_time = 0.8
	elif a_type == "a_single":
		wait_time = 0.8
	elif a_type == "f_double":
		wait_time = 0.8
	elif a_type == "a_double":
		wait_time = 0.8
	attack_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	attack_collision.disabled = true
		
func set_attack_damage(attack_type):
	var points:int
	if attack_type == "a_single" or attack_type == "f_single":
		points = 8
	if attack_type == "a_double" or attack_type == "f_double":
		points = 16
	Gamemanager.player_damage_points = points


func _on_animated_sprite_2d_animation_finished():
	current_attack = false
	#print("fii")

func _on_hitbox_area_entered(area):
	if area == Gamemanager.fly_damage_area:
		player_attacked()
		
func player_attacked():
	if dead == true:
		return
	health -= 8 #health to be reduced
	print(health)
	if health <= 0:
		dead = true
		#animation_player.play("dead")
		Signalmanager.player_dead.emit()
		set_physics_process(false)
		await get_tree().create_timer(2).timeout
		hide()
				
