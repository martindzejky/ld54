extends AIState
class_name AIStateDropBasketForProduct


func enter():
    
    customer.dropItem()
    await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
    call_deferred('emit_signal', 'transition', 'fetch-product')
