using Godot;
using System;

public partial class CharacterBody2D : Godot.CharacterBody2D
{
	public const float Speed = 300.0f;
	private Vector2 _target;
	
	private bool in_dash = false;
	private const double base_dash_time = 0.5;
	private double dash_time_count = 0;
	private const double base_dash_cooldown = 1;
	private double dash_cooldown_count = 0;
	private bool in_guard = false;
	
	private Color R = new Color(0.8f,0,0);
	private Color G = new Color(0,0.5f,0);
	private Color B = new Color(0,0,1,0.5f);
	

	
	public override void _Input(InputEvent @event){

		if(@event is InputEventKey eventKey
			&& !in_dash && !in_guard){
			if((int)eventKey.Keycode == 81)
				stanceShift(0);
			else if((int)eventKey.Keycode == 69)
				stanceShift(1);
			else if((int)eventKey.Keycode == 32)
				stanceShift(2);
		}
		if (@event is InputEventMouseButton eventMouseButton){
			if((int)eventMouseButton.ButtonIndex == 1
			&& dash_cooldown_count > base_dash_cooldown
			&& !in_guard){
				
				_target = Position.DirectionTo(GetGlobalMousePosition());
				in_dash = true;
				GetChild<Sprite2D>(3).Visible = true;
				dash_cooldown_count = 0;
			}
			else if((int) eventMouseButton.ButtonIndex == 2){
				if(eventMouseButton.Pressed && !in_dash){
					GetChild<Sprite2D>(2).Visible = true;
					in_guard = true;
				}

				else{
					GetChild<Sprite2D>(2).Visible = false;
					in_guard = false;
				}
			}	
			
		}
	}
	
	public override void _PhysicsProcess(double delta)
	{

		dash_cooldown_count = dash_cooldown_count + delta;
		if(!in_guard){
			if(in_dash){
			dashMoviment(delta);
			}
			else{
				baseMoviment();
			}
			MoveAndSlide();
		}
		var spaceState = GetWorld2D().DirectSpaceState;
		// use global coordinates, not local to node
		var query = PhysicsRayQueryParameters2D.Create(Vector2.Zero, new Vector2(50, 100));
		var result = spaceState.IntersectRay(query);
		
		
	}

	private void dashMoviment(double delta){
		
		Velocity = _target * Speed*2;
		dash_time_count = dash_time_count + delta;

		if(dash_time_count > base_dash_time){
			in_dash = false;
			GetChild<Sprite2D>(3).Visible = false;

			dash_time_count = 0;
		}
	}
	private void baseMoviment(){
		LookAt(GetGlobalMousePosition());
		Vector2 velocity = Velocity;
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");

		if (direction != Vector2.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Y = direction.Y * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Y = Mathf.MoveToward(Velocity.Y, 0, Speed);
		}

		Velocity = velocity;
	}
	
	private void stanceShift(int i){
		Color c;
		if(i == 0)
			c = R;
		else if(i == 1)	
			c = G;
		else if(i == 2)	
			c = B;
		else 
		 c = new Color(0,0,0);
		
		GetChild<Sprite2D>(2).Modulate = c;
		GetChild<Sprite2D>(3).Modulate = c;
		
	} 
}
