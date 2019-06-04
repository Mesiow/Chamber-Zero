extends RigidBody2D

const Bullet=preload("res://Scenes/TurretProjectile.tscn")

var disabledSounds = [ preload("res://Sounds/turretSounds/turret_disabled_8.wav"),
preload("res://Sounds/turretSounds/turret_disabled_5.wav"), preload("res://Sounds/turretSounds/turret_disabled_4.wav"),
preload("res://Sounds/turretSounds/turret_disabled_3.wav"), preload("res://Sounds/turretSounds/turret_disabled_2.wav") ]

var launchedSounds = [ preload("res://Sounds/turretSounds/turretlaunched02.wav"), preload("res://Sounds/turretSounds/turretlaunched04.wav"),
preload("res://Sounds/turretSounds/turretlaunched08.wav"), preload("res://Sounds/turretSounds/turretlaunched11.wav") ]

var target
var hitPos
var canShoot=true
var detectRadius=800
var visColor=Color(.867, .91, .247, 0.1)
var laserColor=Color(1.0, .329, .298)
var showRay
var okToTeleport=true
var teleported=false
var newPosition
var currentState
var disabled=false
var launched=false
var launchForce=150
export var faceRight=false

var worldNode

func _ready():
	set_process(true)
	set_physics_process(true)
	worldNode=get_tree().get_root().get_node("/root/World")
	
	#set disabled sounds
	var disabledIndex=randi() % disabledSounds.size() + 0
	$Disabled.stream=disabledSounds[disabledIndex]
	$Disabled.volume_db = -5.0
	
	var launchedIndex=randi() % launchedSounds.size() + 0
	$Launched.stream=launchedSounds[launchedIndex]
	$Launched.volume_db = -5.0
	
	add_to_group("Turrets")
	pass
	
func _process(delta):
	update()
	pass
	
func _physics_process(delta):
	if target:
		if !disabled:
			aim()
	pass
	
func _integrate_forces(state):
	currentState=state
	if faceRight:
		scale=Vector2(-1, 1)
	if teleported:
		state.transform.origin=newPosition #updated rigid body position
		$Launched.play()
		teleported=false
	pass
	
func applyImpulse(portal): #apply impulse to turret based on direction of the portal it came out of
	match portal.currentFacingDir:
		portal.facing.UP:apply_impulse(Vector2(), Vector2(0, -launchForce))
		portal.facing.DOWN:apply_impulse(Vector2(), Vector2(0, launchForce))
		portal.facing.LEFT:apply_impulse(Vector2(), Vector2(-launchForce, 0))
		portal.facing.RIGHT:apply_impulse(Vector2(), Vector2(launchForce, 0))
	pass
	
func aim():
	hitPos = [] #array of hit positions
	var space_state=get_world_2d().direct_space_state #access physics state during current frame
	var targetExtents=target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5) #get extents of player collision shape
	#4 corners of players collision shape
	var nw=target.global_position - targetExtents #northwest corner of player
	var se=target.global_position + targetExtents
	var ne=target.global_position+Vector2(targetExtents.x, -targetExtents.y)
	var sw=target.global_position+Vector2(-targetExtents.x, targetExtents.y)
	
	for pos in [target.global_position, nw, ne, se, sw]: #cast a ray for each corner
			var result=space_state.intersect_ray(global_position, pos, #ray takes starting position and target position to look towards, ignore ourself, and take the collision mask
	                                     [self], collision_mask)
			if result:
				hitPos.append(result.position)
				if result.collider.name == "Player": #ray hit player
					shoot(pos)
					showRay=true
				else:
					#get number of platforms in level
					var count = worldNode.get_node(worldNode.currentLevel).get_node("Chamber").get_node("ShootablePlatforms").get_child_count()
					for i in range(0, count): #loop through all the platforms
						if result.collider.name == "ShootablePlatform" + str(i):
							showRay=false #do not show the turret ray if it cannot see the player
							break
				break
	pass
	
func shoot(pos):
	
	if canShoot:
		var directionNormalized
		var targetPos=pos
		var dir=targetPos - global_position
		directionNormalized=dir.normalized() #grab direction the turret is looking at where the player is
		
		#spawn bullet
		var bullet=Bullet.instance()
		bullet.init($Muzzle.global_position)
		bullet.setDir(directionNormalized)
		worldNode.add_child(bullet)
		$ShootTimer.start()
		$Shot.play()
		canShoot=false
	pass


func _on_Visibility_body_entered(body):
	if target:
		return
	if body.is_in_group("Player"):
		target=body #get body that entered the area
	pass 


func _on_Visibility_body_exited(body):
	if body == target: #if body that exited is target, set target to null
		target=null
	pass 
	
func _draw():
	#draw_circle(Vector2(), detectRadius, visColor)
	if target and showRay:
		for hit in hitPos:
			draw_circle((hit - global_position).rotated(-rotation), 5, laserColor)
			draw_line(Vector2(), (hit - global_position).rotated(-rotation), laserColor)
			#if faceRight:
				#draw_circle((hit + global_position).rotated(rotation), 5, laserColor)
				#draw_line(Vector2(), (hit + global_position).rotated(rotation), laserColor)
	pass


func _on_ShootTimer_timeout():
	canShoot=true
	pass 

	
func teleport_Turret_Orange_Received(bluePortal):
	if okToTeleport:
		newPosition=bluePortal.global_position
		teleported=true
		applyImpulse(bluePortal)
		disabled=true
		$TeleportTimer.start()
		okToTeleport=false
	pass
	
	
func teleport_Turret_Blue_Received(orangePortal):
	if okToTeleport:
		newPosition=orangePortal.global_position
		teleported=true
		applyImpulse(orangePortal)
		disabled=true
		$TeleportTimer.start()
		okToTeleport=false
	pass

func _on_TeleportTimer_timeout():
	okToTeleport=true
	pass 


func _on_turretArea_body_exited(body):
	if body.is_in_group("Player"):
		if !disabled:
			$Disabled.play()
			disabled=true
	pass
