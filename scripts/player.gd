extends Human
class_name Player



func _physics_process(_delta):

    var moveX := Input.get_axis("move_left", "move_right")
    var moveY := Input.get_axis("move_up", "move_down")
    
    velocity = Vector2(moveX, moveY).normalized() * walkSpeed
    move_and_slide()

func _process(_delta):
    
    if Input.is_action_just_pressed("interact"):
        if isCarryingAnything():
            dropItem()
        else:
            pickItem(null)
