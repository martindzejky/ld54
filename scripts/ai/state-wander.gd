extends AIState
class_name AIStateWander


var exited := false


func enter():
    
    # choose a random new location near the current one
    customer.targetPosition = customer.global_position + Vector2.from_angle(randf_range(0, PI*2)) * randf_range(16, 32)
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

func physicsUpdate(_delta):
    
    if agent.is_navigation_finished():
        emit_signal('transition', 'idle')
        return
    
    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position
    
    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity
