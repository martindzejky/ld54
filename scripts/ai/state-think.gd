extends AIState
class_name AIStateThink


func enter():
    
    animation.play('thinking')
    
    # wait for a random amount of time
    await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
    
    
    if customer.wantsList.size() > 1 and not customer.myBasket:
        emit_signal('transition', 'choose-basket')
        return
    
    if customer.wantsList.size() > 0:
        emit_signal('transition', 'choose-product')
        return
    
    if randf() < 0.8:
        
        # do we have any products to pay for?
        if get_tree().get_nodes_in_group('product').any(func (product): return product.customer == customer):
        
            if customer.myBasket:
                emit_signal('transition', 'fetch-basket-pay')
            else:
                emit_signal('transition', 'go-to-cash-desk')
        
        else:
            
            # just leave
            emit_signal('transition', 'leave')
            
        return
    
    # fallback
    emit_signal('transition', 'idle')
