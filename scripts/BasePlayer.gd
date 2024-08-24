extends CharacterBody2D

@export var manual = true

const SPEED = 300.0

var _target

var in_dash = false
const base_dash_time = 0.5
var dash_time_count = 0
const base_dash_cooldown = 1
var  dash_cooldown_count = 0

var in_guard = false;

const R = Color(0.8,0,0)
const G = Color(0,0.5,0)
const B = Color(0,0,1,0.5)
var stance = 2

const base_HP = 10
var HP = 10
const base_SP = 10
var SP = 10

var collider_dmg_list = []	
var dmg_timer = 1

var server_master = false
var online = false
var deal_damage = false
var vitorio = false

func _ready():
	stance_shift(2)
	
func _input(event):
	if(!manual):
		return
	#TODO usar input map
	if event is InputEventKey and !in_dash and !in_guard:
		if event.keycode == 81:
			stance_shift(0)
		elif event.keycode == 69:
			stance_shift(1)
		elif event.keycode == 32:
			stance_shift(2)
	
	if event is InputEventMouseButton:
		if event.button_index == 1 and dash_cooldown_count > base_dash_cooldown and !in_guard and SP>4:
			_target = position.direction_to(get_global_mouse_position())
			dash(true)
			sp_change(-5)
			dash_cooldown_count = 0
		elif event.button_index == 2:
			guard(event.pressed and !in_dash)
			
func guard(on):
	get_child(2).visible = on
	in_guard = on
	velocity.x = 0
	velocity.y = 0
	
func dash(on):
	in_dash = on;
	get_child(3).visible = on;

	
	
func _physics_process(delta):
	if(!manual):
		dash(in_dash)
		guard(in_guard)
		deal_damage = in_dash
		move_and_slide()
		stance_shift(stance)
		return
	dash_cooldown_count += delta;
	if !in_guard:
		if in_dash: 
			dash_moviment(delta)
		else:
			look_at(get_global_mouse_position())
			base_moviment()
			if SP < base_SP:
				sp_change(delta)
				
	colliders_dmg_maneger(delta)
	move_and_slide()


func base_moviment():

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)


func dash_moviment(delta):
		
	velocity = _target * SPEED*2
	dash_time_count += delta

	if dash_time_count > base_dash_time:
		dash(false)
		dash_time_count = 0

func stance_shift(s):
	var c
	if s == 0: 
		c = R
	elif s == 1:	
		c = G
	elif s == 2:	
		c = B
	else:
		c = B
		
	stance = s	
	
	get_child(2).modulate = c;
	get_child(3).modulate = c;
	
func sp_change(stamina):
	SP = SP + stamina
	 	

func hp_change(damage):
	HP = HP + damage

func colliders_dmg_maneger(delta):
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if "deal_damage" in collider and collider.deal_damage:
			if collider not in collider_dmg_list:
				collider_dmg_list.append(collider)
				
	if !collider_dmg_list.is_empty():
		if dmg_timer <= 0:
			while !collider_dmg_list.is_empty():
				var mod = 1
				var s = collider_dmg_list.pop_front().stance
				if s!=stance:
					if (s > stance and s+stance != 2) or (s < stance and s+stance == 2):
						mod = 0.5
					else:
						mod = 2

				if in_guard and SP > 2:
					sp_change(-2*mod)	
				else:
					hp_change(-1*mod)

			dmg_timer = 1
		else:
			dmg_timer -= delta

func to_json():
	var dictionary = {
		"name":name,
		#"velocity":var_to_str(velocity),
		"rotation":transform.get_rotation(),
		"position":var_to_str(position),
		"stance":stance,
		"in_dash":in_dash,
		"in_guard":in_guard
	}

	return JSON.stringify(dictionary)	

func from_json(json_string):
	var data = JSON.parse_string(json_string)
	#velocity = str_to_var(data['velocity'])
	rotation = data.rotation
	position = str_to_var(data['position'])
	stance = data.stance
	in_dash = data.in_dash
	in_guard = data.in_guard
	print(data.rotation)

