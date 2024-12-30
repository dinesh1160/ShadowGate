extends Node2D
@onready var camera_2d = $Camera2D
#@onready var player = $Player
@onready var player_1 = $player1



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	camera_2d.position = player_1.position
	
	
