extends AIState
class_name AIStatePutIntoBasket


func enter():
    
    print('Removing target product from the wantsList')
    for i in range(customer.wantsList.size()):
        if customer.wantsList[i].type == customer.targetProduct.type:
            customer.wantsList.remove_at(i)
            break
    
    customer.targetProduct.customer = customer
    customer.targetProduct = null
    
    # if this customer does not have a basket, just hold the product in hands and go to the cash desk
    if not customer.myBasket:
        print('Customer does not have a basket to put the product into')
        call_deferred('emit_signal', 'transition', 'idle')
        return
    
    await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
    
    var item = customer.dropItem()
    assert(item, 'Expected to hold an item!')
    customer.myBasket.storeItem(item)
    
    call_deferred('emit_signal', 'transition', 'idle')
