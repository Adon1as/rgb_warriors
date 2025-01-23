extends Node2D

var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/BaseChar")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("/root/Node2D/BaseChar")
	position = player.position + Vector2(20,-20)
	get_node("HP").text = "HP: " + str(int(player.HP))
	get_node("SP").text = "SP:" + str(int(player.SP))
	if(player.online):
		get_node("Text").visible = false
