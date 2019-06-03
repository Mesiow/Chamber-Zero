extends "res://Scripts/Projectile.gd"

func _ready():
	var worldNode=get_tree().get_root().get_node("/root/World")
	pass


func _on_TurretProjectile_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= damage
	
	queue_free()
	pass 
