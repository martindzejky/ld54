extends AIState
class_name AIStateChooseProduct


func enter():
    
    if customer.wantsList.size() == 0:
        push_warning('Choose product state entered when wantsList is empty')
        call_deferred('emit_signal', 'transition', 'idle')
        return
    
    var allProducts := get_tree().get_nodes_in_group('product')
    var availableProducts := allProducts.filter(isAvailableProduct)
    
    var wantProduct := customer.wantsList.pick_random() as Product
    var availableWantedProducts := availableProducts.filter(func (product): return product.type == wantProduct.type)
    
    if availableWantedProducts.size() == 0:
        
        print('Cannot find wanted product: ', wantProduct.type)
        
        customer.displayCallout(1, wantProduct)
        animation.play('thinking')
        
        # remove from the wanted list and append to unsatisfied list
        customer.unsatisfiedList.append(wantProduct)
        customer.wantsList.remove_at(customer.wantsList.find(wantProduct))
        
        # wait for a random amount of time
        await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
        
        if randf() < 0.1:
            call_deferred('emit_signal', 'transition', 'leave')
        else:
            call_deferred('emit_signal', 'transition', 'idle')
        
        return
    
    customer.targetProduct = availableWantedProducts[0]
    
    if customer.myBasket:
        call_deferred('emit_signal', 'transition', 'fetch-basket')
    else:
        call_deferred('emit_signal', 'transition', 'fetch-product')
        

func isAvailableProduct(product: Product):
    
    # product is only available when it is in a container with capacity 1,
    # or on the floor
    
    if not product.is_inside_tree(): return false
    
    var parent := product.get_parent()
    if not parent: return false
    if parent.name == 'level': return true # on the floor
    
    if parent.name == 'container':
        var container = parent.get_parent()
        if not container is ItemContainer: return false
        
        return container.capacity == 1
    
    return false

