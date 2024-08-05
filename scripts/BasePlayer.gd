extends CharacterBody2D

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

const base_HP = 10
var HP = 10
const base_SP = 10
var SP = 10

var collider_dmg_list = []	
var dmg_timer = 1

func _ready():
	stance_shift(2)
	
func _input(event):
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
				in_dash = true;
				get_child(3).visible = true;
				dash_cooldown_count = 0
				sp_change(-5)
			
			elif event.button_index == 2:
				if event.pressed and !in_dash:
					get_child(2).visible = true
					in_guard = true
				else:
					get_child(2).visible = false
					in_guard = false	

func _physics_process(delta):
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
		in_dash = false
		get_child(3).visible = false
		dash_time_count = 0

func stance_shift(i):
	var c
	if i == 0: 
		c = R
	elif i == 1:	
		c = G
	elif i == 2:	
		c = B
	else:
		c = B
		
	get_child(2).modulate = c;
	get_child(3).modulate = c;
	
func sp_change(stamina):
	SP = SP + stamina
	print("SP: ", SP)
	 	

func hp_change(damage):
	HP = HP + damage
	print("HP: ", HP)

func colliders_dmg_maneger(delta):
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if "deal_damage" in collider and collider.deal_damage:
			if collider not in collider_dmg_list:
				collider_dmg_list.append(collider)
				
	if !collider_dmg_list.is_empty():
		if dmg_timer <= 0:
			while !collider_dmg_list.is_empty():
				hp_change(-1)
				collider_dmg_list.pop_front()	
			dmg_timer = 1
		else:
			dmg_timer -= delta

	


	
