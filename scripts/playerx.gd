extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var jumping = 0
var ducking = 0
var move = 1
var run = 0

var game

func _physics_process(delta: float) -> void:
	if!move:return
	
	if not is_on_floor():
		
		velocity += get_gravity()*1.5 * delta
	
	if Input.is_action_pressed("duck") && is_on_floor():
		#print("duc")
		ducking = 1
		#$normal.visible = 0
		#$duck.visible = 1
		$sprite.position.y = -55.5
		$sprite.scale.y =0.264
		
		$col_normal.set_deferred("disabled", 1)
		$col_duck.set_deferred("disabled", 0)
	else:
		ducking = 0
		#$normal.visible = 1
		#$duck.visible = 0
		$sprite.position.y = -108.0
		$sprite.scale.y = 0.454
		
		if is_on_floor():
			if !run:
				$sprite.play("move")
			else:
				$sprite.play("run")
		
		$col_normal.set_deferred("disabled", 0)
		$col_duck.set_deferred("disabled", 1)

	if Input.is_action_just_pressed("jump") && jumping == 0:
		velocity.y = JUMP_VELOCITY
		jumping += 1
		if ($sprite.animation) != "jump":
			$sprite.play("jump")
		
	if is_on_floor():
		jumping = 0
	
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_player_area_body_entered(body: Node2D) -> void:
	#if body != $Area2D && body != $"." && body.name != "ground":
	body.position.y -= 20
	body.get_parent().queue_free()
	game.coin_add()
