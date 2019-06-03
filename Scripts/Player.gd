extends KinematicBody2D


const Gun=preload("res://Scenes/PortalGun.tscn")
const Crosshair=preload("res://Scenes/Crosshair.tscn")
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
var prevAirTime=0.1
var updatedPrevAirTime
var jumping = false

var prev_jump_pressed = false
var prev_Velocity=Vector2() #intial velocity before we entered the portal so then we can speed the player up accordingly

var okToTeleport=true
var force

var health = 100 setget setHealth, getHealth
signal healthChanged(newHealth)
signal playerDied

func _ready():
	var worldNode=get_tree().get_root().get_node("/root/World")
	
	set_physics_process(true)
	set_process_input(true)
	force = Vector2(0, gravity)
	
	gun=Gun.instance()
	add_child(gun)
	
	var crosshair=Crosshair.instance()
	worldNode.call_deferred("add_child", crosshair)
	
	add_to_group("Player")
	pass
	
func setHealth(val):
	health=val
	emit_signal("healthChanged", health)
	if health <= 0:
		emit_signal("playerDied")
		queue_free()
		return
	pass

func getHealth():
	return health
	pass
	
func teleport_Blue_Received(orangePortal): #teleport to orange portal from entering the blue
	if okToTeleport:
		adjustTeleportPosition(orangePortal)
		setJumpVelocity(orangePortal)
		$TeleportTimer.start()
		okToTeleport=false
	pass
	
func teleport_Orange_Received(bluePortal): #teleport to blue portal from entering the orange
	
	if okToTeleport:
		adjustTeleportPosition(bluePortal)
		setJumpVelocity(bluePortal)
		$TeleportTimer.start()
		okToTeleport=false
	pass
	
func setJumpVelocity(portal): #grab certain velocity depending on facing direction of portal we come out from
	#print(prevAirTime)
	match portal.currentFacingDir: #set 
		portal.facing.UP:velocity.y =-JUMP_SPEED * prevAirTime #launch up a little bit
		portal.facing.DOWN:velocity.y=JUMP_SPEED * prevAirTime
		portal.facing.LEFT:velocity.x=-JUMP_SPEED * prevAirTime
		portal.facing.RIGHT:velocity.x=JUMP_SPEED * prevAirTime

	pass
	
func adjustTeleportPosition(portal):
	match portal.currentFacingDir:
		portal.facing.UP: global_position=Vector2(portal.global_position.x, portal.global_position.y - 5)
		portal.facing.DOWN: global_position=Vector2(portal.global_position.x, portal.global_position.y + 5)
		_:global_position=portal.global_position #default case
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
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.play("run")
	elif walk_right:
		velocity.x=speed 
		$AnimatedSprite.flip_h=false
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		velocity.x=0
	pass
	
func _physics_process(delta):
	# Create forces
	#force = Vector2(0, gravity)
	#print(prevAirTime)
	if airTime >= 0.1:
		prevAirTime=airTime #save how much air time a jump took
		
	var jump = Input.is_action_pressed("Jump")

	# Integrate forces to velocity
	velocity += force * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
		
	if is_on_floor():
		on_air_time = 0
		
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
		airTime+=0.03
	else:
		airTime=0
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