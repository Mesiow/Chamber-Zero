extends "res://Scripts/Portal.gd"

signal teleport(orangePortal)

func _ready():
	add_to_group("BluePortal")
	var currentLevel=get_tree().get_root().get_node("/root/World").currentLevel
	var playerNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) + "/Player")
	self.connect("teleport", playerNode, "teleport_Blue_Received")
	pass
	

func _on_PortalArea_body_entered(body):
	if body.is_in_group("Player"):
		var orangePortalGroup=get_tree().get_nodes_in_group("OrangePortal")
		
		if orangePortalGroup.size() >= 1: #it exists
			var orangePortal=orangePortalGroup[0]
			emit_signal("teleport", orangePortal)
	pass 
