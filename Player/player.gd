

extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
#@onready var debug_label = $DebugLabel
#@onready var sound_player = $sound_player
@onready var sprite_2d = $AnimatedSprite2D



const GRAVITY : float = 1000.0
const JUMP_VELOCITY : float = -400.0
const RUN_VELOCITY : float = 150.0
const MAX_FALL : float = 400.0
const HURT_TIMMER : float = 0.3


enum PLAYER_STATE{IDLE, RUN, JUMP, FALL, HURT}  #for different actions and easy use of each state

var _state : PLAYER_STATE = PLAYER_STATE.IDLE  




# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _physics_process(delta):
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
	
	if Input.is_action_pressed("left"):
		velocity.x = -RUN_VELOCITY
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x = RUN_VELOCITY
		sprite_2d.flip_h = false
	
	if Input.is_action_pressed("jump") and is_on_floor() == true:
		velocity.y = JUMP_VELOCITY
		
	velocity.y = clampf(velocity.y,JUMP_VELOCITY,MAX_FALL)
	
		
func calculate_state() -> void:
	
	if _state == PLAYER_STATE.HURT:  #invincible for some time and the animation plays
		return
	
	if is_on_floor() == true:
		if velocity.x == 0:
			set_state(PLAYER_STATE.IDLE)
		else:
			set_state(PLAYER_STATE.RUN)
	else:
		if velocity.y > 300:
			set_state(PLAYER_STATE.FALL)
		else:
			set_state(PLAYER_STATE.JUMP)
			
			
func set_state(new_state: PLAYER_STATE) -> void:
	if new_state == _state:  #if we are already in the state on need to proceed furthur
		return
		
	#if _state == PLAYER_STATE.FALL:
		#if new_state == PLAYER_STATE.IDLE or PLAYER_STATE.RUN:
			#Soundmanager.play_clip(sound_player,Soundmanager.SOUND_LAND)
			#
	
	_state = new_state
	
	match _state:               
		PLAYER_STATE.IDLE:
			animation_player.play("idle")
		PLAYER_STATE.JUMP:
			animation_player.play("jump")
		PLAYER_STATE.RUN:
			animation_player.play("run")
		PLAYER_STATE.FALL:
			animation_player.play("fall")
