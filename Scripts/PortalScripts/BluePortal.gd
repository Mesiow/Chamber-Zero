extends "res://Scripts/PortalScripts/Portal.gd"

signal teleportPlayer(orangePortal)
signal teleportTurret(orangePortal)

func _ready():
	add_to_group("BluePortal")
	var currentLevel=get_tree().get_root().get_node("/root/World").currentLevel
	var playerNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) + "/Player")
	var turretNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) + "/Turret")
	
	self.connect("teleportPlayer", playerNode, "teleport_Blue_Received")
	self.connect("teleportTurret", turretNode, "teleport_Turret_Blue_Received")
	pass
	

func _on_PortalArea_body_entered(body):
	var orangePortalGroup=get_tree().get_nodes_in_group("OrangePortal")
	var orangePortal=null
	if orangePortalGroup.size() >= 1: #it exists
			orangePortal=orangePortalGroup[0]
	
	if body.is_in_group("Player"):
		if orangePortal != null:
			emit_signal("teleportPlayer", orangePortal)
			$EnterSound.play()
	if body.is_in_group("Turrets"):
		if orangePortal != null:
			emit_signal("teleportTurret", orangePortal)
	pass 
