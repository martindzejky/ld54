extends AIState
class_name AIStateLeave


func enter():
    
    var exit := get_tree().get_first_node_in_group('exit')
    assert(exit, 'There is no exit!')
    
    customer.targetPosition = exit.global_position
    agent.target_position = exit.global_position
    
    animation.play('walk')

func physicsUpdate(_delta):
    
    if agent.is_navigation_finished():
        
        if customer.myBasket:
            customer.myBasket.customer = null
        
        customer.queue_free()
        return
    
    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position
    
    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity
