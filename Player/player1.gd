extends CharacterBody2D
class_name Player

const GRAVITY : float = 1000.0
const JUMP_VELOCITY : float = -600.0
const RUN_VELOCITY : float = 150.0
const MAX_FALL : float = 600.0
const HURT_TIMMER : float = 0.3


enum PLAYER_STATE{IDLE, RUN, JUMP, HURT}  #for different actions and easy use of each state
var _state : PLAYER_STATE = PLAYER_STATE.IDLE  


var jump_count  = 0 #implementing double jump
var dashing = false
var direction

func _ready():
	pass


func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y = min(velocity.y + GRAVITY * delta,MAX_FALL)
	else:
		jump_count = 3
		
	handle_state_transitions()
	perform_state_actions(delta)
	move_and_slide() #after velocity
	
func handle_state_transitions():
	
	if Input.is_action_just_pressed("jump") and jump_count > 0:
		_state = PLAYER_STATE.JUMP
		velocity.y = JUMP_VELOCITY
		jump_count -= 1
		#print("Remaining jumps:", jump_count)
		
		
	direction  = Input.get_axis("left","right")
	if direction != 0:
		_state = PLAYER_STATE.RUN
		
	elif is_on_floor() and _state != PLAYER_STATE.JUMP:
		_state = PLAYER_STATE.IDLE
	

func perform_state_actions(delta): #add animations in here 
	match _state:
		PLAYER_STATE.IDLE:
			#play animation
			velocity.x = move_toward(velocity.x,0,RUN_VELOCITY)
		PLAYER_STATE.JUMP:
			if velocity.y < 0:
				#fall
				pass
			else:
				pass
		PLAYER_STATE.RUN:
			velocity.x = direction * RUN_VELOCITY
			
		
		
	
