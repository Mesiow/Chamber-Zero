extends Sprite

const blueProj=preload("res://Scenes/BlueProj.tscn")
const orangeProj=preload("res://Scenes/OrangeProj.tscn")
var canShoot=true
var gunFacingLeft=false

var worldNode

func _ready():
	set_process(true)
	worldNode=get_tree().get_root().get_node("/root/World")
	hide()
	pass
	
func _process(delta):
	look_at(get_global_mouse_position())
	
	if $Muzzle.global_rotation_degrees <= -90.0:
		gunFacingLeft=true
		flip_v=true
	if $Muzzle.global_rotation_degrees >= 90.0 and gunFacingLeft:
		#gunFacingLeft=false
		#flip_v=false
		flip_v=true
		
	if $Muzzle.global_rotation_degrees <= 45.0 and $Muzzle.global_rotation_degrees >= 0:
		gunFacingLeft=false
		flip_v=false
	pass
	
	
func shoot(pressed, dir):
	
	if canShoot: #if we are ok to shoot
		if Input.is_action_pressed("LeftMouse") == pressed:
			var blue=blueProj.instance()
			blue.init($Muzzle.global_position)
			blue.setDir(dir)
			worldNode.add_child(blue)
			$BlueShot.play()
		elif Input.is_action_pressed("RightMouse") == pressed:
			var orange=orangeProj.instance()
			orange.init($Muzzle.global_position)
			orange.setDir(dir)
			worldNode.add_child(orange)
			$OrangeShot.play()
		
		canShoot=false
		
	$ShootTimer.start()
	pass
	


func _on_ShootTimer_timeout():
	canShoot=true
	pass 
