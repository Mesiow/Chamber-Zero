extends Control

func _ready():
	pass

func _on_ExitBtn_pressed():
	get_tree().quit()
	pass 


func _on_RestartBtn_pressed():
	get_tree().reload_current_scene() #restart current level we just died on
	pass 
