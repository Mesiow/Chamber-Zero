extends Area2D

func _ready():
	pass
	
func _on_ExitDoor_body_entered(body):
	if body.is_in_group("Player"):
		$Sprite.texture=load("res://Sprites/Objects/DoorOpen.png")
	pass 
