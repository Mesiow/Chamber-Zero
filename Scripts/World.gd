extends Node

const deathScn=preload("res://Scenes/DeathScene.tscn")
const bluePortal=preload("res://Scenes/BluePortal.tscn")
const orangePortal=preload("res://Scenes/OrangePortal.tscn")
var blue=null
var orange=null

var currentLevel="ChamberNine"

func _ready():
	set_process_input(true)
	pass 
	
func hit_Platform_Received(position, from, color):
	if color == "blue":
		call_deferred("remove_child", blue) #make sure there is only 1 portal of each at a time
		blue = bluePortal.instance()
		blue.spawn(position, from)
		call_deferred("add_child", blue)
	elif color == "orange":
		call_deferred("remove_child", orange)
		orange=orangePortal.instance()
		orange.spawn(position, from)
		call_deferred("add_child", orange)
	pass
	
	
func _input(event):
	if Input.is_action_pressed("Quit"):
		get_tree().quit()
	pass
	
func _on_Player_playerDied(): #player died signal callback func
	showOptionsPlayerDead()
	pass 
	
func playerInAcid_Received(): #callback func to tell if player fell in acid
	showOptionsPlayerDead()
	pass
	
func showOptionsPlayerDead():
	var death=deathScn.instance()
	call_deferred("add_child", death)
	pass
