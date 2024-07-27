extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("/root/Node2D/BaseChar")
	var parent = get_parent()
	target_position = to_local(player.position)
	if get_collider() == player:
		parent.visible = true;
	
	else:
		parent.visible = false
	
