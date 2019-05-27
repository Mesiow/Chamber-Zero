extends "res://Scripts/Portal.gd"

signal teleport(bluePortal)

func _ready():
	add_to_group("OrangePortal")
	
	var currentLevel=get_tree().get_root().get_node("/root/World").currentLevel
	var playerNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) +"/Player")
	self.connect("teleport", playerNode, "teleport_Orange_Received")
	pass
	


func _on_PortalArea_body_entered(body):
	if body.is_in_group("Player"):
		var bluePortalGroup=get_tree().get_nodes_in_group("BluePortal")
		
		if bluePortalGroup.size() >= 1:
			var bluePortal=bluePortalGroup[0]
			emit_signal("teleport", bluePortal)
	pass 
