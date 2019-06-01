extends "res://Scripts/Projectile.gd"

func _ready():
	pass


func _on_TurretProjectile_body_entered(body):
	queue_free()
	pass 
