extends "res://Scripts/Portal.gd"

signal teleportPlayer(bluePortal)

func _ready():
	add_to_group("OrangePortal")
	
	var currentLevel=get_tree().get_root().get_node("/root/World").currentLevel
	var playerNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) +"/Player")
	
	self.connect("teleportPlayer", playerNode, "teleport_Orange_Received")
	pass
	


func _on_PortalArea_body_entered(body):
	var bluePortalGroup=get_tree().get_nodes_in_group("BluePortal")
	if body.is_in_group("Player"):
		if bluePortalGroup.size() >= 1:
			var bluePortal=bluePortalGroup[0]
			emit_signal("teleportPlayer", bluePortal)
			$EnterSound.play()
	pass 
