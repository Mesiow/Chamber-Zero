extends Sprite

const blueProj=preload("res://Scenes/BlueProj.tscn")
const orangeProj=preload("res://Scenes/OrangeProj.tscn")
var canShoot=true

var worldNode

func _ready():
	set_process(true)
	worldNode=get_tree().get_root().get_node("/root/World")
	pass
	
func _process(delta):
	look_at(get_global_mouse_position())
	pass
	
	
func shoot(pressed, dir):
	
	if canShoot: #if we are ok to shoot
		if Input.is_action_pressed("LeftMouse") == pressed:
			var blue=blueProj.instance()
			blue.init($Muzzle.global_position)
			blue.setDir(dir)
			worldNode.add_child(blue)
		elif Input.is_action_pressed("RightMouse") == pressed:
			var orange=orangeProj.instance()
			orange.init($Muzzle.global_position)
			orange.setDir(dir)
			worldNode.add_child(orange)
		
		canShoot=false
		
	$ShootTimer.start()
	pass
	


func _on_ShootTimer_timeout():
	canShoot=true
	pass 
