extends Area2D

signal playerInAcid

func _ready():
	$AcidParticles.restart()
	$AcidParticles.emitting=true
	
	var worldNode=get_tree().get_root().get_node("/root/World")
	self.connect("playerInAcid", worldNode, "playerInAcid_Received")
	pass 

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.queue_free()
		emit_signal("playerInAcid")
	if body.is_in_group("Turrets"):
		body.queue_free()
	pass 
