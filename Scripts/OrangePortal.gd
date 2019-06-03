extends "res://Scripts/Portal.gd"

signal teleportPlayer(bluePortal)
signal teleportTurret(bluePortal)

func _ready():
	add_to_group("OrangePortal")
	
	var currentLevel=get_tree().get_root().get_node("/root/World").currentLevel
	var playerNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) +"/Player")
	var turretNode=get_tree().get_root().get_node("/root/World/" + str(currentLevel) +"/Turret")
	
	self.connect("teleportPlayer", playerNode, "teleport_Orange_Received")
	self.connect("teleportTurret", turretNode, "teleport_Turret_Orange_Received")
	pass
	


func _on_PortalArea_body_entered(body):
	var bluePortalGroup=get_tree().get_nodes_in_group("BluePortal")
	var bluePortal=null
	if bluePortalGroup.size() >= 1:
			bluePortal=bluePortalGroup[0]
	
	if body.is_in_group("Player"):
		if bluePortal != null:
			emit_signal("teleportPlayer", bluePortal)
			$EnterSound.play()
	if body.is_in_group("Turrets"):
		if bluePortal != null:
			emit_signal("teleportTurret", bluePortal)
	pass 
