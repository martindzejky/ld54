extends AIState
class_name AIStateFetchBasket


func enter():
    
    assert(customer.myBasket, 'My basket does not exist!')
    
    customer.targetPosition = customer.myBasket.global_position
    agent.target_position = customer.myBasket.global_position
    
    animation.play('walk')

func exit():
    
    customer.targetPosition = customer.global_position
    agent.target_position = customer.targetPosition

func physicsUpdate(_delta):
    
    if customer.myBasket.get_parent().name != 'tiles' and customer.myBasket.get_parent().name != 'level':
        print('Basket is no longer on the floor')
        emit_signal('transition', 'idle')
        return
    
    if agent.is_navigation_finished() or agent.distance_to_target() < 20:
        
        if customer.isCarryingAnything():
            customer.dropItem()
            await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
        
        if customer.myBasket.get_parent().name != 'tiles' and customer.myBasket.get_parent().name != 'level':
            print('Basket is no longer on the floor (while dropping item)')
            emit_signal('transition', 'idle')
            return
        
        print('Picking the basket')
        customer.pickItem(customer.myBasket)
        emit_signal('transition', 'fetch-product')
        return
    
    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position
    
    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity
