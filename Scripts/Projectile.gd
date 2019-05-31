extends Area2D

var dir=Vector2()
export var speed=350

signal hit(position, from, color)

func _ready():
	set_process(true)
	
	var worldNode=get_tree().get_root().get_node("/root/World")
	self.connect("hit", worldNode, "hit_Platform_Received")
	pass
	
func _process(delta):
	translate(speed * dir * delta)
	pass
	
func init(pos):
	global_position=pos
	pass
	
func setDir(direction):
	dir=direction
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass
