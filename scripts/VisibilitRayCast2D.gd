extends RayCast2D

var player
var parent
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/BaseChar")
	parent = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	target_position = to_local(player.position)
	if get_collider() == player:
		parent.visible = true;
	else:
		parent.visible = false
	
	
