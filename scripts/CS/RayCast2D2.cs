using Godot;
using System;

public partial class RayCast2D : Godot.RayCast2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta){
		CharacterBody2D player = GetNode<CharacterBody2D>("/root/Node2D/BaseChar");
		Node2D parent = GetParent<Node2D>();
		TargetPosition = ToLocal(player.Position);
		if (GetCollider() == player){
			GD.Print("true");
			parent.Visible = true;
		}
		else{
			GD.Print("false");
			parent.Visible = false;
		}
	}
}
	
