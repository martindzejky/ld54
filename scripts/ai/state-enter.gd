extends AIState
class_name AIStateEnter


var exited := false


func enter():
    
    # choose a random new location near the entrance
    customer.targetPosition = customer.global_position + Vector2(randf_range(-32, 0), randf_range(-20, 20))
    agent.target_position = customer.targetPosition
    
    animation.play('walk')
    
    exited = false
    
    # for safety, limit the wander time in case the customer gets stuck
    await get_tree().create_timer(randf_range(3.0, 5.0)).timeout
    
    if not exited:
        emit_signal('transition', 'idle')

func exit():
    
    exited = true
    
    customer.targetPosition = customer.global_position
    agent.target_position = customer.targetPosition
    agent.velocity = Vector2.ZERO

func physicsUpdate(_delta):
    
    if agent.is_navigation_finished():
        emit_signal('transition', 'idle')
        return
    
    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position
    
    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity
