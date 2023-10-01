extends AIState
class_name AIStateChooseBasket


func enter():
    
    var baskets := get_tree().get_nodes_in_group('basket')
    var availableBaskets := baskets.filter(filterAvailableBasket)
    
    if availableBaskets.size() == 0:
        
        # no basket available, there's a small chance of leaving
        print('No basket available')
        
        customer.displayCallout(0)
        animation.play('thinking')
        
        # wait for a random amount of time
        await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
        
        if randf() < 0.2:
            emit_signal('transition', 'leave')
        else:
            emit_signal('transition', 'idle')
        
        return
    
    # choose the first available basket
    customer.myBasket = availableBaskets[0]
    availableBaskets[0].customer = customer
    call_deferred('emit_signal', 'transition', 'idle')

func filterAvailableBasket(basket: Basket) -> bool:
    if not basket.customer:
        return true
        
    if not is_instance_valid(basket.customer):
        return true
    
    return false
