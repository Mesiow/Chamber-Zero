extends "res://Scripts/Projectile.gd"

signal playerHit

func _ready():
	var worldNode=get_tree().get_root().get_node("/root/World")
	self.connect("playerHit", worldNode, "playerHit_Received")
	pass


func _on_TurretProjectile_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= 1
		#body.remove_child(body.get_node("crosshair")) #remove crosshair
		body.queue_free()
		emit_signal("playerHit") #change to death scene where we can restart or exit
	
	queue_free()
	pass 
