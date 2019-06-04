extends Node

const deathScn=preload("res://Scenes/DeathScene.tscn")
const bluePortal=preload("res://Scenes/BluePortal.tscn")
const orangePortal=preload("res://Scenes/OrangePortal.tscn")
var blue=null
var orange=null
var playerHealth=100

var currentLevel="ChamberNine" setget setCurrentLevel, getCurrentLevel
var levels=[ "Nine", "Eight", "Seven", "Six", "Five", "Four" ,"Three", "Two", "One", "Zero" ]
var levelPaths=[ preload("res://Levels/ChamberNine.tscn"), preload("res://Levels/ChamberEight.tscn") ]
var gameComplete=false

var background=AudioStreamPlayer.new()

func _ready():
	set_process_input(true)
	background.stream=load("res://Sounds/ambient_background.ogg")
	background.volume_db=1
	background.autoplay=true
	background.play()
	add_child(background)
	pass 
	
func changeLevel():
	if levels.size() <= 0:
		gameComplete=true
		return
	levels.pop_front()
	levelPaths.pop_front() #pop levels string and path to stay synced
	
	freeObjects()
	var newLevel=levelPaths[0].instance()
	call_deferred("add_child_below_node", $ChamberNine, newLevel) #add new level under chamber nine
	$ChamberNine.queue_free() #delete chamber nine
	
	currentLevel="Chamber"+levels[0]
	pass
	
func freeObjects():
	blue.queue_free() #remove portals
	orange.queue_free()
	blue=null
	orange=null
	print("freed portals")
	pass
	
func hit_Platform_Received(position, from, color):
	if color == "blue":
		if blue!=null:
			call_deferred("remove_child", blue) #make sure there is only 1 portal of each at a time
		blue = bluePortal.instance()
		blue.spawn(position, from)
		call_deferred("add_child", blue)
	elif color == "orange":
		if orange!=null:
			call_deferred("remove_child", orange)
		orange=orangePortal.instance()
		orange.spawn(position, from)
		call_deferred("add_child", orange)
	pass
	
	
func _input(event):
	if Input.is_action_pressed("Quit"):
		get_tree().quit()
	pass
	
func setCurrentLevel(level):
	currentLevel=level
	pass
	
func getCurrentLevel():
	return currentLevel
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
