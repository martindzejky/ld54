extends Human
class_name Player



func _physics_process(_delta):

    var moveX := Input.get_axis("move_left", "move_right")
    var moveY := Input.get_axis("move_up", "move_down")
    var moveInput := Vector2(moveX, moveY).normalized()
    
    if moveInput.length_squared() > 0:
        $"interaction-area".position = Vector2(0, -2.0) + moveInput * Vector2(8.0, 7.0)
    
    velocity = moveInput * walkSpeed
    move_and_slide()

func _process(_delta):
    
    if Input.is_action_just_pressed("interact"):
        interact()


func interact():
    
    var overlappingBodies := $"interaction-area".get_overlapping_bodies() as Array[Node2D]
    var overlappingAreas := $"interaction-area".get_overlapping_areas() as Array[Area2D]
    
    overlappingBodies.append_array(overlappingAreas)
    overlappingBodies.sort_custom(func (a, b): return $"interaction-area".global_position.distance_to(a.global_position) < $"interaction-area".global_position.distance_to(b.global_position))
    
    # interact with the first interactible overlapping body
    for body in overlappingBodies:
        
        if body.is_in_group('door'):
            (body as Door).toggle()
            return
        if body.is_in_group('door-area'):
            (body.get_parent() as Door).toggle()
            return
    
    # if nothing can be interacted with, the player can drop the item they are carrying
    if isCarryingAnything():
        dropItem()
