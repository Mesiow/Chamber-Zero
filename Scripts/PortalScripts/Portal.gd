extends Node2D

var portalEnterSounds = [ preload("res://Sounds/PortalSounds/portal_enter1.wav"), preload("res://Sounds/PortalSounds/portal_enter2.wav") ]

enum facing{
	UP,DOWN,LEFT,RIGHT
}
var currentFacingDir setget ,getCurrentFacingDir

var launchSpeed=300 #default

func _ready():
	randomize()
	var element=randi() % portalEnterSounds.size() + 0
	$EnterSound.stream = portalEnterSounds[element] #choose random enter sound for portal
	pass
	
func spawn(pos, from):
	global_position=pos
	if from == "bottom":
		currentFacingDir=facing.DOWN
		rotation_degrees+=-180
	if from == "left":
		currentFacingDir=facing.LEFT
		rotation_degrees+=270
	if from == "right":
		currentFacingDir=facing.RIGHT
		rotation_degrees+=90
	if from == "up":
		currentFacingDir=facing.UP
		
	pass
	
func getCurrentFacingDir():
	return currentFacingDir
	pass
