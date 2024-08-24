extends Node

var socket = WebSocketPeer.new()
var player
var remoter
var spawn1
var spawn2

func _ready():
	socket.connect_to_url("ws://localhost:8080")
	player = get_node("/root/Node2D/BaseChar")
	remoter = get_node("/root/Node2D/RemotChar")
	spawn1 = get_node("/root/Node2D/Spawn1")
	spawn2 = get_node("/root/Node2D/Spawn2")
func _process(delta):
	socket.poll()
	update()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			read_packet()
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
		
		
func read_packet() :
	var data_to_send = socket.get_packet().get_string_from_utf8()
	var json_string = JSON.stringify(data_to_send)
	var json = JSON.new()
	var error = json.parse(data_to_send)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			if data_received["msg"] == "P1":
				player.position = spawn1.position
				remoter.position = spawn2.position
			if data_received["msg"] == "P2":
				player.position = spawn2.position
				remoter.position = spawn1.position
			if data_received['data'] != "":
				remoter.from_json(data_received['data'])
			return true # Prints array 
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	return false
	
func update():
	var json = json_generatior("update",player.to_json())
	socket.send_text(json)
	
func json_generatior(type, data):
	var dictionary = {
		"type":type,
		"data":data
	}
	return JSON.stringify(dictionary)
