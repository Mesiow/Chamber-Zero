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
		call_deferred("remove_child", blue)#make sure there is only 1 portal of each at a time
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
	if Input.is_action_pressed("ui_down"):
		get_tree().reload_current_scene()
	pass
	
func playerHit_Received(): #callback func to tell us the player was hit by a projectile
	var death=deathScn.instance()
	call_deferred("add_child", death)
	pass

