extends "res://Scripts/Portal.gd"

signal teleportPlayer(orangePortal)

func _ready():
	add_to_group("BluePortal")
	var currentLevel=get_tree().get_root().get_node("/root/World").currentLevel
	var playerNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) + "/Player")
	
	self.connect("teleportPlayer", playerNode, "teleport_Blue_Received")
	pass
	

func _on_PortalArea_body_entered(body):
	var orangePortalGroup=get_tree().get_nodes_in_group("OrangePortal")
	if body.is_in_group("Player"):
		if orangePortalGroup.size() >= 1: #it exists
			var orangePortal=orangePortalGroup[0]
			emit_signal("teleportPlayer", orangePortal)
			$EnterSound.play()
	pass 
