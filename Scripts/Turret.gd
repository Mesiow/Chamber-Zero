extends RigidBody2D

const Bullet=preload("res://Scenes/TurretProjectile.tscn")

var target
var hitPos
var canShoot=true
var detectRadius=800
var visColor=Color(.867, .91, .247, 0.1)
var laserColor=Color(1.0, .329, .298)
var canSeePlayer=false
var okToTeleport=true
var teleported=false
var newPosition
var currentState

var worldNode

func _ready():
	set_process(true)
	set_physics_process(true)
	worldNode=get_tree().get_root().get_node("/root/World")
	
	add_to_group("Turrets")
	pass
	
func _process(delta):
	update()
	pass
	
func _physics_process(delta):
	if target:
		aim()
	pass
	
func _integrate_forces(state):
	#if teleported:
	#	state.transform=newPosition
		
	currentState=state.transform
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
					canSeePlayer=true
				break
			else:
				canSeePlayer=false
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
	if target:
		for hit in hitPos:
			draw_circle((hit - global_position).rotated(-rotation), 5, laserColor)
			draw_line(Vector2(), (hit - global_position).rotated(-rotation), laserColor)
	pass


func _on_ShootTimer_timeout():
	canShoot=true
	pass 

	
func teleport_Turret_Orange_Received(bluePortal):
	if okToTeleport:
		newPosition=bluePortal.global_position
		currentState=newPosition
		teleported=true
		$TeleportTimer.start()
		okToTeleport=false
		
	teleported=false
	pass
	
	
func teleport_Turret_Blue_Received(orangePortal):
	if okToTeleport:
		newPosition=orangePortal.global_position
		currentState=newPosition
		teleported=true
		$TeleportTimer.start()
		okToTeleport=false
	
	teleported=false
	pass



func _on_TeleportTimer_timeout():
	okToTeleport=true
	pass 
