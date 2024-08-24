extends Node2D

var player
var remoter
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/BaseChar")
	remoter = get_node("/root/Node2D/RemotChar") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
