extends KinematicBody2D

var target
var hitPos
var detectRadius=800
var visColor=Color(.867, .91, .247, 0.1)
var laserColor=Color(1.0, .329, .298)

func _ready():
	set_process(true)
	set_physics_process(true)
	pass
	
func _process(delta):
	update()
	pass
	
func _physics_process(delta):
	if target:
		aim()
	pass
	
func aim():
	var space_state=get_world_2d().direct_space_state #access physics state during current frame
	#cast a ray
	#ray takes starting position and target position to look towards, ignore ourself, and take the collision mask
	var result=space_state.intersect_ray(global_position, target.global_position,
	                                     [self], collision_mask)
	if result:
		hitPos=result.position
		print(hitPos)
		if result.collider.name == "Player": #ray hit player
			#do stuff
			print("player hit")
			pass
	pass


func _on_Visibility_body_entered(body):
	if target:
		return
	#if body.is_in_group("Player"):
	target=body #get body that entered the area
	print("entered")
	pass 


func _on_Visibility_body_exited(body):
	if body == target: #if body that exited is target, set target to null
		target=null
		print("exited")
	pass 
	
func _draw():
	draw_circle(Vector2(), detectRadius, visColor)
	if target:
		draw_circle((hitPos - global_position).rotated(-rotation), 5, laserColor)
		draw_line(Vector2(), (hitPos - global_position).rotated(-rotation), laserColor)
	pass
