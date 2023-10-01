extends AIState
class_name AIStateFetchProduct


func enter():
    
    if not isTargetProductAvailable():
        print('Target product is not available')
        customer.dropItem()
        call_deferred('transition', 'idle')
        return
    
    customer.targetPosition = customer.targetProduct.global_position
    agent.target_position = customer.targetProduct.global_position
    
    animation.play('walk')
    
func exit():
    
    customer.targetPosition = customer.global_position
    agent.target_position = customer.targetPosition
    agent.velocity = Vector2.ZERO
    
    animation.play('idle')

func physicsUpdate(_delta):
    
    if not isTargetProductAvailable():
        print('Target product is not available')
        customer.dropItem()
        emit_signal('transition', 'idle')
        return
    
    if not agent.is_target_reachable():
        print('Target product is not reachable')
        customer.dropItem()
        emit_signal('transition', 'idle')
        return
    
    if agent.is_navigation_finished() or agent.distance_to_target() < 16:
        
        if customer.isCarryingAnything():
            emit_signal('transition', 'drop-basket-for-product')
            return
        
        print('Picking the product')
        customer.pickItem(customer.targetProduct)
        emit_signal('transition', 'put-into-basket')
        return
    
    var nextPathPosition := agent.get_next_path_position()
    var newVelocity := nextPathPosition - customer.global_position
    
    newVelocity = newVelocity.normalized()
    newVelocity = newVelocity * customer.walkSpeed

    agent.velocity = newVelocity


func isTargetProductAvailable() -> bool:
    
    if not customer.targetProduct: return false
    if not is_instance_valid(customer.targetProduct): return false
    
    var parent = customer.targetProduct.get_parent()
    if not parent: return false
    if parent.name == 'level': return true # on the floor
    
    if parent.name == 'container':
        var container = parent.get_parent()
        if not container is ItemContainer: return false
        
        return container.capacity == 1
    
    return false
