extends KinematicBody2D


const Gun=preload("res://Scenes/PortalGun.tscn")
var gun

const gravity = 600.0 

const speed=250
const JUMP_SPEED = 250
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 #
const SLIDE_STOP_MIN_TRAVEL = 1.0 

var velocity = Vector2()
var launchVelocity=Vector2()
var on_air_time = 100
var airTime=0
var prevAirTime
var jumping = false

var prev_jump_pressed = false
var prev_Velocity=Vector2() #intial velocity before we entered the portal so then we can speed the player up accordingly

var okToTeleport=true
var force

func _ready():
	set_physics_process(true)
	set_process_input(true)
	
	gun=Gun.instance()
	add_child(gun)
	
	add_to_group("Player")
	
	force = Vector2(0, gravity)
	pass
	
func teleport_Blue_Received(orangePortal): #teleport to orange portal from entering the blue
	if okToTeleport:
		global_position=orangePortal.global_position
		setJumpVelocity(orangePortal)
		$TeleportTimer.start()
		okToTeleport=false
		
	pass
	
func teleport_Orange_Received(bluePortal): #teleport to blue portal from entering the orange
	
	if okToTeleport:
		global_position=bluePortal.global_position
		setJumpVelocity(bluePortal)
		$TeleportTimer.start()
		okToTeleport=false
	pass
	
func setJumpVelocity(portal): #grab certain velocity depending on facing direction of portal we come out from
	match portal.currentFacingDir: #set 
		portal.facing.UP:velocity.y =-JUMP_SPEED + prevAirTime #launch up a little bit
		portal.facing.DOWN:velocity.y=JUMP_SPEED - prevAirTime
		portal.facing.LEFT:velocity.x=-JUMP_SPEED - prevAirTime
		portal.facing.RIGHT:velocity.x=JUMP_SPEED + prevAirTime

	pass

func _input(event):
	
	var shootLeft=Input.is_action_pressed("LeftMouse")
	var shootRight=Input.is_action_pressed("RightMouse")
	
	if shootLeft:
		gun.shoot(shootLeft, getNormalizedDir())
	elif shootRight:
		gun.shoot(shootRight, getNormalizedDir())
	
	var walk_left = Input.is_action_pressed("Left")
	var walk_right = Input.is_action_pressed("Right")
	
	if walk_left:
		velocity.x=-speed 
	elif walk_right:
		velocity.x=speed 
	else:
		velocity.x=0
		
	pass
func _physics_process(delta):
	# Create forces
	#force = Vector2(0, gravity)
	var jump = Input.is_action_pressed("Jump")

	prevAirTime=airTime
	# Integrate forces to velocity
	velocity += force * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
		
	if is_on_floor():
		on_air_time = 0
		#airTime=0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	
	on_air_time += delta
	updateAirTime()
	pass
	
func updateAirTime():
	if !is_on_floor():
		prevAirTime=airTime
		airTime+=1
	else:
		airTime=0
		
	print(prevAirTime)
	pass
	
func getNormalizedDir():
	var dir=get_global_mouse_position() - gun.global_position
	var dirNorm=dir.normalized()
	return dirNorm
	pass


func _on_TeleportTimer_timeout():
	okToTeleport=true
	pass 

func jump():
	velocity.y = -JUMP_SPEED
	pass