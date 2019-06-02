extends "res://Scripts/Projectile.gd"


func _ready():
	add_to_group("OrangeProjectiles")
	pass 
	



func _on_OrangeProj_body_entered(body):
	#if body.is_in_group("NonShootablePlatforms"):
	#	$HitInvalidSurface.play()
	if body.is_in_group("ShootablePlatforms"):
		var rect=body.get_node("Sprite").get_rect()
		
		var positionX=0
		var positionY=0
		var position
		var from=""
		
		
		if body.horizontal: #if we hit a horizontal platform
			if global_position.y < body.global_position.y: #if we hit the top of the platform place portal at top
				positionX=body.global_position.x
				positionY=body.global_position.y - rect.size.y/2
				from="up"
			elif global_position.y > body.global_position.y:
				positionX=body.global_position.x
				positionY=body.global_position.y + rect.size.y/2
				from="bottom"
		elif body.vertical:
			if global_position.x < body.global_position.x:
				positionX=body.global_position.x - rect.size.x/2
				positionY=body.global_position.y
				from="left"
			elif global_position.x > body.global_position.x:
				positionX=body.global_position.x + rect.size.x/2
				positionY=body.global_position.y
				from="right"
			
		position=Vector2(positionX, positionY) #grab position of platform to place portal at
		emit_signal("hit", position, from, "orange")
	queue_free()
	pass
