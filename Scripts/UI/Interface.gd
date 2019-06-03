extends Control

signal healthChanged(health)

func _ready():
	pass


func _on_Player_healthChanged(newHealth):
	emit_signal("healthChanged", newHealth)
	pass 
