extends Area2D

func _ready():
	$AcidParticles.restart()
	$AcidParticles.emitting=true
	pass 

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.queue_free()
	pass 
