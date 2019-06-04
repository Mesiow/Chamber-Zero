extends Area2D

#var worldNode=get_tree().get_root().get_node("/root/World")
#var doorLevel=worldNode.currentLevel

func _ready():
	pass
	
func _on_ExitDoor_body_entered(body):
	if body.is_in_group("Player"):
		$Sprite.texture=load("res://Sprites/Objects/DoorOpen.png")
		$DoorLight.enabled=false
	pass 


func _on_ExitDoor_body_exited(body):
	$Sprite.texture=load("res://Sprites/Objects/DoorUnlocked.png")
	$DoorLight.enabled=true
	pass 


func _on_ExitArea_body_entered(body):
	var worldNode=get_tree().get_root().get_node("/root/World")
	if body.is_in_group("Player"):
		#finished level
		body.queue_free()
		worldNode.changeLevel()
	pass
